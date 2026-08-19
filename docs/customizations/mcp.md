# Model Context Protocol (MCP) in Antigravity

Model Context Protocol (MCP) connects the Antigravity agent to external tool providers, database connectors, and cloud APIs.

---

## 1. Transport Types

1. **Stdio Transport (Local Executables)**:
   Runs an executable process (`node`, `python`, binary) and communicates via `stdin`/`stdout`.
   ```json
   {
     "mcpServers": {
       "postgres": {
         "command": "npx",
         "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://user:pass@localhost:5432/db"]
       }
     }
   }
   ```

2. **SSE Transport (Remote HTTP)**:
   Connects over Server-Sent Events to a remote MCP endpoint.
   ```json
   {
     "mcpServers": {
       "remote-ai": {
         "serverUrl": "https://mcp.internal.enterprise/sse"
       }
     }
   }
   ```

---

## 2. Scoping & Lazy Loading

- Global MCP configs reside in `~/.gemini/config/mcp_config.json`.
- Workspace MCP configs reside in `<repo-root>/.agents/mcp_config.json`.
- Tools exposed by MCP servers are discovered during session startup and injected into the agent's available tool catalog.
