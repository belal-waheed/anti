# AGENTS.md — Autonomous Agent Operating Manual

> **FOR AI CODING AGENTS (Antigravity, Cursor, Windsurf, Claude Code, Roo Code, Aider, Copilot):**
> This file is your operational instruction set when executing tasks within or with the help of this repository.

---

## 1. Core Operating Principles

1. **Stack Awareness**:
   Detect the active codebase stack first. Apply strict layered clean architecture (Router -> Service -> Repository). Never mix presentation and persistence concerns.
2. **Progressive Disclosure**:
   Do not attempt to read every skill at once. Match the user's prompt to the relevant skill directory in `skills/global/`, read only that skill's `SKILL.md`, and only load files in `references/` if edge cases arise.
3. **Mandatory Testing**:
   Every new service, endpoint, hook, or refactor must have corresponding unit tests following the AAA (Arrange, Act, Assert) pattern.
4. **Shell Safety**:
   When running PowerShell commands, **ALWAYS** include `-NoProfile` (e.g. `pwsh -NoProfile -Command "..."`).
5. **Zero Credentials in Code**:
   Never write secrets, API keys, or raw connection strings to disk. Always reference environment variables.

---

## 2. Decision Tree & Skill Index

When the user asks for:
- **FastAPI / Python backends** -> Ingest [skills/global/python-clean-architecture/SKILL.md](skills/global/python-clean-architecture/SKILL.md)
- **Node.js / Express / TypeScript** -> Ingest [skills/global/node-express-mongo/SKILL.md](skills/global/node-express-mongo/SKILL.md)
- **C# / ASP.NET Core** -> Ingest [skills/global/aspnet-mvc-ef/SKILL.md](skills/global/aspnet-mvc-ef/SKILL.md)
- **AutoHotkey v2 scripting** -> Ingest [skills/global/autohotkey-v2/SKILL.md](skills/global/autohotkey-v2/SKILL.md)
- **PowerShell automation** -> Ingest [skills/global/powershell-automation/SKILL.md](skills/global/powershell-automation/SKILL.md)
- **React 19 / Next.js App Router** -> Ingest [skills/global/react-patterns/SKILL.md](skills/global/react-patterns/SKILL.md) & [skills/global/react-frontend/SKILL.md](skills/global/react-frontend/SKILL.md)
- **Tailwind CSS v4 styling** -> Ingest [skills/global/tailwind-v4/SKILL.md](skills/global/tailwind-v4/SKILL.md)
- **UI/UX Design / CSS Craftsmanship** -> Ingest [skills/global/ui-ux-design/SKILL.md](skills/global/ui-ux-design/SKILL.md)
- **Complex debugging / Bug investigation** -> Ingest [skills/global/systematic-debugging/SKILL.md](skills/global/systematic-debugging/SKILL.md)
- **Free cloud hosting deployment** -> Ingest [skills/global/free-stack-deploy/SKILL.md](skills/global/free-stack-deploy/SKILL.md)
- **RAG / AI Agent design** -> Ingest [skills/global/rag-ai-systems/SKILL.md](skills/global/rag-ai-systems/SKILL.md)
- **Obsidian / Markdown workflows** -> Ingest [skills/global/obsidian-markdown/SKILL.md](skills/global/obsidian-markdown/SKILL.md)
- **Testing & Test suites** -> Ingest [skills/global/testing/SKILL.md](skills/global/testing/SKILL.md)
- **Antigravity Customization engine** -> Ingest [skills/builtin/agy-customizations/SKILL.md](skills/builtin/agy-customizations/SKILL.md)

---

## 3. Post-Work Checklist

Before finishing any task:
1. Verify unit tests build and pass cleanly.
2. Confirm no leftover scratch files or temporary credentials exist.
3. Recommend clear Conventional Commit boundaries.
