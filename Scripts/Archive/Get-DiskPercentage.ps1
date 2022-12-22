function Get-DiskPercentage(){
    [cmdletbinding()]
    param(
        [string]$ComputerName = $env:COMPUTERNAME
    )
    #$computername = hostname
    Get-WmiObject win32_logicaldisk -computername $ComputerName -Filter "DriveType='3'" | select PSComputerName,name,freespace,size,@{Name='disk percentage %';Expression={($_.freespace / $_.size)*100}}
}

$ComputerList = "seaadmin","seachw009"

foreach ($Computer in $ComputerList){
    Get-DiskPercentage -ComputerName $Computer | Format-Table -AutoSize
    }