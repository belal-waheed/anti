# Rules Architecture in Antigravity

Rules enforce constraints, code styles, stack conventions, and domain boundaries.

---

## 1. Rule Types & Discovery

Antigravity automatically discovers rules by walking up from the current active file / directory up to the workspace root:

1. **Global Rules (`~/.gemini/config/GEMINI.md` / system rules)**:
   Applies across all projects and sessions on the host machine.
2. **Project Rules (`<repo-root>/GEMINI.md` or `<repo-root>/AGENTS.md`)**:
   Applies to the entire repository and all child directories.
3. **Directory-Scoped Rules (`<subfolder>/GEMINI.md` or `.agents/rules/*.md`)**:
   Applies specifically when editing or creating files within that directory tree.

---

## 2. Deduplication & Scoping

- Rules are resolved to their canonical filesystem paths.
- Even if a rule file matches multiple discovery queries, it is injected at most once per conversation turn.
- Rules do not require YAML frontmatter and are active for their directory hierarchy.
