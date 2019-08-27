[cmdletbinding()]
Param(
    [string]$ServerList = 'd:\serverlist.txt'
)
$ThrowError = $false
# What are the computer names we want to get the CPU Usage for
# Read from the following file
if (Test-Path $ServerList){
    $Servers = Get-Content $ServerList
} else {
    $ThrowError = $true
    Write-Host ("File ($ServerList) not found")
    $ThrowError
}


# Functions
Function Test_MemoryUsage($ComputerName){
    $os = Get-CimInstance Win32_OperatingSystem -ComputerName $ComputerName
    $pctFree = [math]::Round(($os.FreePhysicalMemory / $os.TotalVisibleMemorySize)* 100, 2)
    
    if ($pctFree -ge 45){ $Status = "OK" }
    elseif ($pctFree -ge 15){ $Status = "Warning" }
    else { $Status = "Critical" }
    $os | Select-Object @{Name = "Status";Expression = {$Status}},
    @{Name = "PctFree"; Expression = {$pctFree}},
    @{Name = "FreeGB";Expression = {[math]::Round($_.FreePhysicalMemory/1mb,2)}},
    @{Name = "TotalGB";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}
}

if ($ThrowError -ne $false){
    foreach($Server in $Servers){
        $TimeStamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        $LoadPercentage = Get-WmiObject win32_processor -ComputerName $Server | Select-Object -ExpandProperty LoadPercentage
        $os = Test_MemoryUsage($Server)
        $log = New-Object -TypeName psobject -Property @{
            Time = $TimeStamp
            Server = $Server
            LoadPercentage = ($LoadPercentage | Measure-Object -Average).Average
            MemoryStatus = $os.Status
            MemoryFreePCT = $os.PctFree
            FreeMemory = $os.FreeGB
            TotalMemory = $os.TotalGb
            Notes = ''
        }
        # This line writes $log to screen. This could be written to a file to keep a log of the CPU Usage for the servers.
        $Log | Export-Csv -Path h:\UsageCheck.csv -Append -NoTypeInformation
    }
}else{
    $TimeStamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $TimeStamp
    $log = New-Object -TypeName psobject -Property @{
        Time = $TimeStamp
        Server = $null
        LoadPercentage = $null
        MemoryStatus = $null
        MemoryFreePCT = $null
        FreeMemory = $null
        TotalMemory = $null
        Notes = "Error: File $Servers not found, please check $ try again."
    }
}
Write-Host("Output: $TimeStamp")