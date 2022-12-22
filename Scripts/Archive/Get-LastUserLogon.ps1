$OUName = 'OU=Users,OU=UKGMB,OU=HFG,DC=int,DC=hiltonfoods,DC=com' # 'OU=SEACHILL,DC=seachill,DC=com'
$AllUsers = Get-ADUser -SearchBase $OUName -Filter *
$NameList = $AllUsers.SAMAccountName
$DateToday = Get-Date -Format 'yyyyMMdd'
$ExportFileName = "H:\UserDetail-$DateToday.csv" 
$OutputObject = New-Object -TypeName psobject

foreach ($Name in $NameList){
    $dcs = Get-ADDomainController -Filter *
    $LastLogonTime = 0
    $UserEnabled = ""
    $Office = ""
    foreach($dc in $dcs){
        $hostname = $dc.HostName
        $user = Get-ADUser -Identity $Name -Properties LastLogon, PwdLastSet, Enabled, Office
        $LastLogonTime = $user.LastLogon
        $PwdLastSet = $user.pwdLastSet
        $Office = $user.Office
        $UserEnabled = $user.Enabled.ToString()
    }
    $LastLogonTimeDT = [DateTime]::FromFileTime($LastLogonTime)
    $PwdLastSetDT = [DateTime]::FromFileTime($PwdLastSet)

    $OutputObject | Add-Member -MemberType NoteProperty -Name UserName -Value $Name
    $OutputObject | Add-Member -MemberType NoteProperty -Name LastLogon -Value $LastLogonTimeDT
    $OutputObject | Add-Member -MemberType NoteProperty -Name PwdLastSet -Value $PwdLastSetDT
    $OutputObject | Add-Member -MemberType NoteProperty -Name Enabled -Value $UserEnabled
    $OutputObject | Add-Member -MemberType NoteProperty -Name Office -Value $Office
    $OutputObject | Export-Csv -Path $ExportFileName -NoTypeInformation
}