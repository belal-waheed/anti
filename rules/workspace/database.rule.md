# Workspace Rule: Database Persistence Standards

- All database access must go through repository interfaces.
- Use explicit schema migrations for all structural modifications.
- Ensure proper indexing on foreign keys and frequently queried filter columns.
- Zero string concatenation in SQL queries.
