# Google Antigravity (AGY) Architecture & Ecosystem Overview

Google Antigravity is an AI-first development platform and autonomous pair programming runtime. It unifies high-speed autocomplete, inline targeted refactoring, collaborative sidebar planning, multi-agent orchestration, and an open customization system.

---

## 1. System Topology

```text
+-----------------------------------------------------------------------------------+
|                                 USER SURFACES                                     |
|  +--------------------+  +---------------------+  +----------------------------+  |
|  | Antigravity CLI    |  | Antigravity IDE     |  | Antigravity 2.0 Desktop    |  |
|  | (`agy` TUI/REPL)   |  | (VS Code Modality)  |  | (Electron Desktop App)     |  |
|  +---------+----------+  +----------+----------+  +-------------+--------------+  |
|            |                        |                           |                 |
|  +---------+------------------------+---------------------------+--------------+  |
|  |                      Antigravity Python SDK (`google-antigravity`)          |  |
|  +----------------------------------+------------------------------------------+  |
+-------------------------------------|---------------------------------------------+
                                      | IPC / Language Server Protocol
+-------------------------------------v---------------------------------------------+
|                            AGENT CORE RUNTIME                                     |
|  +-----------------------------------------------------------------------------+  |
|  | Reasoning & Planning Loop (Gemini Pro / Flash Models)                       |  |
|  | - Progressive Disclosure Context Manager                                    |  |
|  | - Reactive Wakeup & Messaging Event Bus                                      |  |
|  | - Subagent Spawner & Task Supervisor                                        |  |
|  +-----------------------------------------------------------------------------+  |
|                                     |                                             |
|  +----------------------------------v------------------------------------------+  |
|  | CUSTOMIZATION ENGINE (Discovery & Precedence)                               |  |
|  | 1. Workspace Project: `.agents/` (walk-up from CWD to repo root)            |  |
|  | 2. Declared Workspace Configs: `skills.json`, `plugins.json`                |  |
|  | 3. Global Discovery: `~/.gemini/config/` (skills, plugins, sidecars)        |  |
|  | 4. Built-in Core Skills: bundled agent skills                               |  |
|  | 5. Global Declared Configs: explicitly mapped system JSONs                   |  |
|  +-----------------------------------------------------------------------------+  |
|                                     |                                             |
|  +----------------------------------v------------------------------------------+  |
|  | TOOL EXECUTION & SANDBOX ENGINE                                             |  |
|  | - Native Tools: `run_command`, `write_to_file`, `view_file`, `replace_file`  |  |
|  | - Search Tools: `grep_search`, `find_by_name`, `search_web`, `read_url`     |  |
|  | - Lifecycle Hooks: `hooks.json` (PreToolUse, PostToolUse, PreInvocation...) |  |
|  | - MCP Clients: Model Context Protocol (Stdio & SSE external tool servers)   |  |
|  +-----------------------------------------------------------------------------+  |
+-----------------------------------------------------------------------------------+
```

---

## 2. Core Tenets

1. **Progressive Disclosure**:
   Instead of polluting the model's context window with thousands of lines of documentation or inactive tools, Antigravity uses metadata-first indexing. Only names and trigger descriptions are loaded initially. Full runbooks (`SKILL.md`), reference manuals (`references/`), or tool schemas are ingested strictly on-demand.

2. **Deduplication & Hierarchical Inheritance**:
   Configurations and rules cascade cleanly from global system settings (`~/.gemini/config/`) down to repository-level and directory-level files (`.agents/`, `GEMINI.md`). Rules are deduplicated by resolved canonical file paths to guarantee zero redundant prompt injection.

3. **Reactive Wakeup (Zero Polling Overhead)**:
   Background tasks, timers, subagents, and daemons push events directly into the agent's reactive message queue. The agent sleeps when waiting on async tasks and resumes automatically upon event arrival.

4. **Security & Sandboxing**:
   Granular tool execution policies (`always-proceed`, `request-review`, `strict`, `proceed-in-sandbox`), permission allowlists/denylists, and lifecycle interception hooks ensure secure terminal and filesystem access.
