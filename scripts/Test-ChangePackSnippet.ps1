#requires -Version 7.2
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ChangePackRoot,
    [string]$SnippetPath = (Join-Path $PSScriptRoot '..\snippets\nara.yml')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSStyle.OutputRendering = 'PlainText'

Import-Module (Join-Path $ChangePackRoot 'ChangePack365.psd1') -Force

$content = Get-Content -LiteralPath $SnippetPath -Raw
$pattern = '(?s)trigger:\s*":cpverify"\s+label:[^\r\n]+\s+replace:\s*"([^"\r\n]+)"'
$expansions = [regex]::Matches($content, $pattern)
if ($expansions.Count -ne 1) {
    throw 'Expected exactly one quoted cpverify expansion.'
}

$fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ('nara-cpverify-' + [guid]::NewGuid().ToString('N'))
try {
    $parameters = @{
        CaseId = 'SNIPPET-TEST'
        Title = 'Offline snippet compatibility test'
        TenantId = '11111111-2222-4333-8444-555555555555'
        TenantDisplayName = 'Fictional lab'
        Account = 'operator@contoso.example'
        RootPath = $fixtureRoot
        Mode = 'ReadOnly'
    }
    $Case = New-CP365Case @parameters
    $command = [scriptblock]::Create($expansions[0].Groups[1].Value)
    $rendered = & $command | Out-String -Width 200
    if ($rendered -notmatch '(?m)^\s*Valid\s*:\s*True\s*$' -or
        $rendered -notmatch '(?m)^\s*Entries\s*:\s*1\s*$') {
        throw 'cpverify did not render a valid ledger with the case-created event.'
    }

    [pscustomobject]@{ Valid = $true; Trigger = ':cpverify'; Entries = 1; Offline = $true }
} finally {
    if (Test-Path -LiteralPath $fixtureRoot) {
        Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
    }
}
