# PowerShell script to initialize an .agents/ workspace bundle in any target project repository
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$TargetDirectory
)

$ErrorActionPreference = 'Stop'
$SourceRoot = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path $TargetDirectory)) {
    Write-Error "Target directory does not exist: $TargetDirectory"
}

$AgentsDir = Join-Path $TargetDirectory '.agents'
$RulesDir = Join-Path $AgentsDir 'rules'
$SkillsDir = Join-Path $AgentsDir 'skills'
$PluginsDir = Join-Path $AgentsDir 'plugins'

New-Item -ItemType Directory -Path $AgentsDir, $RulesDir, $SkillsDir, $PluginsDir -Force | Out-Null

# Copy templates
Copy-Item -Path (Join-Path $SourceRoot 'configs\workspace\GEMINI.md') -Destination (Join-Path $TargetDirectory 'GEMINI.md') -Force
Copy-Item -Path (Join-Path $SourceRoot 'configs\workspace\hooks.json') -Destination (Join-Path $AgentsDir 'hooks.json') -Force
Copy-Item -Path (Join-Path $SourceRoot 'configs\workspace\mcp_config.json') -Destination (Join-Path $AgentsDir 'mcp_config.json') -Force
Copy-Item -Path (Join-Path $SourceRoot 'configs\workspace\skills.json') -Destination (Join-Path $AgentsDir 'skills.json') -Force
Copy-Item -Path (Join-Path $SourceRoot 'configs\workspace\plugins.json') -Destination (Join-Path $AgentsDir 'plugins.json') -Force

# Copy workspace rule templates
Copy-Item -Path (Join-Path $SourceRoot 'rules\workspace\*') -Destination $RulesDir -Recurse -Force

Write-Host "Successfully initialized .agents/ workspace bundle in: $TargetDirectory" -ForegroundColor Green
