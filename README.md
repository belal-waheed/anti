# Antigravity Hub — Master Agentic Knowledge Base & Ecosystem

An open-standard, universal AI pair-programming repository containing the complete architecture documentation, global engineering rules, 40+ modular production skills, plugin bundles, lifecycle hooks, and Model Context Protocol (MCP) tool configurations for **Google Antigravity (AGY)** and modern AI coding agents.

---

## Agent Quickstart & Operational Protocol

> **ATTENTION AI AGENTS (Antigravity, Cursor, Windsurf, Claude Code, Roo Code, Aider, Copilot):**
> When working within or utilizing this repository, follow this deterministic operational loop:

```text
[1. Ingest Task] ---> [2. Match Skill] ---> [3. Load Rules] ---> [4. Plan / Execute]
       |                      |                    |                      |
       v                      v                    v                      v
Identify domain/stack   Read `SKILL.md` in    Check `rules/global/`   Enforce Clean Arch &
from user request       `skills/global/<x>`   for stack standards     run unit tests
```

### Agent Ingestion Flow:
1. **Identify the Task Domain**: Match the user's objective to the [Skills Directory Index](#5-skills-library-catalog--triggers).
2. **Read the Relevant Skill**: Open `skills/global/<skill-name>/SKILL.md` to load specific procedural runbooks, step-by-step procedures, and progressive disclosure references (`references/`).
3. **Enforce Engineering Rules**: Always review [rules/global/GEMINI.md](rules/global/GEMINI.md) for strict Clean Architecture, `-NoProfile` shell execution, anti-AI-generic UI craftsmanship, and testing mandates.
4. **Deploy to New Projects**: If instructed to initialize a project or sync skills, use the automation scripts in [scripts/](#3-automation--synchronization-scripts).

---

## 1. Repository Layout

```text
antigravity-hub/
├── README.md                           # Master ecosystem guide & universal agent protocol
├── AGENTS.md                           # Direct operational instructions for autonomous agents
├── GEMINI.md                           # Root repository engineering & stack guidelines
├── LICENSE                             # MIT Open Source License
├── .gitignore                          # Safe credential & artifact ignore rules
│
├── docs/                               # 14 Comprehensive Technical Specifications
│   ├── overview.md                     # Antigravity Architecture & Mental Model
│   ├── surfaces/                       # CLI (`agy`), IDE, Antigravity 2.0 Desktop, Python SDK
│   │   ├── cli.md
│   │   ├── ide.md
│   │   ├── app.md
│   │   └── sdk.md
│   ├── customizations/                 # Rules, Skills, Plugins, Hooks, MCP & JSON Configs
│   │   ├── rules.md
│   │   ├── skills.md
│   │   ├── plugins.md
│   │   ├── hooks.md
│   │   ├── mcp.md
│   │   └── json-configs.md
│   └── workflows/                      # Planning Mode, Subagent Delegation, Background Schedulers
│       ├── pair-programming.md
│       ├── subagents-orchestration.md
│       └── background-tasks.md
│
├── rules/                              # Rules Ecosystem
│   ├── global/                         # Global standards (GEMINI.md, Clean Arch, Testing, UI/UX)
│   │   ├── GEMINI.md
│   │   ├── shell-execution.md
│   │   ├── clean-architecture.md
│   │   ├── ui-ux-craftsmanship.md
│   │   ├── testing-mandates.md
│   │   ├── obsidian-sync.md
│   │   └── security-git-safety.md
│   └── workspace/                      # Scaffolds for project `.agents/rules/`
│       ├── backend.rule.md
│       ├── frontend.rule.md
│       └── database.rule.md
│
├── skills/                             # 40+ Categorized Production Skills
│   ├── builtin/                        # Core system skills (agy-customizations, guide, github)
│   │   ├── agy-customizations/
│   │   ├── antigravity_guide/
│   │   └── permissioned-github/
│   ├── global/                         # 37 Production skills (Python, React, AHK, Devops, RAG, etc.)
│   └── templates/                      # Standard progressive disclosure skill scaffold
│       └── skill-template/
│
├── plugins/                            # Plugin Bundles & Scaffolds
│   ├── google-antigravity-sdk/         # Official Python SDK plugin
│   ├── modern-web-guidance-plugin/     # Modern web development plugin
│   └── starter-plugin-template/        # Plugin boilerplate manifest & folder layout
│
├── configs/                            # Ready-to-Use Configuration Templates
│   ├── workspace/                      # Scaffold `.agents/` folder for project roots
│   │   ├── GEMINI.md
│   │   ├── hooks.json
│   │   ├── mcp_config.json
│   │   ├── skills.json
│   │   └── plugins.json
│   └── global/                         # Scaffold `~/.gemini/config/` settings and MCPs
│       ├── config.example.json
│       └── mcp_config.example.json
│
├── mcp/                                # Model Context Protocol Catalog & Development
│   ├── configs/                        # Sanitized configs (GitHub, Memory, Postgres, Resend, Stripe, SQLite)
│   ├── guides/                         # Server setup guides and tool catalogs
│   └── scaffolds/                      # Custom MCP server boilerplate (Python FastMCP & TypeScript SDK)
│       ├── python-mcp-server/
│       └── typescript-mcp-server/
│
└── scripts/                            # PowerShell Automation Scripts (-NoProfile)
    ├── sync-to-global.ps1              # Deploys skills, rules, and plugins to ~/.gemini/config/
    └── init-workspace.ps1              # Initializes .agents/ bundle in any project repository
```

---

## 2. Universal Customization Hierarchy

Antigravity and compliant agents load customizations in strict deterministic order (highest to lowest priority):

1. **Workspace Project**: Hierarchical discovery walking from the current working directory to the repository root (`.agents/`, `GEMINI.md`, `AGENTS.md`).
2. **Explicit Workspace Registrations**: Customizations explicitly declared in `.agents/skills.json` or `.agents/plugins.json`.
3. **Global Customizations**: Discovered in `~/.gemini/config/` (`skills/`, `plugins/`, `rules/`).
4. **Built-in System Skills**: Bundled agent runtime skills (`agy-customizations`, `antigravity_guide`, `permissioned-github`).
5. **Global Explicit Registrations**: Declared in global JSON configs.

---

## 3. Automation & Synchronization Scripts

### A. Sync All Skills & Rules Globally
Deploys all global skills and rules from this repository into the host's `~/.gemini/config/` directory:
```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File ./scripts/sync-to-global.ps1
```

### B. Bootstrap `.agents/` in Any New Project Repository
Injects an `.agents/` workspace bundle (rules, hooks, skills declaration, MCP template) into any target project:
```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File ./scripts/init-workspace.ps1 -TargetDirectory "C:/path/to/project"
```

---

## 4. Rules Matrix

| Rule | Location | Key Enforcements |
| :--- | :--- | :--- |
| **Global Master Rules** | [rules/global/GEMINI.md](rules/global/GEMINI.md) | Universal engineering principles, stack architecture, testing, UI/UX, Git safety. |
| **Shell Execution** | [rules/global/shell-execution.md](rules/global/shell-execution.md) | Mandatory `-NoProfile` flag on PowerShell, non-interactive execution safety. |
| **Clean Architecture** | [rules/global/clean-architecture.md](rules/global/clean-architecture.md) | Layered separation: Router -> Service -> Repository; DTO mapping; DI. |
| **UI/UX Craftsmanship** | [rules/global/ui-ux-craftsmanship.md](rules/global/ui-ux-craftsmanship.md) | Anti-AI-generic design; zero emojis in UI (use Lucide SVG); WCAG AA; 8px spatial grid. |
| **Testing Mandates** | [rules/global/testing-mandates.md](rules/global/testing-mandates.md) | AAA pattern; mandatory unit tests for all domain logic; boundary mocking only. |
| **Obsidian Sync** | [rules/global/obsidian-sync.md](rules/global/obsidian-sync.md) | Daily plan alignment; post-work task completion (`- [x]`); living docs sync. |
| **Security & Git** | [rules/global/security-git-safety.md](rules/global/security-git-safety.md) | Parameterized SQL queries; zero hardcoded secrets; conventional commit suggestions. |

---

## 5. Skills Library Catalog & Triggers

All skills follow the progressive disclosure format (`SKILL.md` + optional `scripts/` and `references/`):

### Core & System
- **[agy-customizations](skills/builtin/agy-customizations/SKILL.md)**: Customization engine, loading priority, hooks, and discovery mechanisms.
- **[antigravity_guide](skills/builtin/antigravity_guide/SKILL.md)**: Master sitemap for Antigravity CLI (`agy`), IDE, Desktop App 2.0, and Python SDK.
- **[permissioned-github](skills/builtin/permissioned-github/SKILL.md)**: GitHub operations with permission gating and safety checks.

### Backend Architecture & Languages
- **[python-clean-architecture](skills/global/python-clean-architecture/SKILL.md)**: Python 3.12+, FastAPI, Pydantic v2, Router -> Service -> Repository, Pytest `AsyncMock`.
- **[node-express-mongo](skills/global/node-express-mongo/SKILL.md)**: Node.js, Express, MongoDB, Mongoose, TypeScript, generic repositories, Zod edge validation.
- **[aspnet-mvc-ef](skills/global/aspnet-mvc-ef/SKILL.md)**: ASP.NET Core Web API / MVC, EF Core, repository pattern, async queries, xUnit unit testing.
- **[autohotkey-v2](skills/global/autohotkey-v2/SKILL.md)**: Strict AutoHotkey v2 syntax, `#HotIf` scoping, dark-mode GUIs, single-instance management.
- **[powershell-automation](skills/global/powershell-automation/SKILL.md)**: PowerShell 7+ automation, `-NoProfile` conventions, WinRT toast notifications, Task Scheduler.
- **[prisma-orm](skills/global/prisma-orm/SKILL.md)**: Prisma schema modeling, relations, and database migrations.
- **[sql-postgres-supabase](skills/global/sql-postgres-supabase/SKILL.md)**: PostgreSQL, SQL Server, Supabase Auth and Row Level Security (RLS) policies.
- **[redis-caching](skills/global/redis-caching/SKILL.md)**: Redis caching, session stores, and rate-limiting patterns.
- **[mongoose-typescript](skills/global/mongoose-typescript/SKILL.md)**: Strongly-typed Mongoose schemas, document methods, and model repositories.

### Frontend Engineering & UI Craftsmanship
- **[react-frontend](skills/global/react-frontend/SKILL.md)**: Feature-sliced React + TypeScript, custom hooks with `AbortController` cancellation, Vitest.
- **[react-patterns](skills/global/react-patterns/SKILL.md)**: Advanced React 19 Server Components, Server Actions, `useActionState`, Suspense boundaries.
- **[tailwind-v4](skills/global/tailwind-v4/SKILL.md)**: Tailwind CSS v4 CSS-first `@theme` tokens, container queries (`@container`), custom `@utility` rules.
- **[ui-ux-design](skills/global/ui-ux-design/SKILL.md)**: Anti-AI-generic bespoke UI design, 8px grid, WCAG AA contrast (4.5:1), SVG vector icons.
- **[animation-gsap-motion](skills/global/animation-gsap-motion/SKILL.md)**: Framer Motion transitions and GSAP ScrollTrigger timelines with `useGSAP` cleanup.
- **[state-redux-toolkit](skills/global/state-redux-toolkit/SKILL.md)**: Redux Toolkit (RTK) state slices and RTK Query with tag cache invalidation.
- **[pwa-service-worker](skills/global/pwa-service-worker/SKILL.md)**: Progressive Web Apps, service worker caching strategies, offline fallbacks, web manifests.
- **[d3-visualization-guide](skills/global/d3-visualization-guide/SKILL.md)**: Publication-quality interactive data visualizations with D3.js.
- **[html-slides](skills/global/html-slides/SKILL.md)**: Standalone single-file interactive presentation slideshows.

### AI, Reasoning & Debugging
- **[rag-ai-systems](skills/global/rag-ai-systems/SKILL.md)**: Document chunking pipelines, vector databases (PGVector, Chroma), hybrid BM25 + dense search.
- **[structured-clear-thinking](skills/global/structured-clear-thinking/SKILL.md)**: First-principles reasoning, Architecture Decision Records (ADRs), 5-Whys root cause analysis.
- **[systematic-debugging](skills/global/systematic-debugging/SKILL.md)**: Strict 4-phase diagnostic runbook ("No fixes without root cause investigation first").
- **[token-efficiency-concise](skills/global/token-efficiency-concise/SKILL.md)**: High-density token responses and direct concise communication.

### Automation, Cloud & DevOps
- **[free-stack-deploy](skills/global/free-stack-deploy/SKILL.md)**: Deploy full-stack apps to permanent zero-credit-card free hosting (Render / Cloudflare Workers / Neon).
- **[cicd-docker-devops](skills/global/cicd-docker-devops/SKILL.md)**: Multi-stage Dockerfiles, docker-compose, and GitHub Actions CI/CD pipelines.
- **[vps-management](skills/global/vps-management/SKILL.md)**: Linux VPS provisioning, SSH hardening, Nginx/Caddy reverse proxies, UFW, Let's Encrypt SSL.
- **[ntfy-push-notifications](skills/global/ntfy-push-notifications/SKILL.md)**: Mobile push notification integration with action buttons and deep links.

### Testing, Quality & Knowledge Management
- **[testing](skills/global/testing/SKILL.md)**: Multi-stack unit, integration, and E2E testing (Vitest, Jest, Supertest, Pytest, xUnit, Playwright).
- **[code-review](skills/global/code-review/SKILL.md)**: Diagnostic review runbooks covering correctness, security, performance, and architecture.
- **[obsidian-markdown](skills/global/obsidian-markdown/SKILL.md)**: Vault structure, 9-folder PARA taxonomy, YAML frontmatter, Dataview queries.
- **[obsidian-cli](skills/global/obsidian-cli/SKILL.md)**: Terminal automation scripts and URI handlers for Obsidian desktop.
- **[obsidian-bases](skills/global/obsidian-bases/SKILL.md)**: Schema standards for Obsidian `.base` files.
- **[daily-sprint-planner](skills/global/daily-sprint-planner/SKILL.md)**: Daily task execution, weekly sprint management, and automated rollover.
- **[defuddle](skills/global/defuddle/SKILL.md)**: Task refinement and eliminating ambiguity in project backlogs.
- **[json-canvas](skills/global/json-canvas/SKILL.md)**: Visual node maps and coordinate layout algorithms for Obsidian `.canvas`.
- **[project-docs](skills/global/project-docs/SKILL.md)**: Living technical docs, Mermaid architecture diagrams, and ADRs.
- **[skill-creator](skills/global/skill-creator/SKILL.md)**: Authoring and refining new `SKILL.md` packages.
- **[github-seo-geo](skills/global/github-seo-geo/SKILL.md)**: Repository search engine optimization and AI/LLM generative engine optimization.

---

## 6. Model Context Protocol (MCP) Catalog

The repository includes sanitized configuration files, setup guides, and boilerplate scaffolds:

| MCP Server | Config File | Setup Guide | Capabilities |
| :--- | :--- | :--- | :--- |
| **GitHub** | [mcp/configs/github.json](mcp/configs/github.json) | [mcp/guides/github-setup.md](mcp/guides/github-setup.md) | Repositories, PRs, issues, commits, branches |
| **Memory** | [mcp/configs/memory.json](mcp/configs/memory.json) | Built-in | Persistent knowledge graph entities & relations |
| **PostgreSQL** | [mcp/configs/postgres.json](mcp/configs/postgres.json) | [mcp/guides/postgres-setup.md](mcp/guides/postgres-setup.md) | Schema inspection, read-only SQL queries |
| **Puppeteer** | [mcp/configs/puppeteer.json](mcp/configs/puppeteer.json) | Built-in | Headless browser navigation, screenshots, scraping |
| **Resend** | [mcp/configs/resend.json](mcp/configs/resend.json) | [mcp/guides/resend-setup.md](mcp/guides/resend-setup.md) | Transactional emails, audience lists, templates |
| **Stripe** | [mcp/configs/stripe.json](mcp/configs/stripe.json) | Built-in | Payments, customers, invoices, subscriptions |
| **SQLite** | [mcp/configs/sqlite.json](mcp/configs/sqlite.json) | Built-in | Local embedded database queries & inspection |
| **Stitch (Remote)** | [mcp/configs/stitch.json](mcp/configs/stitch.json) | Built-in | Remote cloud MCP integration over SSE |

### Custom Server Development Scaffolds:
- **[Python FastMCP Scaffold](mcp/scaffolds/python-mcp-server/)**: Fast, lightweight server using `FastMCP`.
- **[TypeScript SDK Scaffold](mcp/scaffolds/typescript-mcp-server/)**: Strongly-typed server using `@modelcontextprotocol/sdk`.

---

## 7. How to Create New Skills & Plugins

### Creating a Skill:
1. Copy the template from `skills/templates/skill-template/` into `skills/global/<your-skill>/`.
2. Fill in the YAML frontmatter (`name`, `description`) in `SKILL.md`.
3. Add helper scripts in `scripts/` and detailed references in `references/`.
4. Run `./scripts/sync-to-global.ps1` to deploy globally.

### Creating a Plugin:
1. Copy `plugins/starter-plugin-template/` to `plugins/<your-plugin>/`.
2. Define metadata in `plugin.json`.
3. Add bundled skills to `skills/`, rules to `rules/`, lifecycle hooks to `hooks.json`, and MCP tools to `mcp_config.json`.

---

## 8. License

This repository is distributed under the [MIT License](LICENSE). All skills, configurations, and documentation may be freely used, modified, and integrated into internal or commercial AI agent setups.
