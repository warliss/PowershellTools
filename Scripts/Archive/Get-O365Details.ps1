# Get Office 365 credential details
$Cred = Get-Credential

# Set up the session to connect to the Office 365 service/servers
$O365 = New-PSSession -Configuration Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $O365

# Connect to MSOnline service
Connect-MsolService -Credential $Cred

# Get a list of users
$O365Users = Get-MsolUser

# the $O365Users variable now contains all the information for all the users.