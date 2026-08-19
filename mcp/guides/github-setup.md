# GitHub MCP Server Setup Guide

The GitHub MCP server equips Antigravity with capabilities to query repositories, create branches, manage issues, open PRs, and inspect diffs.

---

## 1. Prerequisites
- A GitHub Personal Access Token (classic or fine-grained) with `repo` scopes.

## 2. Configuration
Add to `~/.gemini/config/mcp_config.json`:
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

## 3. Available Tools
- `search_repositories`
- `create_or_update_file`
- `create_pull_request`
- `list_issues` / `create_issue`
- `get_file_contents`
