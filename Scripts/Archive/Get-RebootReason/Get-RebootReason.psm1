Function Get-RebootReason{
<#
   .Synopsis
    Queries the given computer to find the reason for reboots 

   .Description
    Module queries either local computer or remote computer to find
    the reason for reboots

   .Example
    Get-RebootReason
    
    Displays the reboot reason for the local computer
        
   .Example
    Get-RebootReason -ComputerName seachsage1

    Displays the reboot reason for the computer called seachsage1
   
   .Parameter ComputerName
    The DNS name (or IP address) for the remote computer

   .Inputs
    [System.String]

   .Outputs
    [System.IO.FileInfo]

   .Notes
    NAME: Get-REbootReason
    AUTHOR: Wayne Arliss
    LASTEDIT: 02/07/2018
    KEYWORDS: System, Reboot, util

#>

param(
[cmdletbinding()]
    [string] $ComputerName = $env:COMPUTERNAME
)


Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{logname='System'; id=1074}  | 
    ForEach-Object {
        $rv = New-Object PSObject | Select-Object Date, User, Action, Process, Reason, ReasonCode, Comment
        $rv.Date = $_.TimeCreated
        $rv.User = $_.Properties[6].Value
        $rv.Process = $_.Properties[0].Value
        $rv.Action = $_.Properties[4].Value
        $rv.Reason = $_.Properties[2].Value
        $rv.ReasonCode = $_.Properties[3].Value
        $rv.Comment = $_.Properties[5].Value
        $rv
        } | 
    Select-Object Date, Action, Reason, User
}

Export-ModuleMember -Function Get-RebootReason