function Get-WALockedAccount{
[cmdletbinding()]
param (
    [Switch]$ListAll
)

if($ListAll){
    $LockedAccounts = Search-ADAccount -LockedOut
    foreach ($LockedAccount in $LockedAccounts){
        $OutputObj = New-Object -TypeName PSObject
        $OutputObj | Add-Member -MemberType NoteProperty -Name Status -Value "Locked"
        $OutputObj | Add-Member -MemberType NoteProperty -Name UserName -Value $LockedAccount.Name
        $OutputObj | Add-Member -MemberType NoteProperty -Name LastLogonDate -Value $LockedAccount.LastLogonDate        
        $OutputObj
        }
    }
}

function Get-WADisabledAccount{
[cmdletbinding()]
param (
    [Switch]$ListAll,
    [switch]$Users,
    [Switch]$Computers

)

if($ListAll){
    $DisabledAccounts = Search-ADAccount -AccountDisabled
    }
if ($Users){
    $DisabledAccounts = Search-ADAccount -AccountDisabled -UsersOnly
    }
if ($Computers){
    $DisabledAccounts = Search-ADAccount -AccountDisabled -ComputersOnly
    }
foreach ($DisabledAccount in $DisabledAccounts){
    $OutputObj = New-Object -TypeName PSObject
    $OutputObj | Add-Member -MemberType NoteProperty -Name Type -Value $DisabledAccount.ObjectClass
    $OutputObj | Add-Member -MemberType NoteProperty -Name Status -Value "Disabled"
    $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $DisabledAccount.Name
    $OutputObj | Add-Member -MemberType NoteProperty -Name LastLogonDate -Value $DisabledAccount.LastLogonDate
    $OutputObj | Add-Member -MemberType NoteProperty -Name SamAccountName -Value $DisabledAccount.SamAccountName
    $OutputObj 
    }
}
