Function Get-PageFile{
Param(
    [string]$ComputerName = "."
    )

Get-WmiObject -Class Win32_PageFileUsage -ComputerName $ComputerName |
    Select-Object @{Name="File";Expression = {$_.Name}},
        @{Name="Description";Expression={$_.Description}},
        @{Name="Base Size (Mb)";Expression = {$_.AllocatedBaseSize}},
        @{Name="Current Usage (Mb)";Expression={$_.CurrentUsage}},
        @{Name="Peak Size (Mb)"; Expression={$_.PeakUsage}}, 
        @{Name="Install Date";Expression={ $_.ConvertToDateTime($_.InstallDate) }}, 
        @{Name="Status";Expression={$_.Status}}, 
        TempPageFile
}

Function Test-MemoryUsage {
[cmdletbinding()]
Param(
    [string]$ComputerName = "."
    )

$os = Get-Ciminstance Win32_OperatingSystem -ComputerName $ComputerName
$pctFree = [math]::Round(($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100,2)
 
if ($pctFree -ge 45) {
$Status = "OK"
}
elseif ($pctFree -ge 15 ) {
$Status = "Warning"
}
else {
$Status = "Critical"
}
 
$os | Select @{Name = "Status";Expression = {$Status}},
@{Name = "PctFree"; Expression = {$pctFree}},
@{Name = "FreeGB";Expression = {[math]::Round($_.FreePhysicalMemory/1mb,2)}},
@{Name = "TotalGB";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}
 
}
Function Show-MemoryUsage {
 
[cmdletbinding()]
Param(
    [string]$ComputerName = "."
    )
 
#get memory usage data
$data = Test-MemoryUsage -ComputerName $ComputerName
 
Switch ($data.Status) {
"OK" { $color = "Green" }
"Warning" { $color = "Yellow" }
"Critical" {$color = "Red" }
}
 
$title = @"
 
Memory Check
------------
"@
 
Write-Host $title -foregroundColor Cyan
 
$data | Format-Table -AutoSize | Out-String | Write-Host -ForegroundColor $color
 
}
