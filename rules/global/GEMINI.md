# Global Rules — Full-Stack Software Engineering & Design Craftsmanship

These rules apply across all projects and interactions.

## Shell Execution Rules
- Whenever executing PowerShell commands via `pwsh` or `powershell`, ALWAYS include the `-NoProfile` flag (e.g., `pwsh -NoProfile -Command "..."`).
- Avoid loading interactive user profiles during automated terminal tasks, file manipulation, or background execution.

## Core Principles
- Understand requirements before coding. Never guess—ask when uncertain.
- Prioritize correctness, maintainability, and consistency over speed or cleverness.
- Follow existing architecture and project conventions.
- Reuse existing code before creating new abstractions.
- Preserve existing behavior unless explicitly requested otherwise.

## Planning & Execution
For non-trivial work:
- Explain the problem and proposed solution.
- List affected files and possible risks.
- Wait for approval before major refactors or architectural changes.
- Minor isolated fixes may proceed immediately.

## Stack Awareness & Clean Architecture
Detect the project's stack first and apply strict layered clean architecture:

### Python / FastAPI
- Python 3.12+ with native type annotations (`list[str]`, `X | None`).
- Use Pydantic v2 (`BaseModel`, `Field`, `ConfigDict`) for all request/response validation and settings.
- Layered clean architecture: Router -> Service -> Repository.
- Async I/O by default; write unit tests using Pytest with `AsyncMock`.

### AutoHotkey v2 (AHK v2)
- Strict v2 syntax only (never mix legacy v1 syntax).
- Scope hotkeys strictly using `#HotIf`.
- Wrap risky operations in `try/catch` with global error handlers.
- DPI-aware, clean dark-mode GUIs without emoji clutter.

### Node.js / Express / TypeScript
- Layered clean architecture: Controller -> Service -> Repository.
- Keep business logic in services; services return `Result<T, E>`.
- Validate all requests at the edge with Zod before controllers.
- Use central error-handling middleware (4 arguments).

### ASP.NET Core & C#
- MVC / Web API separation: Controllers coordinate, Services contain business logic, Repositories manage EF Core persistence.
- Constructor dependency injection only; use async APIs (`ToListAsync()`, `SaveChangesAsync()`).
- Always map to DTOs; never return EF Core entities directly from controllers.

### React & Next.js
- Functional components, hooks, and feature-sliced folder structure.
- Next.js App Router: Server Components by default; keep `'use client'` strictly at leaf interactive components.
- Custom hooks must support request cancellation (`AbortController`).
- RTK Query for server state caching with tag invalidation.

## UI / UX Design Craftsmanship (Anti-AI-Generic)
- **Reject AI Clichés**: Avoid generic dark slate backgrounds with purple neon gradients and emoji-stuffed buttons.
- **Zero Emojis in UI**: Use clean, precise SVG vector icons (Lucide, Heroicons) instead of emojis.
- **Typography & Color**: Distinctive typography pairings (display header + clean sans-serif body); curated OKLCH / tailored HSL palettes with WCAG AA contrast (4.5:1).
- **Spatial Rhythm**: 8px spatial grid (8/16/24/32/48px) with generous breathing room.
- **Tailwind CSS v4**: CSS-first `@theme` token definitions, container queries (`@container`), and custom `@utility` rules.
- **Micro-Interactions**: Smooth 150-200ms transitions, visible keyboard focus rings, and full reduced-motion respect.

## Testing Mandate
- Mandatory unit testing for all business logic, API validation boundaries, custom hooks, and domain services before completing tasks.
- Follow the AAA (Arrange, Act, Assert) pattern.
- Mock only external boundaries (databases, third-party APIs); never mock the system under test.
- Test tooling: Vitest/RTL (React/Vite), Jest/Supertest (Node), Pytest (Python), xUnit/Moq (C#).

## Living Documentation & Vault Synchronization
- Maintain a `docs/` folder in software projects (`overview.md`, `architecture.md`, `workflows.md` with Mermaid diagrams, `adr/`).
- Seamless interoperability with Obsidian PARA taxonomies.
- Include brief explanations (*what, why, why here*) when introducing new architectural concepts.

## Security & Database
- Never hardcode secrets, tokens, or credentials.
- Parameterized SQL queries only (zero concatenation); explicit schema migrations and index optimization.
- Prevent N+1 query loops using batched fetches or explicit joins.

## Git Safety
- Never run Git commands directly.
- Recommend commit boundaries and provide Conventional Commit messages for the user.

## Style
- No emojis in chat responses or code unless explicitly requested.
