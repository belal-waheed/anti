---
name: python-clean-architecture
description: Production conventions for modern Python 3.12+ development, FastAPI, Pydantic v2, layered clean architecture (Router -> Service -> Repository), and Pytest unit testing suites. Use when building Python APIs, CLI tools, services, or writing Python unit tests.
---

# Python Clean Architecture & FastAPI Guide

## When to use this skill
Trigger whenever building, refactoring, or testing modern Python 3.12+ applications, FastAPI backends, domain services, or writing Pytest test suites.

---

## 1. Core Principles & Modern Python 3.12+

- **Strict Type Annotations**: Use native Python 3.12+ type syntax (`list[str]`, `dict[str, Any]`, `X | None` instead of `Optional[X]`).
- **Data Validation & Serialization**: Use **Pydantic v2** (`BaseModel`, `Field`, `ConfigDict`) for all API contracts and configuration settings.
- **Layered Clean Architecture**:
  - **Router / Controller**: Handles HTTP parsing, status codes, and dependency injection (`Depends`). Never executes business logic or DB queries directly.
  - **Service Layer**: Pure business logic, coordinates repositories, and raises domain-specific exceptions.
  - **Repository Layer**: Encapsulates database queries (SQLAlchemy, Motor, PGVector, etc.) behind clean Protocol/Interface contracts.
- **Async by Default**: Use `async def` for I/O operations and non-blocking database queries.

---

## 2. Directory Structure

```
src/
  ├── api/
  │    └── v1/
  │         └── items.py       # FastAPI Route Handlers
  ├── core/
  │    ├── config.py           # Pydantic BaseSettings
  │    └── exceptions.py       # Domain Exceptions
  ├── schemas/
  │    └── item.py             # Pydantic Request/Response Models
  ├── services/
  │    └── item_service.py     # Business Logic Layer
  ├── repositories/
  │    └── item_repository.py  # Data Persistence Layer
  └── main.py                  # App Entrypoint & Middleware
tests/
  ├── conftest.py              # Pytest Fixtures & Test Client
  ├── unit/
  │    └── test_item_service.py # Unit Tests with Mocks
  └── integration/
       └── test_items_api.py   # API Integration Tests
```

---

## 3. Production Code Patterns

### A. Pydantic v2 Schema
```python
# src/schemas/item.py
from datetime import datetime
from pydantic import BaseModel, ConfigDict, Field

class ItemBase(BaseModel):
    title: str = Field(..., min_length=1, max_length=100)
    description: str | None = Field(default=None, max_length=500)
    price: float = Field(..., gt=0.0)

class ItemCreate(ItemBase):
    pass

class ItemResponse(ItemBase):
    id: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
```

### B. Repository Protocol & Implementation
```python
# src/repositories/item_repository.py
from typing import Protocol
from src.schemas.item import ItemCreate, ItemResponse

class ItemRepositoryProtocol(Protocol):
    async def get_by_id(self, item_id: str) -> ItemResponse | None: ...
    async def create(self, data: ItemCreate) -> ItemResponse: ...

class InMemoryItemRepository:
    def __init__(self) -> None:
        self._storage: dict[str, ItemResponse] = {}

    async def get_by_id(self, item_id: str) -> ItemResponse | None:
        return self._storage.get(item_id)

    async def create(self, data: ItemCreate) -> ItemResponse:
        import uuid
        from datetime import datetime, timezone
        
        item_id = str(uuid.uuid4())
        item = ItemResponse(
            id=item_id,
            title=data.title,
            description=data.description,
            price=data.price,
            created_at=datetime.now(timezone.utc)
        )
        self._storage[item_id] = item
        return item
```

### C. Service Layer
```python
# src/services/item_service.py
from src.repositories.item_repository import ItemRepositoryProtocol
from src.schemas.item import ItemCreate, ItemResponse
from src.core.exceptions import ItemNotFoundError

class ItemService:
    def __init__(self, repository: ItemRepositoryProtocol) -> None:
        self.repository = repository

    async def get_item(self, item_id: str) -> ItemResponse:
        item = await self.repository.get_by_id(item_id)
        if not item:
            raise ItemNotFoundError(f"Item with id '{item_id}' was not found.")
        return item

    async def create_item(self, data: ItemCreate) -> ItemResponse:
        # Example domain rule: capitalize title
        data.title = data.title.strip().title()
        return await self.repository.create(data)
```

---

## 4. Comprehensive Pytest Unit & Integration Testing

```python
# tests/unit/test_item_service.py
import pytest
from unittest.mock import AsyncMock
from src.services.item_service import ItemService
from src.schemas.item import ItemCreate, ItemResponse
from src.core.exceptions import ItemNotFoundError
from datetime import datetime, timezone

@pytest.fixture
def mock_repo() -> AsyncMock:
    return AsyncMock()

@pytest.fixture
def service(mock_repo: AsyncMock) -> ItemService:
    return ItemService(repository=mock_repo)

@pytest.mark.asyncio
async def test_create_item_success(service: ItemService, mock_repo: AsyncMock):
    # Arrange
    create_dto = ItemCreate(title="keyboard", description="mechanical", price=99.99)
    expected_response = ItemResponse(
        id="item-123",
        title="Keyboard",
        description="mechanical",
        price=99.99,
        created_at=datetime.now(timezone.utc)
    )
    mock_repo.create.return_value = expected_response

    # Act
    result = await service.create_item(create_dto)

    # Assert
    assert result.id == "item-123"
    assert result.title == "Keyboard"
    mock_repo.create.assert_awaited_once()

@pytest.mark.asyncio
async def test_get_item_not_found_raises_exception(service: ItemService, mock_repo: AsyncMock):
    # Arrange
    mock_repo.get_by_id.return_value = None

    # Act & Assert
    with pytest.raises(ItemNotFoundError) as exc_info:
        await service.get_item("non-existent-id")
    
    assert "non-existent-id" in str(exc_info.value)
    mock_repo.get_by_id.assert_awaited_once_with("non-existent-id")
```

---

## Things to Avoid

- Never mix database queries inside FastAPI route definitions (`@app.get(...)`).
- Avoid catching generic `Exception` without logging or re-raising domain exceptions.
- Avoid using legacy `dict()` on Pydantic v2 models — always use `.model_dump()` or `.model_dump_json()`.
- Avoid mutable default arguments in functions (e.g. `def foo(items=[])`).
- Never skip type hints on public methods and API endpoints.
