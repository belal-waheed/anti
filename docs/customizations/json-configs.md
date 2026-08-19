# JSON Declarative Configurations (`skills.json`, `plugins.json`)

JSON configuration files allow explicit registration and inheritance of skills and plugins outside default directories.

---

## 1. Schema & Inheritance

```json
{
  "inherits": [
    {
      "path": "/shared/team-agents/skills.json",
      "include_only": ["linter-.*", "deploy-.*"],
      "exclude": ["deprecated-.*"]
    }
  ],
  "entries": [
    {
      "path": "tools/local-skills"
    },
    {
      "path": "~/custom-skills"
    }
  ]
}
```

---

## 2. Path Resolution Rules

- `/path` -> Absolute filesystem path.
- `~/path` -> Home-directory relative path.
- `path/to/dir` -> Workspace repository root relative path.
