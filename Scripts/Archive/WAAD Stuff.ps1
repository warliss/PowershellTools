$DisabledAccounts = Search-ADAccount -AccountDisabled -Usersonly
foreach ($DisabledAccount in $DisabledAccounts){
    $DisabledAccount.Name 
    $DisabledAccount.LastLogonDate
}

$LockedAccounts = Search-ADAccount -LockedOut
foreach ($LockedAccount in $LockedAccounts){
    $LockedAccount.Name
    $LockedAccount.LastLogonDate
}