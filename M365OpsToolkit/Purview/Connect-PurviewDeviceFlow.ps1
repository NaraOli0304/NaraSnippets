[CmdletBinding()]
param([Parameter(Mandatory)][string]$UserPrincipalName)

$ErrorActionPreference="Stop"
if($PSVersionTable.PSVersion.Major -lt 7){ throw "PowerShell 7+ is required." }

Import-Module ExchangeOnlineManagement -Force -ErrorAction Stop
Connect-ExchangeOnline -Device -ShowBanner:$false
Connect-IPPSSession -UserPrincipalName $UserPrincipalName -DisableWAM -ShowBanner:$false

Write-Host "Purview session initialized." -ForegroundColor Green
