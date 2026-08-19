---
name: testing
description: Comprehensive testing conventions and guidance across all stacks — Vitest, React Testing Library, Jest, Supertest, Pytest, xUnit, Moq, and Playwright. Use when writing unit, integration, or E2E tests, setting up test suites, mocking dependencies, or establishing test coverage.
---

# Universal Unit, Integration & E2E Testing Guide

## When to use this skill
Trigger whenever writing unit tests, integration tests, E2E tests, setting up test runners (Vitest, Jest, Pytest, xUnit, Playwright), mocking dependencies, or writing test assertions across any stack.

---

## 1. Universal Testing Principles

1. **Test Behavior, Not Implementation**: Test inputs, outputs, and user interactions. Never assert private internal state or mock internal functions.
2. **Follow the AAA Pattern**: Every test must clearly partition into **Arrange**, **Act**, and **Assert**.
3. **Deterministic & Isolated**: Unit tests must run fast (<50ms per test), in any order, without touching real databases, external networks, or disk persistence (unless explicitly an integration/E2E test).
4. **Descriptive Test Names**: Name tests by their behavior contract: `test('should return 404 when user does not exist')`.

---

## 2. React + TypeScript: Vitest & React Testing Library

```tsx
// src/components/UserCard.test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi } from 'vitest';
import { UserCard } from './UserCard';

describe('UserCard Component', () => {
  it('renders user details and handles click event', async () => {
    // Arrange
    const user = userEvent.setup();
    const mockOnSelect = vi.fn();
    const userData = { id: 'u1', name: 'Belal', role: 'Architect' };

    render(<UserCard user={userData} onSelect={mockOnSelect} />);

    // Assert initial render
    expect(screen.getByRole('heading', { level: 2, name: /belal/i })).toBeInTheDocument();
    expect(screen.getByText(/architect/i)).toBeInTheDocument();

    // Act
    const button = screen.getByRole('button', { name: /select/i });
    await user.click(button);

    // Assert interaction
    expect(mockOnSelect).toHaveBeenCalledTimes(1);
    expect(mockOnSelect).toHaveBeenCalledWith('u1');
  });
});
```

---

## 3. Node.js / Express: Vitest + Mocked Repository

```ts
// src/services/UserService.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { UserService } from './UserService';
import type { IUserRepository } from '../repositories/IUserRepository';

describe('UserService (Unit)', () => {
  let mockRepo: IUserRepository;
  let service: UserService;

  beforeEach(() => {
    mockRepo = {
      findById: vi.fn(),
      create: vi.fn(),
      update: vi.fn(),
      delete: vi.fn(),
    };
    service = new UserService(mockRepo);
  });

  it('successfully creates a user when email is unique', async () => {
    // Arrange
    const inputDto = { email: 'user@example.com', name: 'Test User' };
    const savedUser = { id: 'usr-1', ...inputDto, createdAt: new Date() };
    
    vi.mocked(mockRepo.findById).mockResolvedValue(null);
    vi.mocked(mockRepo.create).mockResolvedValue(savedUser);

    // Act
    const result = await service.createUser(inputDto);

    // Assert
    expect(result.isSuccess).toBe(true);
    expect(result.value).toEqual(savedUser);
    expect(mockRepo.create).toHaveBeenCalledWith(inputDto);
  });

  it('fails with conflict error if user already exists', async () => {
    // Arrange
    vi.mocked(mockRepo.findById).mockResolvedValue({ id: 'existing', email: 'user@example.com', name: 'Existing' } as any);

    // Act
    const result = await service.createUser({ email: 'user@example.com', name: 'Test' });

    // Assert
    expect(result.isSuccess).toBe(false);
    expect(result.error).toMatch(/already exists/i);
    expect(mockRepo.create).not.toHaveBeenCalled();
  });
});
```

---

## 4. Python: Pytest & Async Mocking

```python
# tests/unit/test_order_service.py
import pytest
from unittest.mock import AsyncMock
from src.services.order_service import OrderService
from src.schemas.order import OrderCreate, OrderResponse

@pytest.fixture
def mock_order_repo() -> AsyncMock:
    return AsyncMock()

@pytest.fixture
def order_service(mock_order_repo: AsyncMock) -> OrderService:
    return OrderService(repository=mock_order_repo)

@pytest.mark.asyncio
async def test_calculate_discount_applied_correctly(order_service: OrderService, mock_order_repo: AsyncMock):
    # Arrange
    order_data = OrderCreate(total=100.0, coupon="SAVE20")
    mock_order_repo.save.return_value = OrderResponse(id="ord_1", final_price=80.0)

    # Act
    response = await order_service.process_order(order_data)

    # Assert
    assert response.final_price == 80.0
    mock_order_repo.save.assert_awaited_once()
```

---

## 5. C# / ASP.NET Core: xUnit + Moq + FluentAssertions

```csharp
// tests/UnitTests/Services/ProductServiceTests.cs
using System.Threading.Tasks;
using Xunit;
using Moq;
using FluentAssertions;
using App.Core.Services;
using App.Core.Interfaces;
using App.Core.DTOs;
using App.Core.Entities;

public class ProductServiceTests
{
    private readonly Mock<IProductRepository> _mockRepo;
    private readonly ProductService _service;

    public ProductServiceTests()
    {
        _mockRepo = new Mock<IProductRepository>();
        _service = new ProductService(_mockRepo.Object);
    }

    [Fact]
    public async Task GetByIdAsync_WhenProductExists_ReturnsProductDto()
    {
        // Arrange
        var productId = 10;
        var entity = new Product { Id = productId, Name = "Laptop", Price = 1200m };
        _mockRepo.Setup(r => r.GetByIdAsync(productId)).ReturnsAsync(entity);

        // Act
        var result = await _service.GetByIdAsync(productId);

        // Assert
        result.Should().NotBeNull();
        result.Id.Should().Be(productId);
        result.Name.Should().Be("Laptop");
        _mockRepo.Verify(r => r.GetByIdAsync(productId), Times.Once);
    }
}
```

---

## Things to Avoid

- Never mock the system under test (SUT) — mock only external boundaries (database repositories, third-party APIs, timers).
- Avoid assertions without failure clarity (use specific assertions: `toBeInTheDocument()` instead of `toBeTruthy()`).
- Avoid testing trivial boilerplate (e.g. standard getters/setters or raw framework config).
- Never ignore intermittent/flaky tests — isolate timers, random seeds, and async flush issues immediately.
