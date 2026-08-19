---
name: obsidian-cli
description: Usage patterns, URI handlers, and PowerShell automation scripts for interacting with the Obsidian desktop application. Trigger when automating note creation, vault navigation, search queries, or integrating terminal scripts with Obsidian.
---

# Obsidian CLI, URI Handlers & PowerShell Automation

## When to use this skill
Trigger whenever automating actions in an Obsidian vault via Windows PowerShell scripts, terminal commands, or deep-link URI schemes (`obsidian://`).

---

## 1. Core Obsidian URI Schemes

All URIs must be URL-encoded (`%20` for spaces, `%0A` for newlines):

### A. Open File or Dashboard
```
obsidian://open?vault=hola&file=Hola
obsidian://open?vault=hola&file=03-inbox%2FTask-Plan
```

### B. Create New Note with Content
```
obsidian://new?vault=hola&file=03-inbox%2FQuickNote&content=%23%20Quick%20Note%0A-%20Item%201
```

### C. Execute Vault Search
```
obsidian://search?vault=hola&query=tag%3A%23now
```

---

## 2. Windows PowerShell Automation Script

Save in `01-obsidian/scripts/quick-capture.ps1` or run directly in terminal:

```powershell
# Quick Capture to Obsidian Inbox
param (
    [Parameter(Mandatory=$true)]
    [string]$Title,
    
    [string]$Content = "",
    [string]$VaultName = "hola"
)

$dateStamp = Get-Date -Format "yyyy-MM-dd"
$timeFormatted = Get-Date -Format "yyyy-MM-dd_HH-mm"
$fileName = "03-inbox/Task-$timeFormatted"

$noteBody = @"
---
type: task-plan
date: $dateStamp
tags: [task, capture]
stage: #now
---

# $Title

$Content

- [ ] $Title #now
"@

$encodedVault = [System.Uri]::EscapeDataString($VaultName)
$encodedFile = [System.Uri]::EscapeDataString($fileName)
$encodedContent = [System.Uri]::EscapeDataString($noteBody)

$uri = "obsidian://new?vault=$encodedVault&file=$encodedFile&content=$encodedContent"
Start-Process $uri
Write-Host "Note created and opened in Obsidian: $fileName" -ForegroundColor Green
```

---

## Things to Avoid

- Avoid missing URL encoding on query parameters (special characters like `#` or `&` will break URI parsing if not encoded).
- Avoid launching URIs without checking if the Obsidian app is installed.
