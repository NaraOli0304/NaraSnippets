[CmdletBinding()]
param(
    [string]$OutputPath
)

$ErrorActionPreference="Stop"

Write-Host @"

==================================================
 CONDITIONAL ACCESS INVENTORY
 STRICT READ ONLY - NO CHANGES
==================================================

"@ -ForegroundColor Green

$policies=@(
    Get-MgIdentityConditionalAccessPolicy -All
)

$rows=@(
    $policies |
    Select-Object Id,DisplayName,State,CreatedDateTime,ModifiedDateTime
)

if($OutputPath){
    $rows | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
}

$rows

[pscustomobject]@{
    PolicyCount=$policies.Count
    OutputPath=$OutputPath
    GraphWrites=0
    TenantChanges=0
} | Format-List
