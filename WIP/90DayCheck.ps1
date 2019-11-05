
# Create a variable holding the date 90 days ago
$90Days = (Get-Date).AddDays(-90)
Get-ADUser -Properties * -Filter {(lastLogonDate -notlike "*" -OR LastLogonDate -le $90Days) -and (passwordlastset -le $90Days) -and (Enabled -eq $true)} | 
   Select-Object Name, SAMAccountName, PasswordExpired, LogonCount, physicalDeliveryOfficeName, WhenCreated, LastLogonDate, PasswordLastSet, Enabled | Sort-Object LastLogonDate | Export-Csv -Path h:\AccountsNotUsedFor90Days.csv -NoTypeInformation
