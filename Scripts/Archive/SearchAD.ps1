## List all users that have their AD Account locked:
$SearchBase = "OU=CHILLED,OU=SEACHILL,DC=seachill,DC=com"
$LockedAccounts = Search-ADAccount -LockedOut -SearchBase $SearchBase
$Count = (Search-ADAccount -LockedOut -SearchBase $SearchBase).Count
$NumberOfLockedAccounts = 0
foreach($Account in $LockedAccounts){
    $NumberOfLockedAccounts++
    Write-Host($Account.Name + ": Locked")
    $Unlock = Read-Host -Prompt "Unlock Account?"
    if ($Unlock -eq "Y" -or $Unlock -eq "y"){
        Unlock-ADAccount -Identity $Account.SamAccountName
        Write-Host "Unlocked"
        
    }else {
        Write-Host "Still Locked"
    }
}
$Count
<#
$NumberOfLockedAccounts


Get-ADUser -Filter {-not (LastLogonTimeStamp -Like "*")} -Properties * | Sort-Object Created |Format-Table -AutoSize -Property Name, SamAccountName, UserPrincipalName, Enabled, Created
#>
