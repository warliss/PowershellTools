$UserList = Get-ADUser -SearchBase 'OU=Remote,OU=SEACHILL,DC=Seachill,DC=com' -Properties SamAccountName -Filter *

foreach ($User in $UserList){
    $Detail = Get-ADUser -Identity $User -Properties LastLogonDate
    $LastLogonDate = $Detail.LastLogonDate
    $UserName = $Detail.Name

    $Now = Get-Date

    $Age = New-TimeSpan -Start $LastLogonDate -End $Now
    if(($Age.Days) -gt 90 -and ($User.Enabled) -eq $true){
        Write-Host "Name: $UserName LLD: $LastLogonDate"
    }else{
        Write-Host "Name: $UserName is ok"
    }
}