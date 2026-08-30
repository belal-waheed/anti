---
name: pwsh-commands
description: Comprehensive conventions and patterns for executing PowerShell 7+ (pwsh) command-line operations, one-liners, object pipeline processing, filesystem management, text parsing, and robust error handling. Use when crafting pwsh CLI one-liners, diagnosing shell command syntax errors, executing administrative filesystem tasks, or automating terminal workflows.
---

# PowerShell 7+ (pwsh) Command Execution Guide

## When to use this skill

Trigger this skill whenever:
- Executing command-line operations or one-liners via `pwsh` or `powershell`.
- Debugging syntax, parser, or quoting errors when passing commands through automated runners or agents.
- Performing filesystem audits, disk analysis, directory reorganization, or batch file processing.
- Transforming, filtering, and projecting structured object streams using PowerShell pipelines.
- Converting command output into clean JSON or formatted tables.

---

## 1. Shell Invocation & Quoting Rules

### A. Always Include `-NoProfile`
Automated tool calls, background tasks, and scripts must never load interactive user profiles:
```powershell
pwsh -NoProfile -Command "Get-Process | Select-Object -First 5"
```

### B. The Runner Interpolation Trap (Preventing `$_` and `$()` Expansion)
When invoking `pwsh -NoProfile -Command "..."` from within another shell or programmatic tool, double quotes (`"..."`) cause the outer execution context to eagerly expand variables like `$_`, `$var`, or `$(...)` before PowerShell even receives the string.

**Rules for Safe One-Liners**:
1. **Use Single Quotes for the Outer Command** when the command does not require outer variable substitution:
   ```powershell
   pwsh -NoProfile -Command 'Get-ChildItem -Path B:\ -Directory | ForEach-Object { [PSCustomObject]@{ Name=$_.Name; Path=$_.FullName } }'
   ```
2. **Backtick-Escape PowerShell Variables** when outer double quotes are mandatory:
   ```powershell
   pwsh -NoProfile -Command "Get-ChildItem | ForEach-Object { Write-Output `$_.Name }"
   ```
3. **Use `-EncodedCommand` for Complex Multi-Line Logic**:
   For complex scripts containing quotes, brackets, and pipelines, pass base64-encoded UTF-16LE:
   ```powershell
   $script = @'
   Get-ChildItem -Path 'B:\' -Directory | ForEach-Object {
       [PSCustomObject]@{
           Directory = $_.Name
           FileCount = (Get-ChildItem -LiteralPath $_.FullName -File -Recurse | Measure-Object).Count
       }
   }
   '@
   $bytes = [System.Text.Encoding]::Unicode.GetBytes($script)
   $encoded = [Convert]::ToBase64String($bytes)
   pwsh -NoProfile -EncodedCommand $encoded
   ```

---

## 2. Pipeline Idioms & Object Manipulation

PowerShell operates on .NET objects, not plain text streams.

### A. Filtering & Selecting
```powershell
# Filter objects with Where-Object (?)
Get-Service | Where-Object { $_.Status -eq 'Running' }

# Select specific properties
Get-Process | Select-Object -Property Id, ProcessName, WorkingSet64 -First 10

