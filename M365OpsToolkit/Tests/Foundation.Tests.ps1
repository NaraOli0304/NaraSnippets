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


Describe "Secure skill intake guards" {
    It "requires a SKILL.md presence check in the skill scanner" {
        $path = Join-Path $PSScriptRoot "../Common/Test-AgentSkill.ps1"
        $content = Get-Content $path -Raw
        $content | Should -Match 'SKILL\.md'
        $content | Should -Match 'REJECT_MISSING_SKILL_MD'
    }

    It "flags remote execution and prompt-injection patterns" {
        $path = Join-Path $PSScriptRoot "../Common/Test-AgentSkill.ps1"
        $content = Get-Content $path -Raw
        $content | Should -Match 'RemoteExecution'
        $content | Should -Match 'PromptInjection'
        $content | Should -Match 'MANUAL_REVIEW_REQUIRED'
    }

    It "documents that third-party skills are untrusted until reviewed" {
        $path = Join-Path $PSScriptRoot "../docs/SECURE-SKILL-INTAKE.md"
        $content = Get-Content $path -Raw
        $content | Should -Match 'untrusted dependencies'
        $content | Should -Match 'pinning the reviewed revision'
        $content | Should -Match 'Sandboxed validation'
    }

    It "requires deeper review for AI agent and MCP changes" {
        $path = Join-Path $PSScriptRoot "../Projects/VibeCoding/README.md"
        $content = Get-Content $path -Raw
        $content | Should -Match 'LLM prompts, tools, agents, MCP servers'
        $content | Should -Match 'Third-party skills are not installed directly'
    }
}
