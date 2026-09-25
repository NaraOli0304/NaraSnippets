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


Describe "ABAI reusable discovery guards" {
    It "does not overwrite the automatic PID variable in ADSync discovery" {
        $path = Join-Path $PSScriptRoot "../Projects/ABAI-Offboarding/Get-ADSyncServiceTopology.ps1"
        $content = Get-Content $path -Raw
        $content | Should -Not -Match '(?m)^\s*\$PID\s*='
        $content | Should -Match 'ServiceProcessId'
    }

    It "keeps ADSync topology discovery read-only" {
        $path = Join-Path $PSScriptRoot "../Projects/ABAI-Offboarding/Get-ADSyncServiceTopology.ps1"
        $content = Get-Content $path -Raw
        $content | Should -Match 'sc\.exe'
        $content | Should -Match 'query ADSync'
        $content | Should -Match 'qc ADSync'
        $content | Should -Not -Match '(?i)Start-Service|Stop-Service|Set-Service|Start-ADSyncSyncCycle|Set-ADSync'
    }

    It "requires explicit exit criteria in the readiness matrix" {
        $path = Join-Path $PSScriptRoot "../Projects/ABAI-Offboarding/New-ExitReadinessMatrix.ps1"
        $content = Get-Content $path -Raw
        $content | Should -Match 'ExitCriterion'
        $content | Should -Match 'GoNoGoConsequence'
    }
}
