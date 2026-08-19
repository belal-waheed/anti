---
name: ntfy-push-notifications
description: Conventions and patterns for ntfy.sh and self-hosted ntfy push notification integration across Node.js, PowerShell, cURL, and GitHub Actions. Covers interactive action buttons, deep links, priority levels, markdown formatting, and mobile push automation.
---

# ntfy Push Notifications Guide

## When to use this skill
Trigger whenever building, debugging, or configuring push notifications to mobile devices (iOS / Android) or desktops using ntfy.sh or self-hosted ntfy instances.

---

## 1. Core Architecture & HTTP Request Standards

ntfy notifications can be published using simple HTTP POST or PUT requests. All metadata is controlled via HTTP headers or JSON payload bodies.

### Primary Headers Matrix

| Header | Example Value | Description |
| :--- | :--- | :--- |
| `Title` | `Today Tasks` | Sets the notification title (use clean ASCII to prevent emoji clutter) |
| `Priority` | `high` | `min`, `low`, `default`, `high`, `urgent` (`high`/`urgent` produce sound and vibration) |
| `Markdown` / `X-Markdown` | `yes` | Enables full Markdown parsing in the notification body |
| `Click` | `obsidian://open?vault=hola&file=inbox/Today` | URL or app URI to open when the notification body is tapped |
| `Actions` | `view, Open Today, obsidian://open?...; view, Dashboard, ...` | Interactive buttons placed directly on the notification card |

---

## 2. Interactive Action Buttons (`Actions` Header)

Action buttons allow users to take immediate action directly from the notification shade or lock screen.

### Action Types:
- **`view`**: Opens an HTTP URL or local app URI scheme (e.g. `obsidian://`, `notion://`).
- **`http`**: Sends an HTTP request in the background without opening an app.
- **`broadcast`**: Sends an Android broadcast intent.

### Syntax Example:
```text
Actions: view, Open Today, obsidian://open?vault=hola&file=inbox/Today; view, Dashboard, obsidian://open?vault=hola&file=Dashboard
```

---

## 3. Implementation Patterns

### Node.js (HTTPS)
```javascript
const https = require('https');

function sendNtfy(topic, title, body, clickUrl) {
    const payload = Buffer.from(body, 'utf8');
    const headers = {
        'Title': title,
        'Priority': 'high',
        'Markdown': 'yes',
        'Click': clickUrl,
        'Actions': 'view, Open Today, obsidian://open?vault=hola&file=inbox/Today; view, Dashboard, obsidian://open?vault=hola&file=Dashboard',
        'Content-Type': 'text/markdown; charset=utf-8',
        'Content-Length': payload.length
    };

    const req = https.request({
        hostname: 'ntfy.sh',
        port: 443,
        path: `/${topic}`,
        method: 'POST',
        headers: headers
    }, (res) => {
        // Handle response
    });

    req.write(payload);
    req.end();
}
```

### PowerShell (`Invoke-RestMethod`)
```powershell
$NtfyUrl = "https://ntfy.sh/$NtfyTopic"
$Headers = @{
    "Title"     = "Today Tasks"
    "Priority"  = "high"
    "Markdown"  = "yes"
    "Click"     = "obsidian://open?vault=hola&file=inbox/Today"
    "Actions"   = "view, Open Today, obsidian://open?vault=hola&file=inbox/Today; view, Dashboard, obsidian://open?vault=hola&file=Dashboard"
}
$Utf8Bytes = [System.Text.Encoding]::UTF8.GetBytes($Message)
Invoke-RestMethod -Uri $NtfyUrl -Method Post -Body $Utf8Bytes -Headers $Headers -ContentType "text/markdown; charset=utf-8"
```

---

## 4. Best Practices & Guidelines

- **Zero Emojis in Headers**: Avoid passing random emojis or emoji tags unless specifically requested. Use clean ASCII titles.
- **Always Send Explicit UTF-8**: Ensure notification bodies are encoded as UTF-8 bytes to prevent double-encoding/mojibake.
- **Deep Links**: Use official app URI schemes (such as `obsidian://open?vault=...&file=...`) for instant 1-tap navigation to relevant notes.
