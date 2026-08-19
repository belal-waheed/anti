# PostgreSQL MCP Server Setup Guide

Connects Antigravity to local or remote PostgreSQL databases to inspect schemas, analyze query plans, and execute parameterized queries.

---

## 1. Configuration
Add to `~/.gemini/config/mcp_config.json`:
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://postgres:password@localhost:5432/mydb"
      ]
    }
  }
}
```

## 2. Tool Capabilities
- Read schema information (tables, indexes, constraints).
- Execute read-only diagnostic SQL queries.
