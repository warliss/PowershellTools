## list IP addresses
for ($a=2; $a -lt 255; $a++)
{
    $IPAddress = "192.168.45.$a"
    if(Test-Connection -IPAddress $IPAddress -Count 1 -ErrorAction 0)
    {
    try{
        $Hostname = [System.Net.Dns]::GetHostByAddress($IPAddress).Hostname
        $OutputObject = New-Object -TypeName PSObject
        $OutputObject | Add-Member -MemberType NoteProperty -Name IPAddress -Value $IPAddress
        $OutputObject | Add-Member -MemberType NoteProperty -Name State -Value "Up"
        $OutputObject | Add-Member -MemberType NoteProperty -Name HostName -Value $HostName
        $OutputObject
        }
    catch {
        $OutputObject = New-Object -TypeName PSObject
        $OutputObject | Add-Member -MemberType NoteProperty -Name IPAddress -Value $IPAddress
        $OutputObject | Add-Member -MemberType NoteProperty -Name State -Value "Up"
        $OutputObject | Add-Member -MemberType NoteProperty -Name HostName -Value "Unknown - Non Windows" -Force
        $OutputObject
    }
    }else {
        $OutputObject = New-Object -TypeName PSObject
        $OutputObject | Add-Member -MemberType NoteProperty -Name IPAddress -Value $IPAddress
        $OutputObject | Add-Member -MemberType NoteProperty -Name State -Value "Down"
        $OutputObject
    }
}