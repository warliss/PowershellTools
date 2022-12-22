[cmdletbinding()]
Param(
    [string]$ServerFileName = 'h:\serverslist.txt'
)
# What are the computer names we want to get the CPU Usage for
# Read from the following file
$Servers = Get-Content $ServerFileName

# Functions
Function Test_MemoryUsage($ComputerName){
    $os = Get-CimInstance Win32_OperatingSystem -ComputerName $ComputerName
    $pctFree = [math]::Round(($os.FreePhysicalMemory / $os.TotalVisibleMemorySize)* 100, 2)
    
    if ($pctFree -ge 45){ $Status = "OK" }
    elseif ($pctFree -ge 15){ $Status = "Warning" }
    else { $Status = "Critical" }
    $os | Select @{Name = "Status";Expression = {$Status}},
    @{Name = "PctFree"; Expression = {$pctFree}},
    @{Name = "FreeGB";Expression = {[math]::Round($_.FreePhysicalMemory/1mb,2)}},
    @{Name = "TotalGB";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}
}

foreach($Server in $Servers)
{
    $TimeStamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $LoadPercentage = Get-WmiObject win32_processor -ComputerName $Server | select -ExpandProperty LoadPercentage
    $os = Test_MemoryUsage($Server)
    $log = New-Object psobject -Property @{
        Time = $TimeStamp
        Server = $Server
        LoadPercentage = ($LoadPercentage | measure -Average).Average
        MemoryStatus = $os.Status
        MemoryFreePCT = $os.PctFree
        FreeMemory = $os.FreeGB
        TotalMemory = $os.TotalGb
    }
    # This line writes $log to screen. This could be written to a file to keep a log of the CPU Usage for the servers.
    $Log | Export-Csv -Path h:\UsageCheck.csv -Append -NoTypeInformation
}