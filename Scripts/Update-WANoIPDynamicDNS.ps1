<#
Parameters:-
hostname - from input parameters
ip - taken from 'https://ifcfg.me/ip'
#>
Param(
  [string]$HostName = 'warliss.hopto.org',
  [string]$filePath,
  [string]$credential
)
[cmdletbinding()]

$credential = Import-Clixml -Path .\credential.xml
$ipFinder = (Invoke-WebRequest('https://ifcfg.me/ip'))

if($ipFinder.StatusCode -eq 200){
    $ipAddress = $ipFinder.content
    $update = (Invoke-WebRequest('https://dynupdate.no-ip.com/nic/update?hostname=' + $HostName +'&myip=' + $ipAddress) -Credential $credential).content
}else{
    Write-Host("Nope...")
}

#$ipAddress = $ipFinder.content
#$update = (Invoke-WebRequest('https://dynupdate.no-ip.com/nic/update?hostname=warliss.hopto.org&myip=' + $ipAddress) -Credential $credential).content