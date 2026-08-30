---
name: skill-linter
description: Audits, validates, and refactors Antigravity skills against anti-slop standards, progressive disclosure rules, verification completeness, and token efficiency. Use when creating, reviewing, or optimizing skills in ~/.gemini/config/skills/ or workspace .agents/skills/.
---

# Skill Linter & Quality Auditor

Evaluates and refactors skills against 5 strict anti-slop quality criteria.

## Quality Criteria & Rubric (Target: 10/10)

1. **Frontmatter Rigor (3.0 pts):**
   - `name`: Kebab-case, lowercase, strictly matches folder name.
   - `description`: Starts with clear trigger conditions ("Use this skill when...", "Standards and runbooks for..."), concise (< 50 words), zero filler words.

2. **Token Economy & Anti-Slop (2.0 pts):**
   - Zero tutorial introductions (e.g. conversational explanations of basic concepts).
   - Imperative, operational instructions only.
   - Target line count: `< 150 lines` for `SKILL.md`. Split deep reference material into `references/<topic>.md`.

3. **Directory Structure & Progressive Disclosure (2.0 pts):**
   - Main `SKILL.md` serves as the router/runbook.
   - Standalone CLI utilities moved to `scripts/`.
   - Boilerplate files, configs, and schemas moved to `resources/` or `references/`.

4. **Verification & Testing Protocol (1.5 pts):**
   - Mandatory explicit validation command (e.g. `npm test`, `pytest`, `dotnet test`, `pwsh`, `curl`, dry-run check).
   - Expected outputs and assertions clearly stated.

5. **Negative Constraints & Anti-Patterns (1.5 pts):**
   - Explicit "Pitfalls / What NOT to do" section preventing common AI mistakes.

---

## Automated Audit Execution

To audit all skills across the system:
```bash
node C:\Users\bel\.gemini\config\scripts\audit-skills.mjs
```

---

## Verification & Testing

1. **Run Batch Scanner:** Execute `audit-skills.mjs` and verify output exit code is 0.
2. **Schema Test:** Ensure all YAML frontmatter blocks parse with valid `name` and `description` attributes.

---

## Common Pitfalls & Negative Constraints

- **Never place reference dumps in SKILL.md:** Large docs belong in `references/`.
- **Never omit test commands:** Every skill must tell the agent how to verify success.
