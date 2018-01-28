<# 
 .Synopsis
  Displays uptime of a computer.

 .Description
  Displays the uptime of a computer.

 .Parameter computerName
  Which computer to get the uptime for.

 .Example
   # Get the uptime for the local computer
   Get-WAUptime

 .Example
   # Get the uptime for a remote computer
   Get-WAUptime -computerName seachw101

#>

function Get-WAUptime {
param(
[cmdletbinding()]
    [string[]] $computerName = $env:COMPUTERNAME,
    [switch] $UpSince,
    [switch] $Full
    )
    $CurrentDateTime = Get-Date 
    foreach ($computer in $computerName)
    {
        if(Test-Connection -ComputerName $computer -Count 1 -ea 0) 
			{
				Write-Verbose "$computer is online"
                $win32OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer
                $LastBootTime = [Management.ManagementDateTimeConverter]::ToDateTime($win32OperatingSystem.LastBootUpTime)
                $Uptime = $CurrentDateTime - $LastBootTime
                $UptimeDay = $Uptime.Days
                $UptimeHour = $Uptime.Hours
                $UptimeMin = $Uptime.Minutes
                $UptimeSecond = $Uptime.Seconds


                if($UpSince){
                    $UptimeString = "$computer Booted: $LastBootTime"
                    $UptimeString
                }else{
                    if($Full){
                        $UptimeString = "$computer Booted: $LastBootTime"
                        $UptimeString = "$UptimeString Uptime: $UptimeDay Days $UptimeHour Hours $UptimeMin Minutes $UptimeSecond Seconds - $Uptime"
                        $UptimeString
                        } else {
                            $UptimeString = "$computer Uptime: $UptimeDay Days $UptimeHour Hours $UptimeMin Minutes $UptimeSecond Seconds - $Uptime"
                            $UptimeString
                        }
                }
                
            } else {
				Write-Host "$computer is offline"
			}
    }
}
Export-ModuleMember -Function Get-WAUptime
