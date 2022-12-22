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
    [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    #Get computers by either method
    [string[]] $computerName = $env:COMPUTERNAME,
    [string] $ComputerList,
    [switch] $UpSince,
    [switch] $Full
    )
    $Skip = $false
    # Read the contents of the file and add it to the $Computers array
    if($ComputerList){
        Write-Verbose("Read the text file list of computers")
        # Should check if the file exists first
        if(Test-Path -Path $ComputerList){
            $computerName = Get-Content $ComputerList
        }else{
            Write-Verbose ("File $ComputerList is missing")
            $Skip = $true
        }
    }
    if(!$Skip){
        # Get the current date
        $CurrentDateTime = Get-Date
        foreach ($computer in $computerName){
                
        # Is $computer online?
        if(Test-Connection -ComputerName $computer -Count 1 -ea 0){
            Write-Verbose "$computer is online"

            try{
                # Get uptime information about $computer
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
            }
            catch {
                $_.Exception.GetType()
            }
        } else {
            Write-Host "$computer is offline"
        }
    }
    }else{
        Write-Host ("Unable to process list, no action taken")
    }
}
Export-ModuleMember -Function Get-WAUptime
