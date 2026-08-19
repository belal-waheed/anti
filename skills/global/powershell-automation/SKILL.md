---
name: powershell-automation
description: Conventions and production standards for PowerShell 7+ (pwsh) and Windows PowerShell 5.1 automation. Covers WinRT toast notifications with interactive action buttons, Windows Task Scheduler, background daemon management, safe UTF-8 encoding, and REST APIs.
---

# PowerShell Automation & Windows Scripting

## When to use this skill
Trigger whenever writing, debugging, or refactoring PowerShell (`.ps1`) scripts, Windows background daemons, scheduled tasks, native Windows Toast notifications, or cross-platform PowerShell automation.

---

## 1. Execution Directives & Shell Rules

- **Always use `-NoProfile`**: When invoking PowerShell from terminals, agents, or automated tasks, always pass `-NoProfile` to prevent loading user profiles:
  ```powershell
  pwsh -NoProfile -Command "..."
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "script.ps1"
  ```
- **Error Handling**: Use `$ErrorActionPreference = "Stop"` or `-ErrorAction Stop` for critical operations, wrapped in `try { ... } catch { ... }`.
- **UTF-8 Encoding Safety**: Windows PowerShell often defaults to ANSI/Windows-1252. Always enforce UTF-8 for file I/O and REST requests:
  ```powershell
  # File Write with UTF8
  Set-Content -Path $filePath -Value $content -Encoding UTF8
  
  # REST API payload with explicit UTF-8 bytes
  $utf8Bytes = [System.Text.Encoding]::UTF8.GetBytes($payloadString)
  Invoke-RestMethod -Uri $url -Method Post -Body $utf8Bytes -ContentType "text/plain; charset=utf-8"
  ```

---

## 2. Native Windows WinRT Toast Notifications

To display rich, interactive notifications in Windows 10/11:

```powershell
function Show-WindowsToast {
    param (
        [string]$Title,
        [string]$Message,
        [string]$ClickUrl = "obsidian://open?vault=hola&file=inbox/Today"
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    # Prevent encoding mojibake by escaping XML and substituting entities for symbols
    $XmlMessage = [System.Security.SecurityElement]::Escape($Message) -replace '•', '&#x2022;' -replace 'â€¢', '&#x2022;'
    $XmlTitle   = [System.Security.SecurityElement]::Escape($Title)

    $template = @"
<toast activationType="protocol" launch="$ClickUrl">
    <visual>
        <binding template="ToastGeneric">
            <text>$XmlTitle</text>
            <text>$XmlMessage</text>
        </binding>
    </visual>
    <actions>
        <action content="Open Today" arguments="$ClickUrl" activationType="protocol"/>
        <action content="Dashboard" arguments="obsidian://open?vault=hola&amp;file=Dashboard" activationType="protocol"/>
    </actions>
</toast>
"@

    try {
        $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $xml.LoadXml($template)
        $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Obsidian Vault").Show($toast)
    } catch {
        # Fallback quiet
    }
}
```

---

## 3. Windows Task Scheduler Automation

Registering background recurring or daily scheduled tasks:

```powershell
# Create action running pwsh without window or profile
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$ScriptPath`" -Mode today"

# Create daily or interval triggers
$Trigger = New-ScheduledTaskTrigger -Daily -At "09:00AM"

# Settings: run independently without timeout
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -TaskName "Vault-Daily-Notification" -Action $Action -Trigger $Trigger -Settings $Settings -Description "Daily Vault Task Sync" -Force
```

---

## 4. Common Pitfalls to Avoid

- **Never hardcode absolute paths**: Derive paths relative to `$PSScriptRoot` or `$MyInvocation.MyCommand.Definition`.
- **Never insert raw multibyte characters directly into XML strings**: Always use XML entities like `&#x2022;` (bullet) and `&#xA;` (newline) to prevent `â€¢` mojibake.
- **Do not leak console windows**: Use `-WindowStyle Hidden` when invoking background scripts from AutoHotkey or Task Scheduler.
