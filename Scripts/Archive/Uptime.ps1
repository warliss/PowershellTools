function Get-Uptime {
param(
    [string] $computerName = $env:COMPUTERNAME
    )
    $CurrentDateTime = Get-Date 
    $win32OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem
    $LastBootTime = [Management.ManagementDateTimeConverter]::ToDateTime($win32OperatingSystem.LastBootUpTime)
    $Uptime = $CurrentDateTime - $LastBootTime
    $UptimeString = "Uptime: " + $Uptime.Days + " Days " + $Uptime.Hours + " Hours " + $Uptime.Minutes + " Minutes " + $Uptime.Seconds + " Seconds..."
    $UptimeString
}
Export-ModuleMember -Function Get-Uptime
