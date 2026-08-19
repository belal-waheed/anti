# Global Rule: Testing Mandates & Quality Gate

1. **Mandatory Coverage for New Logic**:
   Every service, utility, custom hook, and API endpoint must be accompanied by comprehensive unit tests.

2. **The AAA Pattern**:
   Structure all test suites with explicit Arrange, Act, Assert sections.

3. **Mocking Principles**:
   - Mock only external boundaries (HTTP APIs, file system, database connections).
   - Never mock the system under test.
   - Use strongly-typed mocks (e.g., `AsyncMock` in Python, `vi.fn()` in Vitest, `Moq` in C#).
