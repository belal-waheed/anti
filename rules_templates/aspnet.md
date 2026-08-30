# ASP.NET Core & C# Project Rules

- Enforce clean separation: Controllers coordinate, Services contain logic, Repositories persist via EF Core.
- Constructor dependency injection only.
- Async database APIs by default (SaveChangesAsync(), ToListAsync()).
- Always map to DTOs; never return EF Core entities directly from controllers.
- Write unit tests using xUnit and Moq following AAA pattern.
