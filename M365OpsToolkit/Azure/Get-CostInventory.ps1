[CmdletBinding()]
param(
    [Parameter(Mandatory)][datetime]$StartDate,
    [Parameter(Mandatory)][datetime]$EndDate
)

$ErrorActionPreference="Stop"

Write-Warning "This helper intentionally does not guess a cost-export source."
Write-Host "Use an approved Azure Cost Management export/API source, then normalize into this toolkit's evidence model."

[pscustomobject]@{
    StartDate=$StartDate
    EndDate=$EndDate
    Status="SOURCE_REQUIRED"
    AzureChanges=0
    TenantChanges=0
} | Format-List
