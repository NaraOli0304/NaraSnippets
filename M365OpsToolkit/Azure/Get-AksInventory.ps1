[CmdletBinding()]
param(
    [string[]]$SubscriptionName
)

$ErrorActionPreference = "Stop"

Write-Host @"

==================================================
 AKS INVENTORY
 STRICT READ ONLY - NO CHANGES
==================================================

"@ -ForegroundColor Green

$rows = @()

$targets = if ($SubscriptionName) {
    $SubscriptionName
}
else {
    @(
        Get-AzSubscription |
        Where-Object { $_.State -eq "Enabled" } |
        Select-Object -ExpandProperty Name
    )
}

foreach ($name in $targets) {
    $sub = Get-AzSubscription -SubscriptionName $name -ErrorAction Stop
    Set-AzContext -SubscriptionId $sub.Id -ErrorAction Stop | Out-Null

    # Az.Resources is sufficient for inventory; no Az.Aks dependency is required.
    $clusters = @(
        Get-AzResource -ResourceType "Microsoft.ContainerService/managedClusters" -ErrorAction Stop
    )

    foreach ($cluster in $clusters) {
        $detail = Get-AzResource -ResourceId $cluster.ResourceId -ExpandProperties -ErrorAction Stop

        $azurePolicyEnabled = $null
        try {
            $azurePolicyEnabled = $detail.Properties.addonProfiles.azurePolicy.enabled
        }
        catch {
            $azurePolicyEnabled = $null
        }

        $rows += [pscustomobject]@{
            SubscriptionName   = $sub.Name
            SubscriptionId     = $sub.Id
            ResourceGroup      = $cluster.ResourceGroupName
            ClusterName        = $cluster.Name
            Location           = $cluster.Location
            KubernetesVersion  = $detail.Properties.kubernetesVersion
            ProvisioningState  = $detail.Properties.provisioningState
            EnableRBAC         = $detail.Properties.enableRBAC
            AzurePolicyEnabled = $azurePolicyEnabled
            ResourceId         = $cluster.ResourceId
        }
    }
}

$rows

[pscustomobject]@{
    ClusterCount  = $rows.Count
    AzureChanges  = 0
    TenantChanges = 0
    Decision      = "AKS_INVENTORY_COMPLETE"
} | Format-List
