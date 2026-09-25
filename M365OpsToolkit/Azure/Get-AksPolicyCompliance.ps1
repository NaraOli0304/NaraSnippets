[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string[]]$SubscriptionId,

    [Parameter(Mandatory = $true)]
    [string[]]$PolicyAssignmentName
)

$ErrorActionPreference = "Stop"

Write-Host @"

==================================================
 AKS POLICY COMPLIANCE BASELINE
 STRICT READ ONLY - NO CHANGES
==================================================

"@ -ForegroundColor Green

$rows = @()
$detailRows = @()

foreach ($subId in $SubscriptionId) {
    Set-AzContext -SubscriptionId $subId -ErrorAction Stop | Out-Null

    $path = "/subscriptions/$subId/providers/Microsoft.PolicyInsights/policyStates/latest/queryResults?api-version=2019-10-01"
    $response = Invoke-AzRestMethod -Method POST -Path $path -Payload "{}" -ErrorAction Stop
    $json = $response.Content | ConvertFrom-Json
    $states = @($json.value)

    foreach ($assignmentName in $PolicyAssignmentName) {
        $matches = @($states | Where-Object { $_.policyAssignmentName -eq $assignmentName })
        $compliant = @($matches | Where-Object { $_.complianceState -eq "Compliant" }).Count
        $nonCompliant = @($matches | Where-Object { $_.complianceState -eq "NonCompliant" }).Count
        $other = @($matches | Where-Object { $_.complianceState -notin @("Compliant","NonCompliant") }).Count

        $rows += [pscustomobject]@{
            SubscriptionId  = $subId
            AssignmentName  = $assignmentName
            EvaluatedStates = $matches.Count
            Compliant       = $compliant
            NonCompliant    = $nonCompliant
            OtherState      = $other
        }

        foreach ($state in $matches) {
            if ($state.complianceState -eq "NonCompliant") {
                $detailRows += [pscustomobject]@{
                    SubscriptionId = $subId
                    AssignmentName = $assignmentName
                    ResourceId      = $state.resourceId
                    ResourceType    = $state.resourceType
                    ComplianceState = $state.complianceState
                    Timestamp       = $state.timestamp
                }
            }
        }
    }
}

$rows | Sort-Object SubscriptionId,AssignmentName

[pscustomobject]@{
    AssignmentStateRows = $rows.Count
    NonCompliantStates  = (@($detailRows)).Count
    AzureChanges        = 0
    PolicyChanges       = 0
    TenantChanges       = 0
    Decision            = "CURRENT_POLICY_COMPLIANCE_BASELINE_READY"
} | Format-List
