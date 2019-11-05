$Today = Get-Date -Format yyyyMMdd # When am I running?
$ComputerList = "computers.txt" # Which computers to back up
$Computers = Get-Content -Path $ComputerList # Get a full list of the computers
$SoftwareLocation = "\Program Files (x86)\Systems Intergrator\*.xml" # Update for correct SI OCM software location
$BackupLocation = "D:\Dev\PowershellTools\" # Where to back the files up to

foreach ($Computer in $Computers){
    $ArchiveFile = $BackupLocation + $Computer + "_" + $Today +".zip"
    $Files = "\\" + $Computer + "\c$" + $SoftwareLocation
    # Uncomment the next line to do the work
    #Compress-Archive -Path $Files -DestinationPath $ArchiveFile -CompressionLevel Optimal -Force
}
