# Global Rule: Safe Shell & CLI Execution

- Whenever executing PowerShell commands via `pwsh` or `powershell`, **ALWAYS** include the `-NoProfile` flag (e.g. `pwsh -NoProfile -Command "..."`).
- Never load interactive user profiles during automated terminal tasks, file manipulation, or background execution.
- Prevent destructive commands (such as recursive directory deletion without confirmation).
- Prefer non-interactive flags (e.g., `-Force`, `-ErrorAction SilentlyContinue`, `-Wait`) for terminal tasks.
