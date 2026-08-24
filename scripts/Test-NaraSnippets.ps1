[CmdletBinding()]
param(
    [string]$Path = (Join-Path $PSScriptRoot '..\snippets\nara.yml')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$resolved = (Resolve-Path -LiteralPath $Path).Path
$content = Get-Content -LiteralPath $resolved -Raw

$triggerMatches = [regex]::Matches($content, '(?m)^\s*-\s+trigger:\s*"([^"]+)"')
if ($triggerMatches.Count -eq 0) {
    throw 'No Espanso triggers were found.'
}

$triggers = @($triggerMatches | ForEach-Object { $_.Groups[1].Value })
$duplicates = @($triggers | Group-Object | Where-Object Count -gt 1)
if ($duplicates.Count -gt 0) {
    throw "Duplicate triggers: $($duplicates.Name -join ', ')"
}

$checks = [ordered]@{
    'GUID or tenant-like identifier' = '(?i)\b[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\b'
    'email address' = '(?i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b'
    'secret assignment' = '(?i)\b(client_secret|access_token|refresh_token|password)\b\s*[:=]'
    'shell or script extension' = '(?mi)^\s*type:\s*(shell|script)\s*$'
    'dynamic variables block' = '(?mi)^\s*vars:\s*$'
}

foreach ($check in $checks.GetEnumerator()) {
    if ($content -match $check.Value) {
        throw "Privacy/safety check failed: $($check.Key)."
    }
}

[pscustomobject]@{
    Valid = $true
    Path = $resolved
    TriggerCount = $triggers.Count
    Triggers = $triggers
}
