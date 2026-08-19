---
name: prisma-orm
description: Conventions for using Prisma ORM with TypeScript and PostgreSQL/SQL databases. Use when writing Prisma schema models, migrations, or database queries through the Prisma client.
---

# Prisma ORM

## When to use this
Any project using Prisma ORM as the database layer (typically with PostgreSQL).

## Steps
1. **Schema Design:** Maintain one `schema.prisma`, use PascalCase singular models, define explicit `@relation`s, and set `@@index`/`@@unique` on frequent query filters. Run all migrations through `prisma migrate dev`.
2. **Client Management:** Keep PrismaClient inside a repository layer behind a singleton module. Services/controllers never import `PrismaClient` directly.
3. **Optimized Queries:** Use `select`/`include` deliberately. Wrap multi-step atomic writes in `prisma.$transaction`.
4. **Error Handling:** Catch Prisma known error codes (e.g. unique constraint violations) at the repository boundary and translate them into domain failure types.

## Things to avoid
- Never import `PrismaClient` directly into services or controllers.
- Avoid creating a new `PrismaClient()` per request (causes connection exhaustion).
- Avoid manual schema edits directly against a live database.
- Don't let raw Prisma database errors leak up past the repository layer.
