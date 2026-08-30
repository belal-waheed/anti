# Antigravity Global Guardrails & System Rules

These rules apply universally across all workspaces, sessions, and executions.

---

## 1. Safety & Turbo Mode Guardrails
- **Destructive Commands Prohibited:** Never execute destructive file or directory deletions (`rm -rf /`, `rmdir /s /q`, `del /s /q` on root/system/parent dirs) or destructive Git commands (`git reset --hard`, `git push --force`, `git clean -fd`) without explicit user instruction.
- **Package Isolation:** Never install packages globally (`npm install -g`, `pip install --user` outside venv, `winget`, `choco`). Install dependencies only within local project scope (`npm install --save`, active virtual environments `venv`).
- **Secrets & System Integrity:** Never expose, hardcode, or overwrite `.env` files, API keys, or system directories (`C:\Windows`, `C:\Program Files`, registry).

---

## 2. Shell & Automation Standards
- **PowerShell Execution:** When invoking PowerShell commands via `pwsh` or `powershell`, ALWAYS use `-NoProfile` (e.g., `pwsh -NoProfile -Command "..."`).
- **Browser Automation:** All headless browser automation (Playwright/Puppeteer) MUST use Microsoft Edge (`C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe` or `channel: 'msedge'`). Never trigger ad-hoc Chromium downloads.

---

## 3. UI/UX Craftsmanship (Anti-AI Clichés)
- **Zero Emojis in Code & Chat:** Never use emojis in UI components, terminal output, or markdown reports unless explicitly requested. Use clean SVG vector icons (Lucide, Heroicons).
- **Design Integrity:** Reject generic dark-slate/neon-purple AI templates. Use WCAG AA contrast (4.5:1), 8px spatial grid, and CSS-first Tailwind v4 tokens.

---

## 4. Testing & Layered Clean Architecture
- **Layered Clean Architecture:** Router/Controller -> Service -> Repository. Services encapsulate business logic and return `Result<T, E>`. Edge validation via Zod or Pydantic.
- **Mandatory Verification:** Unit test business logic and API boundaries (AAA pattern) before declaring tasks complete. Never mock the system under test.

---

## 5. Living Documentation & Vault Synchronization (The Iron Law)
After completing any coding or technical task:
1. **Task Check-Off:** Locate and mark completed tasks (`- [x]`) in `inbox/Today.md` or active sprint note (`sprints/Week-YYYY-Wxx.md`).
2. **Project Hub Sync:** Update the relevant project folder note (`projects/<project>/_<project>.md`) with deliverables and status.
3. **Daily Scratchpad Capture:** Append concise bullet points under `## Daily Scratchpad & Notes` in `inbox/Today.md` documenting implementations and decisions.
4. **Git Approval:** Present Conventional Commit messages and file diffs in chat; await explicit user approval before executing git commits and pushes.

---

## 6. Execution Control & Planning Protocol
- **Interactive Mode (Default):** When the user requests a plan, outline, or investigation, draft the plan and STOP. Never auto-execute, modify files, or run modifying commands without explicit user confirmation.
- **Autonomous Mode (`/goal` Only):** Only when the user explicitly triggers `/goal` or requests unattended execution may the agent proceed through execution steps autonomously without intermediate confirmation.
