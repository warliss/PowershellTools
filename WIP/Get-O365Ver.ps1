foreach ($computer in (Get-Content "h:\computers.txt")){
  write-verbose "Working on $computer..." -Verbose
  Invoke-Command -ComputerName "$Computer" -ScriptBlock {
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\O365ProPlusRetail* |
    Select-Object DisplayName, DisplayVersion, Publisher
  } | export-csv h:\O365_Version_results.csv -Append -NoTypeInformation
}