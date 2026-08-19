# Skills Architecture & Authoring Standards

Skills are progressive-disclosure runbooks that teach the agent specific, repeatable workflows, procedures, and domain knowledge.

---

## 1. Skill Structure

```text
skills/<skill-name>/
├── SKILL.md          # Required: Manifest & core instructions
├── scripts/          # Optional: Executable helper scripts
├── references/       # Optional: Heavy reference documentation
├── examples/         # Optional: Sample code and configs
└── resources/        # Optional: Assets, schemas, templates
```

---

## 2. Frontmatter Contract (`SKILL.md`)

Every `SKILL.md` must start with YAML frontmatter:

```markdown
---
name: my-specialized-skill
description: >-
  Concise explanation of what the skill does and exact triggers for when the agent should activate it.
  Written in third person.
---
```

---

## 3. Progressive Disclosure Design Pattern

- **Top-Level `SKILL.md`**: Keep concise (under 100-200 lines). Provide direct checklists, command recipes, and decision trees.
- **Deep Reference Docs**: Place large API manuals or specifications inside `references/`. Link to them using relative markdown links (e.g. `[Deep Dive](./references/guide.md)`). The agent will only read the reference file when strictly necessary.
- **Executable Scripts**: Wrap complex shell or python scripts in `scripts/` rather than inlining massive code blocks in chat.
