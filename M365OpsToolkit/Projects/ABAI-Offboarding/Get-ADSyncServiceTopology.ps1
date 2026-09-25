[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string[]]$ComputerName,

    [string]$EvidenceRoot
)

$ErrorActionPreference = "Continue"

Write-Host @"

==================================================
 ADSYNC SERVICE TOPOLOGY
 STRICT READ ONLY - NO CHANGES
==================================================

"@ -ForegroundColor Green

$rows = @()

foreach ($computer in $ComputerName) {
    $query = @(& sc.exe "\\$computer" query ADSync 2>&1)
    $config = @(& sc.exe "\\$computer" qc ADSync 2>&1)
    $queryEx = @(& sc.exe "\\$computer" queryex ADSync 2>&1)

    $queryText = $query -join "`n"
    $configText = $config -join "`n"
    $queryExText = $queryEx -join "`n"

    $state = $null
    $startType = $null
    $binaryPath = $null
    $serviceAccount = $null
    $displayName = $null
    $serviceProcessId = $null

    if ($queryText -match "STATE\s+:\s+\d+\s+(\w+)") {
        $state = $Matches[1]
    }

    if ($configText -match "START_TYPE\s+:\s+\d+\s+([^\r\n]+)") {
        $startType = $Matches[1].Trim()
    }

    if ($configText -match "BINARY_PATH_NAME\s+:\s+([^\r\n]+)") {
        $binaryPath = $Matches[1].Trim()
    }

    if ($configText -match "SERVICE_START_NAME\s+:\s+([^\r\n]+)") {
        $serviceAccount = $Matches[1].Trim()
    }

    if ($configText -match "DISPLAY_NAME\s+:\s+([^\r\n]+)") {
        $displayName = $Matches[1].Trim()
    }

    if ($queryExText -match "PID\s+:\s+(\d+)") {
        $serviceProcessId = [int]$Matches[1]
    }

    $rows += [pscustomobject]@{
        ComputerName     = $computer
        ServiceFound     = ($queryText -match "SERVICE_NAME:\s+ADSync")
        State            = $state
        StartType        = $startType
        DisplayName      = $displayName
        ServiceAccount   = $serviceAccount
        BinaryPath       = $binaryPath
        ServiceProcessId = $serviceProcessId
    }
}

$rows | Format-List

if ($EvidenceRoot) {
    New-Item -ItemType Directory -Path $EvidenceRoot -Force | Out-Null
    $csv = Join-Path $EvidenceRoot "ADSync-ServiceTopology.csv"
    $rows | Export-Csv -Path $csv -NoTypeInformation -Encoding UTF8
    Get-FileHash -Path $csv -Algorithm SHA256 | Format-List
}

[pscustomobject]@{
    HostsChecked  = $rows.Count
    ADSyncHosts   = @($rows | Where-Object ServiceFound).Count
    RunningHosts  = @($rows | Where-Object { $_.State -eq "RUNNING" }).Count
    StoppedHosts  = @($rows | Where-Object { $_.State -eq "STOPPED" }).Count
    ADChanges     = 0
    SyncChanges   = 0
    TenantChanges = 0
    Decision      = if (@($rows | Where-Object { $_.State -eq "RUNNING" }).Count -gt 0) {
        "ACTIVE_ADSYNC_SERVICE_HOST_CONFIRMED"
    }
    else {
        "ADSYNC_ACTIVE_HOST_NOT_CONFIRMED"
    }
} | Format-List
