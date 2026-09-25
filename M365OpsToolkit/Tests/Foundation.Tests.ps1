Describe "M365OpsToolkit foundation" {
    It "does not hardcode obvious secret assignments in PowerShell files" {
        $root = Join-Path $PSScriptRoot ".."
        $files = Get-ChildItem $root -Recurse -File -Include *.ps1,*.psm1
        $content = ($files | Get-Content -Raw) -join "`n"
        $content | Should -Not -Match '(?i)(clientsecret|appsecret|password)\s*=\s*["'']\S+'
    }
}
