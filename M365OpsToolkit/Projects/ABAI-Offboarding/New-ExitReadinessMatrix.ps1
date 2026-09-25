[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [Parameter(Mandatory = $true)]
    [object[]]$Workstream
)

$required = @(
    "Workstream",
    "Status",
    "Owner",
    "RemainingAction",
    "Evidence",
    "OperationalRisk",
    "TargetDate",
    "ExitCriterion",
    "GoNoGoConsequence"
)

$rows = foreach ($item in $Workstream) {
    $row = [ordered]@{}
    foreach ($name in $required) {
        $property = $item.PSObject.Properties[$name]
        $row[$name] = if ($property) { $property.Value } else { $null }
    }
    [pscustomobject]$row
}

$directory = Split-Path -Parent $Path
if ($directory -and -not (Test-Path $directory)) {
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
}

$rows | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8

$hash = Get-FileHash -Path $Path -Algorithm SHA256

[pscustomobject]@{
    Workstreams   = $rows.Count
    Ready         = @($rows | Where-Object { $_.Status -eq "READY" }).Count
    Blocked       = @($rows | Where-Object { $_.Status -eq "BLOCKED" }).Count
    Pending       = @($rows | Where-Object { $_.Status -eq "PENDING" }).Count
    EvidencePath  = $Path
    EvidenceSHA256 = $hash.Hash
    TenantChanges = 0
    Decision      = "EXIT_READINESS_MATRIX_CREATED"
} | Format-List
