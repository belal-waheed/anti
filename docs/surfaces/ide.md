# Antigravity IDE Reference

The Antigravity IDE (available as a standalone AI-first editor and VS Code extension) integrates real-time agent pair programming into the editing canvas.

---

## 1. AI Modalities

### A. Passive: Antigravity Tab (Autocomplete & Supercomplete)
- **Next-Intent Prediction**: Analyzes active code, open editor tabs, diagnostic errors, and clipboard context to predict keystrokes.
- **Tab to Jump**: Predicts your next edit point across files and jumps there on `<Tab>`.
- **Tab to Import**: Automatically resolves and appends missing module imports when referencing new libraries.
- **Supercomplete**: Multi-line, cross-function diffs rendered in floating code previews.

### B. Instructive: Inline Command (`Cmd+I` / `Ctrl+I`)
- **Scoped In-Place Editing**: Highlight code and invoke `Ctrl+I` to refactor, explain, or generate unit tests without losing context.
- **Net-New Generation**: Trigger at an empty line to generate boilerplate or component implementations from natural language.

### C. Collaborative: Sidebar Chat & Agent Mode
- **Pair Programming Agent**: Multi-step autonomous agent with tool execution (`run_command`, `write_to_file`, `replace_file_content`, `grep_search`).
- **Planning Mode**: Structured plan generation (`implementation_plan.md`) requiring explicit user review before non-trivial file modifications.
- **Visual Diff Overlays**: Inline red/green git-style diffs rendered directly inside the active editor tab.

---

## 2. Editor UI Features

- **Inline Code Lenses**: Interactive action buttons placed above classes and functions (`[Run Tests]`, `[Refactor]`, `[Explain]`).
- **Diagnostic Auto-Fix**: One-click agent repair triggers attached to linter warnings and compiler errors in the Problems pane.
- **Workspace Scoping**: Automatic discovery of `.agents/` rules, skills, and MCP configurations.
