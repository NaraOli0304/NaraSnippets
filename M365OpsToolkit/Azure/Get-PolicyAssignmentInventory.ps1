[CmdletBinding()]
param()

$ErrorActionPreference="Stop"

Write-Host @"

==================================================
 AZURE POLICY ASSIGNMENT INVENTORY
 STRICT READ ONLY - NO CHANGES
==================================================

"@ -ForegroundColor Green

$assignments=@(
    Get-AzPolicyAssignment
)

$assignments |
    Select-Object Name,DisplayName,Scope,PolicyDefinitionId,EnforcementMode

[pscustomobject]@{
    PolicyAssignments=$assignments.Count
    AzureChanges=0
    TenantChanges=0
} | Format-List
