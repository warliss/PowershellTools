$currentFile = "Seedrs.txt"
$amFile = "002.xlsx"
$pmFile = "002.csv"

$currentFileDate = Get-LMDate($currentFile)
    Write-Host "current file date: $currentFileDate"
$amFileDate = Get-LMDate($amFile)
    Write-Host "am file date: $amFileDate"
$pmFileDate = Get-LMDate($pmFile)
    Write-Host "pm file date: $pmFileDate"

if ($amFileDate -lt $pmFileDate){
    Write-Host "am is earlier"
}else{
    Write-Host "pm is earlier"
}

#### 
# get the file names and last write date/time into an array



#### Functions
Function Get-LMDate([string]$Filename){
    $FileDetails = Get-Item -Path $Filename
    return $FileDetails.LastWriteTime
}