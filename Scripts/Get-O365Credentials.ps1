################################################################################
# Get-O365Credentials.ps1
#
# This script reads the credentials required for connecting to Office 365
# from an XML file.
#
################################################################################
#   Version   # Initials # Notes
#     0.a     #    WA    # Initial version
#             #          # 
#             #          # 
#             #          # 
#             #          # 
################################################################################
[cmdletbinding()]
param(
    [string]$CredentialLocation = 'h:\StoredCredential.xml'
)

## Create an object to host the credentials
$Credentials = Import-Clixml -Path $CredentialLocation

Write-Verbose $Credentials

$office365 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/?proxymethod=rps" -Credential $Credentials  -Authentication "Basic"   –AllowRedirection
$O365Results = Import-PSSession $office365 -AllowClobber
Remove-PSSession $O365Results

