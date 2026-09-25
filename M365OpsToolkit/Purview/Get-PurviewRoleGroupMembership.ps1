[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$RoleGroup,
    [Parameter(Mandatory)][string]$Identity
)

$ErrorActionPreference="Stop"

$members=@(Get-RoleGroupMember -Identity $RoleGroup -ResultSize Unlimited -ErrorAction Stop)
$recipient=Get-Recipient -Identity $Identity -ErrorAction SilentlyContinue
$guid=if($recipient){$recipient.Guid}else{$null}

$matches=@(
    $members | Where-Object {
        $_.Alias -ieq $Identity -or
        $_.PrimarySmtpAddress -ieq $Identity -or
        $_.WindowsLiveID -ieq $Identity -or
        ($guid -and $_.Guid -eq $guid) -or
        ($guid -and $_.ExchangeObjectId -eq $guid)
    }
)

[pscustomobject]@{
    RoleGroup=$RoleGroup
    Requested=$Identity
    TotalMembers=$members.Count
    MemberConfirmed=($matches.Count -gt 0)
    DisplayName=($matches.DisplayName -join "; ")
    Alias=($matches.Alias -join "; ")
    Guid=($matches.Guid -join "; ")
    TenantChanges=0
} | Format-List
