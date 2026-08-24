[CmdletBinding(SupportsShouldProcess)]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $IsWindows) {
    throw 'This installer currently supports Windows only.'
}

$espanso = Get-Command espanso -ErrorAction SilentlyContinue
if (-not $espanso) {
    throw 'Espanso was not found in PATH. Install Espanso 2.4 or later first.'
}

$source = Join-Path $PSScriptRoot 'snippets\nara.yml'
$matchDirectory = Join-Path $env:APPDATA 'espanso\match'
$destination = Join-Path $matchDirectory 'nara.yml'
$backupDirectory = Join-Path $env:APPDATA 'espanso\backups'

if (-not (Test-Path -LiteralPath $source)) {
    throw "Snippet source was not found: $source"
}

New-Item -ItemType Directory -Path $matchDirectory -Force | Out-Null

if (Test-Path -LiteralPath $destination) {
    New-Item -ItemType Directory -Path $backupDirectory -Force | Out-Null
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backup = Join-Path $backupDirectory "nara-$timestamp.yml"
    if ($PSCmdlet.ShouldProcess($backup, 'Back up existing snippets')) {
        Copy-Item -LiteralPath $destination -Destination $backup -Force
        Write-Host "Backup created: $backup"
    }
}

if ($PSCmdlet.ShouldProcess($destination, 'Install curated snippets')) {
    Copy-Item -LiteralPath $source -Destination $destination -Force
    & $espanso.Source restart
    & $espanso.Source status
    Write-Host "Installed: $destination"
}
