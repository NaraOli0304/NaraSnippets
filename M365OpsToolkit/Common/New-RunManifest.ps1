function New-M365OpsRunManifest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Operation,
        [ValidateSet("READ_ONLY","WHATIF","CHANGE_AUTHORIZED")][string]$Mode="READ_ONLY",
        [string]$TenantId,
        [string]$Account
    )
    [pscustomobject]@{
        Operation=$Operation
        Mode=$Mode
        TenantId=$TenantId
        Account=$Account
        Hostname=$env:COMPUTERNAME
        PowerShell=$PSVersionTable.PSVersion.ToString()
        TimestampUtc=(Get-Date).ToUniversalTime().ToString("o")
    }
}
