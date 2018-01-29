<#
Parameters:-
hostname - from input parameters
ip - taken from 'https://ifcfg.me/ip'

Things still to be done
    1. Error handling for both the Invoke-WebRequest lines
    2. Check if credential file exists

#>
[cmdletbinding()]
Param(
  [string]$HostName = 'warliss.hopto.org',
  [string]$credentialPath = '.\credential.xml'
)

$credential = Import-Clixml -Path $credentialPath
$ipFinder = (Invoke-WebRequest('https://xxifcfg.me/ip'))

if($ipFinder.StatusCode -eq 200){
    Write-Verbose("StatusCode is good...")
    $ipAddress = $ipFinder.content
    Write-Verbose("IP Address is $ipAddress")
    $update = (Invoke-WebRequest('https://dynupdate.no-ip.com/nic/update?hostname=' + $HostName +'&myip=' + $ipAddress) -Credential $credential)
    write-host($update)
}else{
    $ErrorStatusCode = $ipFinder.StatusCode
    Write-Host("Error - $ErrorStatusCode")
}

#$ipAddress = $ipFinder.content
#$update = (Invoke-WebRequest('https://dynupdate.no-ip.com/nic/update?hostname=warliss.hopto.org&myip=' + $ipAddress) -Credential $credential).content