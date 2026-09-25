[CmdletBinding()]
param(
    [string[]]$SubscriptionName
)

$ErrorActionPreference="Stop"

Write-Host @"

==================================================
 AKS INVENTORY
 STRICT READ ONLY - NO CHANGES
==================================================

"@ -ForegroundColor Green

$rows=@()

$targets = if($SubscriptionName){ $SubscriptionName } else { @(Get-AzSubscription | Select-Object -ExpandProperty Name) }

foreach($name in $targets){
    $sub=Get-AzSubscription -SubscriptionName $name -ErrorAction Stop
    Set-AzContext -SubscriptionId $sub.Id | Out-Null

    $clusters=@(Get-AzAksCluster -ErrorAction SilentlyContinue)

    foreach($c in $clusters){
        $rows += [pscustomobject]@{
            SubscriptionName=$sub.Name
            SubscriptionId=$sub.Id
            ResourceGroup=$c.ResourceGroupName
            ClusterName=$c.Name
            Location=$c.Location
            KubernetesVersion=$c.KubernetesVersion
        }
    }
}

$rows

[pscustomobject]@{
    ClusterCount=$rows.Count
    AzureChanges=0
    TenantChanges=0
} | Format-List