# Unpack single property values directly
(Get-Item -LiteralPath "B:\dev-vault").FullName
# OR via Select-Object
Get-Service | Select-Object -ExpandProperty Name
```

### B. Calculated Properties
Use hashtables `@{ Name = '...'; Expression = { ... } }` (or shorthand `@{ n='...'; e={...} }`) to compute dynamic columns:
```powershell
Get-ChildItem -File | Select-Object Name,
    @{ Name = 'SizeMB'; Expression = { [math]::Round($_.Length / 1MB, 2) } },
    @{ Name = 'Modified'; Expression = { $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm") } }
```

### C. Grouping, Sorting & Measuring
```powershell
# Group files by extension with count and total size
Get-ChildItem -File -Recurse | Group-Object Extension | Select-Object Name, Count,
    @{ Name = 'TotalMB'; Expression = { [math]::Round(($_.Group | Measure-Object Length -Sum).Sum / 1MB, 2) } } |
    Sort-Object TotalMB -Descending

# Measure aggregate statistics
Get-ChildItem -File | Measure-Object -Property Length -Sum -Average -Maximum
```

### D. Parallel Pipeline Execution (PowerShell 7+)
```powershell
# Process items in parallel using -Parallel
1..10 | ForEach-Object -Parallel {
    Write-Output "Processing item $_ on thread $([System.Threading.Thread]::CurrentThread.ManagedThreadId)"
} -ThrottleLimit 4
```

---

## 3. Filesystem Inspection & Organization

### A. Safe Paths with `-LiteralPath`
Always prefer `-LiteralPath` over `-Path` when handling filenames that may contain wildcards or square brackets (e.g. `[2026] Note.md`):
```powershell
# Safe lookup ignoring bracket globbing
Get-ChildItem -LiteralPath "B:\[Archive] 2026"
```

### B. Directory Size & Folder Audits
```powershell
# Calculate recursive folder sizes under a root path
Get-ChildItem -LiteralPath 'B:\' -Directory | ForEach-Object {
    $folder = $_
    $files = Get-ChildItem -LiteralPath $folder.FullName -File -Recurse -Force -ErrorAction SilentlyContinue
    $measure = $files | Measure-Object -Property Length -Sum

    [PSCustomObject]@{
        Folder    = $folder.Name
        FileCount = $measure.Count
        SizeMB    = [math]::Round(($measure.Sum / 1MB), 2)
        SizeGB    = [math]::Round(($measure.Sum / 1GB), 3)
    }
} | Sort-Object SizeMB -Descending | Format-Table -AutoSize
```

### C. Safe Moving, Renaming, and Organizing
Always verify with `-WhatIf` before performing destructive or moving operations:
```powershell
# Dry run with -WhatIf
Get-ChildItem -LiteralPath "B:\src" -Filter "*.log" | Move-Item -Destination "B:\logs" -WhatIf

# Actual move with creation check
$targetDir = "B:\organized\media"
if (-not (Test-Path -LiteralPath $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}
Get-ChildItem -Path "B:\*.mp3", "B:\*.png" -File | Move-Item -Destination $targetDir
```

---

## 4. Modern PowerShell 7+ Language Features

| Feature | Syntax | Example |
| :--- | :--- | :--- |
| **Ternary Operator** | `condition ? true_val : false_val` | `$status = $res.Ok ? "Passed" : "Failed"` |
| **Null-Coalescing** | `expr1 ?? expr2` | `$name = $customName ?? "Default"` |
| **Null-Assign** | `target ??= expr` | `$config.Timeout ??= 30` |
| **Null-Conditional** | `${obj}?.Prop` or `${arr}?[0]` | `$length = $response?.Data?.Count` |
| **Pipeline Chain AND** | `cmd1 && cmd2` | `dotnet build && dotnet test` |
| **Pipeline Chain OR** | `cmd1 \|\| cmd2` | `Test-Path $file \|\| New-Item $file` |

---

## 5. Output Formatting & Structured Serialization

### A. Clean JSON Output
For piping structured data to other tools or agents:
```powershell
Get-Process | Select-Object -First 3 -Property Id, ProcessName | ConvertTo-Json -Depth 3 -Compress
```

### B. Formatting Tables for Human Inspection
`Format-Table` and `Format-List` should **only** be used at the very end of a pipeline for terminal display. Never pipe `Format-Table` into downstream cmdlets:
```powershell
# Correct: Format-Table as final terminal step
Get-ChildItem -Path "B:\" | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize

# Bad: Piping Format-Table to another cmdlet (destroys the underlying object structure)
Get-ChildItem | Format-Table | Where-Object { $_.Length -gt 100 } # WRONG!
```

---

## 6. Error Handling & Exit Codes

### A. Deterministic Failure Trapping
```powershell
$ErrorActionPreference = 'Stop'

try {
    Get-Item -LiteralPath "B:\non-existent-folder"
} catch {
    Write-Error "Failed to access directory: $($_.Exception.Message)"
}
```

### B. Native Executable Exit Codes
When calling external native executables (`git`, `node`, `docker`, `npm`), inspect `$LASTEXITCODE` rather than relying on PowerShell exceptions:
```powershell
git status
if ($LASTEXITCODE -ne 0) {
    Write-Error "Git command failed with exit code $LASTEXITCODE"
}
```

---

## 7. Common Pitfalls & Antipatterns

- **Never use aliases in automation**: Use full cmdlet names (`Get-ChildItem`, `Remove-Item`, `Set-Content`) rather than aliases (`ls`, `dir`, `rm`, `cat`, `echo`, `gc`).
- **Never omit `-LiteralPath` when dealing with arbitrary user filenames**: Brackets like `[v1]` cause `-Path` to treat names as regex/glob filters.
- **Never pipe formatting cmdlets into processing cmdlets**: `Format-*` transforms rich objects into formatting metadata stream objects.
- **Never hardcode Windows path separators**: Use `Join-Path` or forward slashes `/`, which PowerShell 7+ natively resolves across platforms.