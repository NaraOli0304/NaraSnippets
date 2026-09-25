[CmdletBinding()]
param()

$ErrorActionPreference="Stop"

Write-Host @"

==================================================
 AZURE SUBSCRIPTION INVENTORY
 STRICT READ ONLY - NO CHANGES
==================================================

"@ -ForegroundColor Green

$subs=@(
    Get-AzSubscription
)

$subs |
    Select-Object Id,Name,State,TenantId

[pscustomobject]@{
    SubscriptionCount=$subs.Count
    AzureChanges=0
    TenantChanges=0
} | Format-List
