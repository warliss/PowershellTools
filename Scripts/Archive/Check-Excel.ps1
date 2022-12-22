function Check_Excel{
[cmdletbinding()]
param([string[]] $ComputerName = $env:COMPUTERNAME)

# Test if Excel is running
$Excel = Get-Process -ComputerName $ComputerName -Name "Excel" -ErrorAction SilentlyContinue
if ($Excel){
    Write-Host ("Excel is running on $ComputerName")
    }else{
    Write-Host ("Excel is NOT running on $ComputerName")
    }
}