[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
param(
    [Parameter(Mandatory)][string[]]$UserPrincipalName,
    [string]$RoleGroup="Reviewer",
    [switch]$Execute
)

$ErrorActionPreference="Stop"

$group=Get-RoleGroup -Identity $RoleGroup -ErrorAction Stop
$roles=@($group.Roles | ForEach-Object { ($_ -split "/")[-1] } | Sort-Object -Unique)

if($roles.Count -ne 1 -or $roles[0] -ne "Review"){
    throw "Safety gate failed: '$RoleGroup' does not contain only the Review role."
}

$current=@(Get-RoleGroupMember -Identity $RoleGroup -ResultSize Unlimited -ErrorAction Stop)

foreach($user in $UserPrincipalName){
    $recipient=Get-Recipient -Identity $user -ErrorAction Stop
    $exists=@($current | Where-Object {
        $_.Guid -eq $recipient.Guid -or
        $_.ExchangeObjectId -eq $recipient.Guid -or
        $_.Alias -ieq $user
    }).Count -gt 0

    if($exists){
        Write-Host "$user already present." -ForegroundColor Green
        continue
    }

    if(-not $Execute){
        Add-RoleGroupMember -Identity $RoleGroup -Member $user -WhatIf
        continue
    }

    if($PSCmdlet.ShouldProcess($user,"Add to Purview role group '$RoleGroup'")){
        Add-RoleGroupMember -Identity $RoleGroup -Member $user -ErrorAction Stop
    }
}

if(-not $Execute){
    Write-Host "Dry-run only. Re-run with -Execute to permit changes." -ForegroundColor Green
}
