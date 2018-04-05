################################################################################
# Set-XMLCredentials.ps1
################################################################################
#
#
################################################################################
[cmdletbinding()]
Param(
    [SecureString]$CredentialFileName = "default.credential"
)

$CredXMLPath = Join-Path (Split-Path $profile) $CredentialFileName
$Credential = Get-Credential
$Credential | Export-Clixml -Path $CredXMLPath

