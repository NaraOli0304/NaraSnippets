[CmdletBinding()]
param([string[]]$Scopes=@("User.Read.All","Directory.Read.All"))

$ErrorActionPreference="Stop"
Import-Module Microsoft.Graph.Authentication -ErrorAction Stop

Connect-MgGraph -Scopes $Scopes -UseDeviceCode -NoWelcome

$ctx=Get-MgContext
[pscustomobject]@{
    Account=$ctx.Account
    TenantId=$ctx.TenantId
    AuthType=$ctx.AuthType
    Scopes=($ctx.Scopes -join "; ")
} | Format-List
