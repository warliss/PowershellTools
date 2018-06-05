$ComputerList = Get-ADComputer -Filter * -SearchBase "OU=Laptops,OU=Computers,OU=Chilled,OU=Seachill,DC=seachill,DC=com" -Properties Name,Description
foreach ($computer in $ComputerList){
    $computer |Export-Csv -Path "d:\Laptops.csv" -NoTypeInformation -Append
}