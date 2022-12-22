function Get-UpTimeAllServer {

# .SYNOPSIS
# Get-UpTimeAllServer is an advanced Powershell function. It shows the uptime of all domain joined and enabled Windows servers.
 
# .DESCRIPTION
# Uses Get-CimInstance and a Try/Catch block.
 
# .PARAMETER
# None
 
# .EXAMPLE
# Get-UpTimeAllServer
 
# .NOTES
# Author: Patrick Gruenauer
# Web: https://sid-500.com 
 
    $servers=(Get-ADComputer -Filter 'operatingsystem -like "*server*"-and enabled -eq "true"').Name
    $result=@()
    
    Foreach ($s in $servers) {
        Try {
            $up=(Get-CimInstance -ClassName win32_operatingsystem -ComputerName $s -ErrorAction Stop).LastBootUpTime
            $uptime=((Get-Date) - $up)
            $result+=New-Object -TypeName PSObject -Property ([ordered]@{
            'Server'=$s
            'LastBootUpTime'=$up
            'Days'=$uptime.Days
            'Hours'=$uptime.Hours
            'Minutes'=$uptime.Minutes
            'Seconds'=$uptime.Seconds
            })
        } Catch {
            $result+=New-Object -TypeName PSObject -Property ([ordered]@{
            'Server'=$s
            'LastBootUpTime'='Server could not be reached'})
        }
    }
}
