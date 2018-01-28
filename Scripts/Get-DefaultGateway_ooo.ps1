$computer = $env:COMPUTERNAME
#$computer = "192.168.45.83"

$Output = Get-WmiObject win32_networkAdapterConfiguration -ComputerName $computer | 
    Select index,description,defaultipgateway |
    Where-Object defaultipgateway -NotLike ""
