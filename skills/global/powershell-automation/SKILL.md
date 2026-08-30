---
name: powershell-automation
description: Conventions and production standards for PowerShell 7+ (pwsh) and Windows PowerShell 5.1 automation. Covers WinRT toast notifications with interactive action buttons, Windows Task Scheduler, background daemon management, safe UTF-8 encoding, and REST APIs. Use when creating PowerShell scripts or Windows automations.
---

# PowerShell Automation & Windows Scripting

Runbook for PowerShell 7+ and Windows PowerShell 5.1 automation, scheduled tasks, and WinRT toast integration.

## 1. Execution Directives & Shell Standards

- **Always use `-NoProfile`**:
  ```powershell
  pwsh -NoProfile -Command "..."
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "script.ps1"
  ```
- **Strict Error Handling**: Use `$ErrorActionPreference = "Stop"` wrapped in `try { ... } catch { ... }`.
- **UTF-8 Encoding Safety**: Enforce UTF-8 for file I/O and REST requests:
  ```powershell
  Set-Content -Path $filePath -Value $content -Encoding utf8
  $utf8Bytes = [System.Text.Encoding]::UTF8.GetBytes($payload)
  Invoke-RestMethod -Uri $url -Method Post -Body $utf8Bytes -ContentType "text/plain; charset=utf-8"
  ```

---

## 2. WinRT Toast Notification Pattern

```powershell
function Show-WindowsToast {
    param (
        [string]$Title,
        [string]$Message,
        [string]$ClickUrl = "obsidian://open?vault=hola&file=inbox/Today"
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $XmlMessage = [System.Security.SecurityElement]::Escape($Message) -replace '•', '&#x2022;'
    $XmlTitle   = [System.Security.SecurityElement]::Escape($Title)

    $template = @"
<toast activationType="protocol" launch="$ClickUrl">
    <visual>
        <binding template="ToastGeneric">
            <text>$XmlTitle</text>
            <text>$XmlMessage</text>
        </binding>
    </visual>
</toast>
"@
    try {
        $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $xml.LoadXml($template)
        $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Antigravity").Show($toast)
    } catch {}
}
```

---

## 3. Verification & Testing

Validate script execution and error traps:
1. **Syntax Check:**
   ```bash
   pwsh -NoProfile -Command "Get-Command -Syntax -Name '.\script.ps1'"
   ```
2. **Execution Test:**
   ```bash
   pwsh -NoProfile -Command "& '.\script.ps1' -DryRun"
   ```
3. **Exit Code Assertion:** Verify `$LASTEXITCODE` or `$?` equals true after execution.

---

## 4. Common Pitfalls & Negative Constraints

- **Never hardcode absolute user paths:** Use `$PSScriptRoot` or `$HOME`.
- **Never insert raw unescaped characters into XML:** Use XML entities to prevent `â€¢` mojibake.
- **Never use unbounded `-Wait` on GUI binaries:** Enforce bounded timeouts `$p.WaitForExit(10000)` with kill fallbacks.
