---
name: sql-postgres-supabase
description: Database conventions for SQL Server, PostgreSQL, and Supabase. Use when designing schemas, writing migrations or queries, or setting up Supabase auth and RLS policies, or working with SQL Server through EF Core.
---

# SQL Server / PostgreSQL / Supabase

## When to use this
Designing database schemas, writing migrations/queries, or configuring Supabase RLS policies and SQL Server / EF Core persistence.

## Steps
1. **Parameterized Queries:** Use parameterized SQL queries strictly across all database operations.
2. **Schema Design & Indexing:** Define explicit primary/foreign keys and index join/filter columns. Normalize by default.
3. **Migration Management:** Track and apply all schema migrations in order via repo scripts or ORM migrations.
4. **Engine Specifics:**
   - **PostgreSQL / Supabase:** Enable Row-Level Security (RLS) on client-accessible tables. Keep service-role keys server-side only.
   - **SQL Server:** Enforce access control in repository/service layers, using EF Core migrations as schema source of truth.

## Things to avoid
- Never use string-concatenated SQL queries (prevents SQL injection).
- Avoid manual, undocumented schema changes on live databases.
- Avoid trusting client-side auth checks alone for sensitive operations.
- Avoid N+1 query patterns; use explicit joins or batched fetches.
