<# Function Get-Last10Logons
This function checks the logfile location for the existance of a file named after the given computer name
If this exists then it will retrieve the last 10 lines from the log file and display them.

## Inputs

ComputerName

#>

function Get-Last10Logons{
[cmdletbinding()]
param([string]$ComputerName = 'SEACHW009')

$LogFileLocation = '\\SEACHFS1\Logins\Computer\'
$LogExt = '.txt'
# Check if the file exists:
<# - Remember the multiline comments!!!
if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent){
    Write-Verbose "Verbose"
}else{
    Write-Host "No Verbose"
}
#>
if($PSBoundParameters.ContainsKey('ComputerName')){
    Write-Verbose "ComputerName Supplied"
} else {
    Write-Verbose "ComputerName NOT Supplied"
}

$PSCmdlet.MyInvocation.BoundParameters
#$PSCmdlet.MyInvocation | Get-Member
$PSBoundParameters

#$FullLogName = $LogFileLocation + $ComputerName + $LogExt
#$LogFile = Get-Content -Path $FullLogName -Tail 10
#$LogFile


}