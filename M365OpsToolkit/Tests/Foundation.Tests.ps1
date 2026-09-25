Describe "M365OpsToolkit foundation" {
    It "does not hardcode obvious secret assignments in PowerShell files" {
        $root = Join-Path $PSScriptRoot ".."
        $files = Get-ChildItem $root -Recurse -File -Include *.ps1,*.psm1
        $content = ($files | Get-Content -Raw) -join "`n"
        $content | Should -Not -Match '(?i)(clientsecret|appsecret|password)\s*=\s*["'']\S+'
    }

    It "keeps AKS inventory independent of Az.Aks" {
        $path = Join-Path $PSScriptRoot "../Azure/Get-AksInventory.ps1"
        $content = Get-Content $path -Raw
        $content | Should -Not -Match "Get-AzAksCluster"
        $content | Should -Match "Microsoft\.ContainerService/managedClusters"
    }

    It "uses REST for AKS policy compliance instead of requiring Az.PolicyInsights" {
        $path = Join-Path $PSScriptRoot "../Azure/Get-AksPolicyCompliance.ps1"
        $content = Get-Content $path -Raw
        $content | Should -Match "Invoke-AzRestMethod"
        $content | Should -Not -Match "Get-AzPolicyState"
    }
}
