[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$DomainSuffix
)

$ErrorActionPreference="Stop"

Write-Host @"

==================================================
 ENTRA USER DOMAIN INVENTORY
 STRICT READ ONLY - NO CHANGES
==================================================

"@ -ForegroundColor Green

$escaped=$DomainSuffix.Replace("'","''")

$users=@(
    Get-MgUser -All -Property "id,displayName,userPrincipalName,mail,userType,accountEnabled,onPremisesSyncEnabled" |
    Where-Object {
        $_.UserPrincipalName -like "*@$DomainSuffix" -or
        $_.Mail -like "*@$DomainSuffix"
    }
)

$users |
    Select-Object Id,DisplayName,UserPrincipalName,Mail,UserType,AccountEnabled,OnPremisesSyncEnabled

[pscustomobject]@{
    DomainSuffix=$DomainSuffix
    UsersFound=$users.Count
    GraphWrites=0
    TenantChanges=0
} | Format-List
