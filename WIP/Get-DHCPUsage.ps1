$DHCPUsage = Get-EventLog -LogName System -ComputerName seaadmin -Newest 96 -InstanceId 1020
$DHCPAddressesAvailable = 125

foreach ($DHCPNote in $DHCPUsage){
    $OutputSplit = (($DHCPNote).Message).Split(",")
    $DHCPPCFull = ($DHCPNote.Message).ToString().Substring(24,2)
    $DHCPRemain = ($DHCPNote.Message).ToString().Substring(50,2)
    $OutputObject = New-Object -TypeName psobject
    $OutputObject | Add-Member -MemberType NoteProperty -name 'Time' -Value ($DHCPNote).TimeGenerated
    $OutputObject | Add-Member -MemberType NoteProperty -name 'Network' -Value $OutputSplit[1]
    $OutputObject | Add-Member -MemberType NoteProperty -name '% Full' -Value $DHCPPCFull
    $OutputObject | Add-Member -MemberType NoteProperty -name 'Remaining' -Value $DHCPRemain
    $OutputObject
}