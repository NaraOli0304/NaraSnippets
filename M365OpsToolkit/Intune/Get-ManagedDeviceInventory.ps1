[CmdletBinding()]
param(
    [string]$OutputPath
)

$ErrorActionPreference="Stop"

Write-Host @"

==================================================
 INTUNE MANAGED DEVICE INVENTORY
 STRICT READ ONLY - NO CHANGES
==================================================

"@ -ForegroundColor Green

$devices=@(
    Get-MgDeviceManagementManagedDevice -All
)

$rows=@(
    $devices |
    Select-Object Id,DeviceName,OperatingSystem,OsVersion,ManagementAgent,ComplianceState,LastSyncDateTime,AzureAdDeviceId
)

if($OutputPath){
    $rows | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
}

$rows

[pscustomobject]@{
    ManagedDevices=$devices.Count
    OutputPath=$OutputPath
    GraphWrites=0
    DeviceChanges=0
    TenantChanges=0
} | Format-List
