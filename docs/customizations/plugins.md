# Plugins Architecture & Bundling

Plugins package related skills, rules, lifecycle hooks, and Model Context Protocol (MCP) server configurations into a single distributable bundle.

---

## 1. Plugin Structure

```text
plugins/<plugin-name>/
├── plugin.json       # Required: Manifest file
├── mcp_config.json   # Optional: MCP servers bundled with plugin
├── hooks.json        # Optional: Lifecycle hooks bundled with plugin
├── rules/            # Optional: Rules active when plugin is enabled
│   └── *.md
└── skills/           # Optional: Skills exposed by the plugin
    └── <skill-name>/
        └── SKILL.md
```

---

## 2. Plugin Manifest (`plugin.json`)

```json
{
  "name": "enterprise-backend-kit",
  "version": "1.0.0",
  "description": "Enterprise microservice rules, skills, and database tools.",
  "author": { "name": "Architecture Team" },
  "license": "Apache-2.0"
}
```

---

## 3. Enabling / Disabling Plugins

Plugins are enabled by default once placed in a discovered directory (`~/.gemini/config/plugins/` or `.agents/plugins/`).
You can override plugin states in `config.json`:

```json
{
  "plugins": {
    "enterprise-backend-kit": { "enabled": false }
  }
}
```
