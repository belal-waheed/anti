# Global Rule: Layered Clean Architecture

All backends and domain codebases must strictly enforce single-responsibility layered separation:

```text
[HTTP Router / Controller / Endpoint]
        | (Validates request schema with Pydantic / Zod / FluentValidation)
        v
[Domain Service Layer]
        | (Pure business logic, orchestration, returns Result<T, E>)
        v
[Repository Layer / Data Access]
        | (Database queries, ORM persistence, EF Core / Prisma / Mongoose / SQL)
        v
[Database / External APIs]
```

## Rules:
1. Controllers must NEVER contain business logic or raw database queries.
2. Services must NEVER depend directly on HTTP request/response objects.
3. Repositories must encapsulate all query mechanics and return domain entities / DTOs.
4. Always use Dependency Injection (DI) rather than global singleton state.
