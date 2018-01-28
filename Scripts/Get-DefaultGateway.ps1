#####
#
# Get-DefaultGateway
# 
#####
#
# Author: Wayne Arliss
#
#####
#
# Description
# takes a computer name and checks for the default gateway on 
# all network interfaces of that computer
#
# Input can be either by single computer name (parameter -ComputerName) 
# or from an text file with one entry per line (parameter -InputFile)
# If neither parameters are passed the script with default to the local
# computer name Env:\COMPUTERNAME
#
#####
#
# Version History
#
# Date       |  V   | Notes
# 2017/03/17 |  0.a | Initial version
# 2017/03/21 |  0.1 | Rewritten GetGateway function to add details to an object for output
#
#
#
#####

Param(
  [string]$ComputerName = $env:COMPUTERNAME,
  [string]$FilePath
)

function GetGateway([string]$computer)
{
    <#Get-WmiObject win32_networkAdapterConfiguration -ComputerName $computer | 
    Select Index,Description,IPAddress,DefaultIPGateway |
    Where-Object defaultipgateway -NotLike ""#>
    
    # Collect WMI Objects
    $NetworkAdapterConfiguration = Get-WmiObject win32_NetworkAdapterConfiguration -ComputerName $computer | Where-Object defaultipgateway -NotLike ""
    $OutputArray += New-Object PSObject -Property @{HostName=$computer; 
        IPAddress=$NetworkAdapterConfiguration.IPAddress; 
        DefaultGateway=$NetworkAdapterConfiguration.DefaultIPGateway;
        Index=$NetworkAdapterConfiguration.Index;
        MACAddress=$NetworkAdapterConfiguration.MACAddress}
    $OutputArray
}

$OutputArray=@()
if(!$FilePath)
{
    Write-Verbose("No FilePath passed")
    GetGateway($ComputerName)
} else {
    Write-Verbose("FilePath passed")
    $Lines = Get-Content($FilePath)
    #$Lines.Length
    foreach($line in $Lines)
    {
        try
        {
            GetGateway($line)
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            if($ErrorMessage -like "Access is denied.*")
            {
                Write-Host("Permission denied for $computer, try running from Domain Admin account")
            } else {
                Write-Host("Error: $ErrorMessage")
            }
            Break
        }
        <#
        finally
        {
            Write-host("Done and dusted...")
        }#>
    }
}
