function Get-LocalUser ($Computername = $env:COMPUTERNAME) {
    Get-WmiObject -Query "Select * from Win32_UserAccount Where LocalAccount = 'True'" -ComputerName $ComputerName |
    Select-Object Name, Disabled, Caption
}

## Build a list of computers
$ComputerList = Get-ADComputer -SearchBase "OU=Servers,OU=CHILLED,OU=SEACHILL,DC=seachill,DC=com" -Filter * | Select-Object Name | Sort-Object Name
foreach ($Computer in $ComputerList){
    $Computer
    Get-LocalUser -ComputerName $Computer
    }

