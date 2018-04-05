################################################################################
# Set-O365Credentials.ps1
#
# This script writes the credentials required for connecting to Office 365
# to an XML file.
#
################################################################################
#  Version #    Date    # Initials # Notes
#    0.a   # 2018/02/02 #    WA    # Initial version
#          #            #          # 
#          #            #          # 
#          #            #          # 
#          #            #          # 
################################################################################
[cmdletbinding()]
param(
    [string]$CredentialLocation = 'h:\StoredCredentials.xml'
)

# Read Credentials
$Credentials = Get-CliXML $CredentialLocation


