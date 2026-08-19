---
name: project-docs
description: Living documentation standards, Mermaid architecture diagrams, Architecture Decision Records (ADRs), and Obsidian vault documentation sync bridges. Use when structuring a project's docs/ directory, explaining architectural flows, or generating markdown documentation for Obsidian vaults.
---

# Living Project Documentation & Obsidian Integration Guide

## When to use this skill
Trigger whenever establishing or maintaining a project's `docs/` folder, creating architecture diagrams, drafting Architecture Decision Records (ADRs), or syncing technical documentation into an Obsidian vault.

---

## 1. Living Documentation Structure

Every non-trivial project should maintain a standardized `docs/` folder at its root:

```
docs/
  ├── overview.md       # Product vision, high-level features, tech stack
  ├── architecture.md   # Layered system architecture, boundary contracts
  ├── workflows.md      # End-to-end data flows with Mermaid sequence diagrams
  └── adr/              # Architecture Decision Records
       └── 0001-record-architecture-decisions.md
```

---

## 2. Standard Templates

### A. Architecture Document (`docs/architecture.md`)
```markdown
# System Architecture

## Component Overview

\`\`\`mermaid
graph TD
    Client[Client App / UI] -->|REST API| API[API Gateway / Router]
    API --> Controller[Controllers]
    Controller --> Service[Domain Services]
    Service --> Repo[Repository Layer]
    Repo --> DB[(Primary Database)]
    Service --> Cache[(Redis Cache)]
\`\`\`

## Layer Responsibilities
1. **Presentation / API**: Request validation (Zod / Pydantic) and status code formatting.
2. **Domain Service**: Business invariants, authorization rules, orchestration.
3. **Persistence / Data**: Typed queries, transactions, schema migrations.
```

### B. Architecture Decision Record (`docs/adr/0001-template.md`)
```markdown
# ADR 0001: [Decision Title]

- **Status**: [Proposed | Accepted | Superseded]
- **Date**: YYYY-MM-DD
- **Author**: [Name]

## Context & Problem Statement
What problem are we trying to solve? What constraints exist?

## Considered Options
1. Option 1: [Description]
2. Option 2: [Description]

## Decision & Rationale
We chose **Option 1** because [specific architectural/business reasons].

## Consequences
- **Positive**: [Benefits]
- **Negative / Trade-offs**: [Trade-offs accepted]
```

---

## 3. Obsidian Vault Sync Bridge

To sync application docs directly into your Obsidian vault (`d:\belal\obsidian\hola`):

1. **Project Hubs**: Colocate docs under `projects/[project-name]/` with a folder hub note `projects/[project-name]/_[project-name].md`.
2. **Global References & Cheat Sheets**: Place standalone guides and technical cheat sheets into `areas/tech/[domain]/` (e.g. `areas/tech/backend/`, `areas/tech/devops/`).
3. **Wikilinks & Frontmatter**: Use standard Obsidian frontmatter on all synced docs:
   ```markdown
   ---
   type: project-doc
   project: my-awesome-app
   date: 2026-08-18
   tags: [architecture, docs]
   ---
   ```

---

## Things to Avoid

- Avoid outdated documentation: update `docs/` in the same commit pass as significant architectural changes.
- Avoid over-complicating Mermaid diagrams with minor private implementation details.
- Avoid committing secrets or live production credentials into documentation files.