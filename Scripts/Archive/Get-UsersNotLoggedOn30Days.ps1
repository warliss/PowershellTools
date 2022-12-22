## Variables
# Query period
$32Days = (Get-Date).AddDays(-32)

# Output file - currently set to write the file to the H: drive, this could be changed if the script is automated.
$OutputFile = "H:\" + (Get-Date -Format "yyyyMMdd") + "Test_NoUserLogon30Days.csv"

# Grab details of users who have not logged in in over 32 days
$Users = Get-ADUser -Properties * -Filter {((LastLogonDate -le $32Days) -and (Enabled -eq $true) -and (eMailAddress -gt 0))} -SearchBase "OU=SEACHILL,DC=seachill,DC=com" | 
    Select-Object Name, Title, Mail, Office, LastLogonDate, Enabled, WhenCreated, WhenChanged |Sort-Object Office,Name | 
    Export-Csv -Path $OutputFile -NoTypeInformation