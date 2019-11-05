<#

(New-Object -ComObject WScript.Shell).SendKeys('{NUMLOCK}')
(New-Object -ComObject WScript.Shell).SendKeys('{CAPSLOCK}')
(New-Object -ComObject WScript.Shell).SendKeys('{SCROLLLOCK}')

#>
## remote turn off caps lock

# 1. invoke a PSSession on the remote computer
$RemoteComputer = "seachw011"
$RemoteSession = New-PSSession -ComputerName $RemoteComputer
