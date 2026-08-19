# Resend MCP Server Setup Guide

Enables transactional email delivery, audience management, template generation, and email verification.

---

## 1. Configuration
```json
{
  "mcpServers": {
    "resend": {
      "command": "npx",
      "args": ["-y", "resend-mcp"],
      "env": {
        "RESEND_API_KEY": "re_your_api_key_here"
      }
    }
  }
}
```
