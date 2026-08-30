# PowerShell script to synchronize all active Antigravity configuration from ~/.gemini into Antigravity Hub (D:\dev\tools\antigravity)
[CmdletBinding()]
param (
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$DestRoot = Split-Path -Parent $PSScriptRoot
$GlobalConfig = Join-Path $HOME '.gemini\config'
$GlobalGeminiMd = Join-Path $HOME '.gemini\GEMINI.md'
$BuiltinSkills = Join-Path $HOME '.gemini\antigravity\builtin\skills'

Write-Host "Syncing active Antigravity setup from ~/.gemini to: $DestRoot" -ForegroundColor Cyan

# 1. Sync Global GEMINI.md
if (Test-Path $GlobalGeminiMd) {
    $DestRulesGlobal = Join-Path $DestRoot 'rules\global'
    if (-not (Test-Path $DestRulesGlobal)) { New-Item -ItemType Directory -Path $DestRulesGlobal -Force | Out-Null }
    
    Write-Host "Syncing GEMINI.md..." -ForegroundColor Green
    if (-not $DryRun) {
        Copy-Item -Path $GlobalGeminiMd -Destination (Join-Path $DestRulesGlobal 'GEMINI.md') -Force
        Copy-Item -Path $GlobalGeminiMd -Destination (Join-Path $DestRoot 'GEMINI.md') -Force
    }
}

# 2. Sync Global Skills (Cleanly copy folder contents)
$SourceSkills = Join-Path $GlobalConfig 'skills'
$DestGlobalSkills = Join-Path $DestRoot 'skills\global'

if (Test-Path $SourceSkills) {
    Get-ChildItem -Path $SourceSkills -Directory | ForEach-Object {
        $skillDir = Join-Path $DestGlobalSkills $_.Name
        if (-not (Test-Path $skillDir)) {
            New-Item -ItemType Directory -Path $skillDir -Force | Out-Null
        }
        Write-Host "Syncing skill: $($_.Name)" -ForegroundColor Green
        if (-not $DryRun) {
            Get-ChildItem -Path $skillDir -Directory | Where-Object { $_.Name -eq $_.Parent.Name } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            Copy-Item -Path (Join-Path $_.FullName '*') -Destination $skillDir -Recurse -Force
        }
    }
}

# 3. Sync Builtin Skills
$DestBuiltinSkills = Join-Path $DestRoot 'skills\builtin'

if (Test-Path $BuiltinSkills) {
    Get-ChildItem -Path $BuiltinSkills -Directory | ForEach-Object {
        $builtinDir = Join-Path $DestBuiltinSkills $_.Name
        if (-not (Test-Path $builtinDir)) {
            New-Item -ItemType Directory -Path $builtinDir -Force | Out-Null
        }
        Write-Host "Syncing builtin skill: $($_.Name)" -ForegroundColor Green
        if (-not $DryRun) {
            Get-ChildItem -Path $builtinDir -Directory | Where-Object { $_.Name -eq $_.Parent.Name } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            Copy-Item -Path (Join-Path $_.FullName '*') -Destination $builtinDir -Recurse -Force
        }
    }
}

# 4. Sync Plugins
$SourcePlugins = Join-Path $GlobalConfig 'plugins'
$DestPlugins = Join-Path $DestRoot 'plugins'

if (Test-Path $SourcePlugins) {
    Get-ChildItem -Path $SourcePlugins -Directory | ForEach-Object {
        $pluginDir = Join-Path $DestPlugins $_.Name
        if (-not (Test-Path $pluginDir)) {
            New-Item -ItemType Directory -Path $pluginDir -Force | Out-Null
        }
        Write-Host "Syncing plugin: $($_.Name)" -ForegroundColor Green
        if (-not $DryRun) {
            Get-ChildItem -Path $pluginDir -Directory | Where-Object { $_.Name -eq $_.Parent.Name } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            Copy-Item -Path (Join-Path $_.FullName '*') -Destination $pluginDir -Recurse -Force
        }
    }
}

# 5. Sync Configs & MCP (With Automatic Secret Sanitization)
$DestConfigsGlobal = Join-Path $DestRoot 'configs\global'
if (-not (Test-Path $DestConfigsGlobal)) { New-Item -ItemType Directory -Path $DestConfigsGlobal -Force | Out-Null }

$DestMcpConfigs = Join-Path $DestRoot 'mcp\configs'
if (-not (Test-Path $DestMcpConfigs)) { New-Item -ItemType Directory -Path $DestMcpConfigs -Force | Out-Null }

@('config.json', 'mcp_config.json', 'hooks.json') | ForEach-Object {
    $srcFile = Join-Path $GlobalConfig $_
    if (Test-Path $srcFile) {
        Write-Host "Syncing config file: $_" -ForegroundColor Green
        if (-not $DryRun) {
            $txt = Get-Content -Path $srcFile -Raw -Encoding utf8
            # Auto-sanitize secrets for git repository safety
            $txt = $txt -replace 'ghp_[A-Za-z0-9]+', 'YOUR_GITHUB_PERSONAL_ACCESS_TOKEN'
            $txt = $txt -replace 're_[A-Za-z0-9_]+', 'YOUR_RESEND_API_KEY'
            $txt = $txt -replace 'pat\.[A-Za-z0-9._-]+', 'YOUR_HARNESS_API_KEY'
            
            Set-Content -Path (Join-Path $DestConfigsGlobal $_) -Value $txt -Encoding utf8
            if ($_ -eq 'mcp_config.json') {
                Set-Content -Path (Join-Path $DestMcpConfigs $_) -Value $txt -Encoding utf8
            }
        }
    }
}

# 6. Sync Rules Templates & Scripts
$SourceRulesTemplates = Join-Path $GlobalConfig 'rules_templates'
$DestRulesTemplates = Join-Path $DestRoot 'rules_templates'
if (Test-Path $SourceRulesTemplates) {
    if (-not (Test-Path $DestRulesTemplates)) { New-Item -ItemType Directory -Path $DestRulesTemplates -Force | Out-Null }
    Get-ChildItem -Path $SourceRulesTemplates | ForEach-Object {
        if (-not $DryRun) { Copy-Item -Path $_.FullName -Destination (Join-Path $DestRulesTemplates $_.Name) -Force }
    }
}

$SourceScripts = Join-Path $GlobalConfig 'scripts'
$DestConfigScripts = Join-Path $DestRoot 'scripts\config_scripts'
if (Test-Path $SourceScripts) {
    if (-not (Test-Path $DestConfigScripts)) { New-Item -ItemType Directory -Path $DestConfigScripts -Force | Out-Null }
    Get-ChildItem -Path $SourceScripts | ForEach-Object {
        if (-not $DryRun) { Copy-Item -Path $_.FullName -Destination (Join-Path $DestConfigScripts $_.Name) -Force }
    }
}

Write-Host "Synchronization from ~/.gemini to $DestRoot complete!" -ForegroundColor Cyan
