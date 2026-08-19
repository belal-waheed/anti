# Antigravity CLI (`agy`) Reference

The Antigravity Command Line Interface (`agy`) provides a fast, lightweight terminal REPL and autonomous execution environment.

---

## 1. Quickstart & Launch

- **Launch Interactive Session**:
  ```bash
  agy
  ```
- **Launch with Specific Workspace**:
  ```bash
  agy --workspace /path/to/project
  ```
- **Authentication**:
  On first launch, follow terminal OAuth prompts. Stored in `~/.gemini/antigravity-cli/auth.json`.
- **Exit**:
  Press `Ctrl+D` twice or type `/exit` / `/quit`.

---

## 2. Slash Commands in CLI

| Slash Command | Description |
| :--- | :--- |
| `/help` | List all available slash commands and keybindings. |
| `/clear` | Clear the current conversation history. |
| `/model <model-name>` | Switch active Gemini model (`gemini-pro`, `gemini-flash`). |
| `/workspace <path>` | Switch active workspace root. |
| `/mcp` | Inspect connected MCP servers and available tools. |
| `/skills` | List active, discovered, and installed skills. |
| `/plugins` | List enabled and available plugins. |
| `/permissions` | View and modify active tool execution permission grants. |

---

## 3. Configuration

CLI configuration is located at `~/.gemini/antigravity-cli/settings.json`.
Settings include:
- `defaultModel`: Default model string.
- `autoExecution`: Tool auto-run policy (`always-proceed`, `request-review`, `strict`).
- `theme`: Terminal syntax highlighting theme.
