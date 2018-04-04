$OutputFile = 'h:\ADUserLastLogin_Coated.csv'
Get-ADUser -Filter * -SearchBase "OU=Users,OU=COATED,OU=SEACHILL,DC=seachill,DC=com" -ResultPageSize 0 -Prop CN,samaccountname,lastLogonTimestamp,UserPrincipalName,Enabled | 
    Select CN,samaccountname,@{n="lastLogonDate";e={[datetime]::FromFileTime($_.lastLogonTimestamp)}},UserPrincipalName,Enabled |
    Export-CSV -NoType -Path $OutputFile