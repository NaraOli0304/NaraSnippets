[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $Path)) {
    throw "Skill path not found: $Path"
}

$root = (Resolve-Path -LiteralPath $Path).Path
$files = @(
    Get-ChildItem -LiteralPath $root -Recurse -File -ErrorAction Stop
)

$patterns = @(
    [pscustomobject]@{ Severity="High"; Category="RemoteExecution"; Pattern='(?i)(curl|wget).*(\||;).*\b(sh|bash|zsh|pwsh|powershell)\b'; Note="Remote content piped into a shell" },
    [pscustomobject]@{ Severity="High"; Category="PowerShellRemoteExecution"; Pattern='(?i)Invoke-(WebRequest|RestMethod).*(iex|Invoke-Expression)|Invoke-Expression.*Invoke-(WebRequest|RestMethod)'; Note="Downloaded content executed directly" },
    [pscustomobject]@{ Severity="High"; Category="Destructive"; Pattern='(?i)\b(rm\s+-rf|Remove-Item\s+.+-Recurse.+-Force|Format-Volume|Clear-Disk|Remove-Az|Remove-Mg)\b'; Note="Potential destructive operation" },
    [pscustomobject]@{ Severity="High"; Category="Privilege"; Pattern='(?i)\b(sudo|runas|Start-Process.+-Verb\s+RunAs)\b'; Note="Privilege elevation requested" },
    [pscustomobject]@{ Severity="High"; Category="CredentialAccess"; Pattern='(?i)(\.ssh|id_rsa|id_ed25519|credential|token|secret|password).*(cat|type|Get-Content|read|upload|post|send)'; Note="Possible credential/secret access" },
    [pscustomobject]@{ Severity="Medium"; Category="EnvironmentEnumeration"; Pattern='(?i)\b(env|printenv|Get-ChildItem\s+Env:|dir\s+env:)\b'; Note="Environment variable enumeration" },
    [pscustomobject]@{ Severity="Medium"; Category="NetworkWrite"; Pattern='(?i)\b(curl\s+.*(-X\s*(POST|PUT|PATCH|DELETE)|--data|-d\s)|Invoke-RestMethod.+-Method\s+(POST|PUT|PATCH|DELETE)|Invoke-WebRequest.+-Method\s+(POST|PUT|PATCH|DELETE))\b'; Note="Network mutation or upload" },
    [pscustomobject]@{ Severity="Medium"; Category="PackageInstall"; Pattern='(?i)\b(npm|pnpm|yarn|pip|pipx|brew|apt|apt-get|winget|choco)\s+(install|add)\b'; Note="Package installation" },
    [pscustomobject]@{ Severity="Medium"; Category="GitWrite"; Pattern='(?i)\bgit\s+(push|commit|tag|reset\s+--hard|clean\s+-fd)\b'; Note="Repository mutation" },
    [pscustomobject]@{ Severity="Medium"; Category="EncodedPayload"; Pattern='(?i)(frombase64string|base64\s+(-d|--decode)|[A-Za-z0-9+/]{160,}={0,2})'; Note="Encoded/obfuscated payload requires review" },
    [pscustomobject]@{ Severity="Medium"; Category="PromptInjection"; Pattern='(?i)(ignore\s+(all\s+)?previous\s+instructions|override\s+(system|developer)\s+instructions|reveal\s+(system\s+prompt|secrets?|tokens?))'; Note="Instruction attempting to override authority or expose data" }
)

$findings = @()
$readErrors = @()
$filesReviewed = 0
$filesSkipped = 0

foreach ($file in $files) {
    $extension = [IO.Path]::GetExtension($file.Name).ToLowerInvariant()
    if ($extension -in @(".png",".jpg",".jpeg",".gif",".pdf",".zip",".exe",".dll",".bin")) {
        $filesSkipped++
        continue
    }

    $content = $null
    try {
        $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction Stop
    }
    catch {
        $readErrors += $file.FullName.Substring($root.Length).TrimStart("\\","/")
        continue
    }
    $filesReviewed++

    foreach ($rule in $patterns) {
        $matches = [regex]::Matches($content, $rule.Pattern)
        foreach ($match in $matches) {
            $prefix = $content.Substring(0, $match.Index)
            $line = ([regex]::Matches($prefix, "`n")).Count + 1

            $findings += [pscustomobject]@{
                Severity = $rule.Severity
                Category = $rule.Category
                File     = $file.FullName.Substring($root.Length).TrimStart("\","/")
                Line     = $line
                Note     = $rule.Note
                Evidence = ($match.Value -replace '\s+', ' ').Trim()
            }
        }
    }
}

$skillMd = Join-Path $root "SKILL.md"

$summary = [pscustomobject]@{
    SkillPath      = $root
    SkillMdPresent = Test-Path -LiteralPath $skillMd
    FilesDiscovered = $files.Count
    FilesReviewed  = $filesReviewed
    FilesSkipped   = $filesSkipped
    ReadErrors     = @($readErrors).Count
    UnreadableFiles = $readErrors
    HighFindings   = @($findings | Where-Object Severity -eq "High").Count
    MediumFindings = @($findings | Where-Object Severity -eq "Medium").Count
    Decision       = if (-not (Test-Path -LiteralPath $skillMd)) {
        "REJECT_MISSING_SKILL_MD"
    }
    elseif ($readErrors.Count -gt 0) {
        "REJECT_UNREADABLE_FILE"
    }
    elseif (@($findings | Where-Object Severity -eq "High").Count -gt 0) {
        "MANUAL_REVIEW_REQUIRED_HIGH_RISK"
    }
    elseif ($findings.Count -gt 0) {
        "MANUAL_REVIEW_REQUIRED"
    }
    else {
        "STATIC_SCREEN_CLEAR_MANUAL_REVIEW_STILL_REQUIRED"
    }
}

$findings | Sort-Object Severity,File,Line | Format-Table -AutoSize
$summary | Format-List
