$OutputFile = 'h:\ADUserLastLogin_Coated.csv'
$SearchBase = "OU=Users,OU=CHILLED,OU=SEACHILL,DC=seachill,DC=com"
Get-ADUser -Filter * -SearchBase "OU=Users,OU=CHILLED,OU=SEACHILL,DC=seachill,DC=com" -ResultPageSize 0 -Prop CN,samaccountname,lastLogonTimestamp,UserPrincipalName,Enabled | 
    Select CN,samaccountname,@{n="lastLogonDate";e={[datetime]::FromFileTime($_.lastLogonTimestamp)}},UserPrincipalName,Enabled |
    Export-CSV -NoType -Path $OutputFile

$OutputObject = Get-ADUser -Filter * -SearchBase $SearchBase
$OutputObject | Sort-Object -Property Surname | Export-Csv -Path