# Repository Rules: Antigravity Hub

These rules govern all agent operations inside this repository:

1. **PowerShell Commands**:
   Always execute terminal commands with `pwsh -NoProfile -Command "..."`.
2. **Progressive Disclosure**:
   Keep top-level files concise and link to `docs/`, `rules/`, `skills/`, or `mcp/` subdirectories.
3. **JSON Validity**:
   Ensure all `.json` configuration files parse cleanly and conform to schema.
4. **No Secrets**:
   Ensure all example MCP and environment templates use `<YOUR_TOKEN>` placeholders.
5. **Clean Architecture**:
   Follow strict modular separation across documentation, rules, skills, plugins, and MCP scaffolds.
