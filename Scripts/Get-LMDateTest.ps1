##### Initialize
[cmdletbinding()]
Param(
  [string]$currentFile = ".\ADUserCommands.txt",
  [string]$amFile = ".\Connect-ExchangeOnline.ps1",
  [string]$pmFile = ".\Get-CPULoadPercentage.ps1"
)

##### Functions
Function Get-LMDate([string]$Filename){
    $FileDetails = Get-Item -Path $Filename
    return $FileDetails.LastWriteTime
}

##### Main Section
$currentFileDate = Get-LMDate($currentFile)
Write-Verbose "current file: $currentFile date: $currentFileDate"

$amFileDate = Get-LMDate($amFile)
Write-Verbose "am file: $amFile date: $amFileDate"

$pmFileDate = Get-LMDate($pmFile)
Write-Verbose "pm file: $pmFile date: $pmFileDate"

if ($amFileDate -lt $pmFileDate){
    Write-Verbose "am is earlier"
}else{
    Write-Verbose "pm is earlier"
}
