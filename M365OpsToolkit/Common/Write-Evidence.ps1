function Write-M365OpsEvidence {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object]$InputObject,
        [Parameter(Mandatory)][string]$Path
    )

    $dir=Split-Path -Parent $Path
    if($dir -and -not (Test-Path $dir)){ New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    switch(([IO.Path]::GetExtension($Path)).ToLowerInvariant()){
        ".json" { $InputObject | ConvertTo-Json -Depth 10 | Set-Content -Path $Path -Encoding UTF8 }
        ".csv"  { @($InputObject) | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8 }
        default { $InputObject | Out-File -FilePath $Path -Encoding UTF8 }
    }

    Get-FileHash -Path $Path -Algorithm SHA256
}
