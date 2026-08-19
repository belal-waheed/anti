# Workspace Rule: Backend Engineering Standards

- Enforce layered architecture: Router -> Service -> Repository.
- Validate all incoming payloads with strongly-typed schemas (Pydantic / Zod).
- Return standard structured error responses with HTTP status codes.
- Implement automated unit tests for all domain services.
