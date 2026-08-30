---
name: obsidian-bases
description: Standards and schema definitions for Obsidian `.base` files (Obsidian Bases core plugin). Use when creating or managing database definition files, tabular views, and property queries in Obsidian.
---

# Obsidian Bases Integration

Runbook for constructing and maintaining `.base` database definition files inside Obsidian vaults.

## 1. Schema Structure & Property Types

A `.base` file defines structured tabular and board views over frontmatter properties of markdown notes:

```yaml
filters:
  and:
    - file.folder == "05-projects"
    - file.tags contains "#active"
views:
  - type: table
    name: "Active Projects"
    columns:
      - property: file.name
        label: "Project"
      - property: status
        label: "Status"
      - property: priority
        label: "Priority"
      - property: due_date
        label: "Due Date"
```

---

## 2. Supported Property Types

- `text`: Single-line string identifiers.
- `number`: Numerical data (e.g. estimate hours, budget).
- `date`: `YYYY-MM-DD` ISO date formats.
- `multiselect`: Array of strings for tags and categories.
- `checkbox`: Boolean `true`/`false`.

---

## 3. Verification & Testing

Validate `.base` file format and frontmatter schema:
1. **YAML Parsing Test:**
   ```bash
   pwsh -NoProfile -Command "Get-Content 'D:/dev/obsidian/hola\projects.base' | ConvertFrom-Yaml"
   ```
2. **Folder Path Verification:** Ensure the target folder specified in `file.folder` exists in the vault.
3. **Property Consistency Check:** Verify referenced frontmatter properties match the note schemas in that directory.

---

## 4. Common Pitfalls & Negative Constraints

- **Never use arbitrary property names:** Align property keys with existing vault frontmatter standards (`status`, `tags`, `priority`).
- **Never hardcode absolute system paths in base filters:** Use relative vault paths (`05-projects`, `03-inbox`).
- **Avoid unbound queries:** Always bind queries to a specific folder or tag filter to prevent vault-wide performance slowdowns.

