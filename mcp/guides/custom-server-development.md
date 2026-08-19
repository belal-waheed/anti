# Custom MCP Server Development Guide

You can build custom MCP servers using Python or TypeScript to expose private APIs or custom internal tool suites to Antigravity.

---

## Architecture
MCP communicates via JSON-RPC 2.0 over standard I/O (stdin/stdout) or Server-Sent Events (SSE).

### Exposing Tools
A tool requires:
1. `name`: Unique identifier.
2. `description`: Clear LLM-facing instructions of what the tool accomplishes.
3. `inputSchema`: JSON Schema specifying required and optional arguments.
