# -----------------------------------------------------------------------------  
# 
# Script: Update-NoIPDynamicDNS.ps1 
# Author: Keith Rochester  
# Date: 08/10/2015 
# Keywords: IP,DNS,NO-IP,DynamicDNS 
# Download: http://gallery.technet.microsoft.com/PowerShell-Script-to-5e465785 
# Usage: .\Update-NoIPDynamicDNS.ps1 -Creditials Get-Credential -HostRecord myhost.no-ip.biz 
# comments:  
# 
# Updates NO-IP Host record with passed IP if no IP is passed it retrieves  
# the external IP and updates NO-IP Host Record with that. 
# 
# Required Parameters: Credentials - Used to Authenticate to No-IP, HostRecord -  
# Record to be updated 
#  
# Optional Parameters: IPAddress - IP address for host record 
# 
# 
# ToDo: Validate Host Record passed to script is correctly formatted 
# ToDo: More (ok some) error handling :-) 
# -----------------------------------------------------------------------------  
 
[CmdletBinding()] 
Param( 
  [Parameter(Mandatory=$True)] 
  [ValidateNotNull()] 
  [System.Management.Automation.PSCredential] 
  [System.Management.Automation.Credential()] 
  $Creditials = [System.Management.Automation.PSCredential]::Empty, 
     
  [Parameter(Mandatory=$True)] 
  [ValidateNotNull()] 
  [string]$HostRecord, 
 
  [Parameter()] 
  [ValidateNotNull()] 
  [IPAddress]$IPAddress 
) 
 
# -----------------------------------------------------------------------------  
# Start of Functions 
  
function Update-NOIPHostRecord  
# Function: Update-NOIPHostRecord  
# 
# Uses Web requests to update NO-IP Host record with IP more information about  
# The No-IP Web Service (API) here http://www.noip.com/integrate/request  
{ 
Param( 
  [Parameter(Mandatory=$True)] 
  [ValidateNotNull()] 
  [System.Management.Automation.PSCredential] 
  [System.Management.Automation.Credential()] 
  $Creditials = [System.Management.Automation.PSCredential]::Empty, 
 
  [Parameter(Mandatory=$True)] 
  [ValidateNotNull()] 
  [string]$HostRecord, 
 
  [Parameter(Mandatory=$True)] 
  [ValidateNotNull()] 
  [IPAddress]$IPAddress 
) 
 
Write-Verbose "Attempting to update host record" 
try 
{ 
# Web Request to URL built from host record,IP address, and Username and password 
# This is the bit that updates the host record 
$update=(Invoke-WebRequest ('https://dynupdate.no-ip.com/nic/update?hostname='+$HostRecord + '&myip='+$IPAddress) -Credential $Creditials).content  
} 
Catch 
{ 
Write-output "Failed to invoke web to update host record request error was: $_.Exception.Message" 
exit 
} 
 
Write-Verbose "Host record update attemped. Update message was: $update" 
 
# Split the results of the update and return as powershell object 
$update = $update.split(" ") 
$UpdateResult = New-Object System.Object 
$UpdateResult | Add-Member -MemberType NoteProperty -Name Result -Value $update[0] 
if ($update[1]) 
    { 
    $UpdateResult | Add-Member -MemberType NoteProperty -Name IP -Value $update[1] 
    } 
    else 
    { 
    $UpdateResult | Add-Member -MemberType NoteProperty -Name IP -Value $null 
    } 
  
Return $UpdateResult 
}# End of Update-NOIPHostRecord Function 
 
Function Get-ExternalIP 
{ 
# Function: Get-ExternalIP  
# 
# Uses Web request to ifcfg.me/ip to retrieve the external IP 
 
 
Write-Verbose "Attempting to get external IP Address from ifcfg.me/IP" 
try 
{ 
$ExternalIP=((Invoke-WebRequest ifcfg.me/ip).Content -replace "[^\d\.]").Trim() 
} 
Catch 
{ 
Write-output "Failed to invoke web to retrieve external IP request error was: $_.Exception.Message" 
exit 
} 
 
Write-Verbose "External IP Address: $ExternalIP" 
Return $ExternalIP 
 
} #End of Get-ExternalIP Function 
 
# End of Functions 
# -----------------------------------------------------------------------------  
 
 
# -----------------------------------------------------------------------------  
# Start of Main Script Block 
 
# If No IP address has been passed get the current external IP 
if(!$IPAddress) 
{ 
Write-Verbose "No IP address passed get external IP" 
$IPAddress=Get-ExternalIP 
} 
 
Write-verbose "Use Update-NOIPHostRecord to update host record" 
$update = Update-NOIPHostRecord -Creditials $Creditials -HostRecord $HostRecord -IPAddress $IPAddress 
 
 
Write-Output $update 
#End of Main Script Block 
# ----------------------------------------------------------------------------- 