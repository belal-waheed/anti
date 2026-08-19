# Powershell script to deploy or synchronize Antigravity Hub skills, rules, and configs to ~/.gemini/config/
[CmdletBinding()]
param (
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$SourceRoot = Split-Path -Parent $PSScriptRoot
$GlobalConfig = Join-Path $HOME '.gemini\config'
$GlobalGeminiMd = Join-Path $HOME '.gemini\GEMINI.md'

Write-Host "Syncing Antigravity Hub to: $GlobalConfig" -ForegroundColor Cyan

# 1. Sync Skills
$DestSkills = Join-Path $GlobalConfig 'skills'
if (-not (Test-Path $DestSkills)) {
    New-Item -ItemType Directory -Path $DestSkills -Force | Out-Null
}

$SourceGlobalSkills = Join-Path $SourceRoot 'skills\global'
if (Test-Path $SourceGlobalSkills) {
    Get-ChildItem -Path $SourceGlobalSkills -Directory | ForEach-Object {
        $target = Join-Path $DestSkills $_.Name
        Write-Host "Syncing skill: $($_.Name)" -ForegroundColor Green
        if (-not $DryRun) {
            Copy-Item -Path $_.FullName -Destination $target -Recurse -Force
        }
    }
}

# 2. Sync Global GEMINI.md
$SourceGeminiMd = Join-Path $SourceRoot 'rules\global\GEMINI.md'
if (Test-Path $SourceGeminiMd) {
    Write-Host "Updating global rules: $GlobalGeminiMd" -ForegroundColor Green
    if (-not $DryRun) {
        Copy-Item -Path $SourceGeminiMd -Destination $GlobalGeminiMd -Force
    }
}

# 3. Sync Plugins
$DestPlugins = Join-Path $GlobalConfig 'plugins'
$SourcePlugins = Join-Path $SourceRoot 'plugins'
if (Test-Path $SourcePlugins) {
    Get-ChildItem -Path $SourcePlugins -Directory | Where-Object { $_.Name -ne 'starter-plugin-template' } | ForEach-Object {
        $target = Join-Path $DestPlugins $_.Name
        Write-Host "Syncing plugin: $($_.Name)" -ForegroundColor Green
        if (-not $DryRun) {
            Copy-Item -Path $_.FullName -Destination $target -Recurse -Force
        }
    }
}

Write-Host "Global synchronization complete!" -ForegroundColor Cyan
