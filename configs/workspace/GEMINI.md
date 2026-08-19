# Project Rules & Workspace Guidelines

## Stack Conventions
- Clean layered architecture: Controllers / Routers -> Services -> Repositories.
- Strict typing with schema validation at all entry points.
- Async I/O for database queries and external network calls.

## Safety & Testing
- Run test suite before committing code.
- Zero hardcoded credentials; use `.env` files.
