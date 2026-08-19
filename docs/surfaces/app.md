# Antigravity 2.0 Desktop Application

Antigravity 2.0 is an Electron-based desktop application providing an autonomous mission control center for agent operations.

---

## 1. Interface Anatomy

```text
+-----------------------------------------------------------------------------------+
|  SIDEBAR        |  CHAT CANVAS                  |  AUXILIARY PANE                 |
|  - Conversations|  - Message Stream             |  - Subagents Monitor            |
|  - Projects Hub |  - Thinking / Reasoning Dels  |  - Background Tasks & Daemons   |
|  - Schedulers   |  - Visual Artifacts Renderer  |  - Interactive Terminals        |
|  - Customization|  - Slash Commands Menu        |  - Files Changed Diff Viewer    |
|  - Settings     |  - Mention Menu (@files, @mcp)|  - Live Browser Preview         |
+-----------------------------------------------------------------------------------+
```

---

## 2. Security, Sandboxing & Permissions

Antigravity 2.0 enforces strict security policies configured in settings:

- **Tool Execution Policy**:
  - `always-proceed`: Executes trusted safe commands automatically.
  - `request-review`: Prompts user before executing modifying commands or scripts.
  - `strict`: Prompts on every tool invocation.
  - `proceed-in-sandbox`: Runs terminal commands inside an isolated Docker/WSL container.
- **Filesystem Access Scope**: Restricts read/write operations outside the active workspace.
- **Network Access Policy**: Restricts outbound HTTP requests to an allowlist of domains.
