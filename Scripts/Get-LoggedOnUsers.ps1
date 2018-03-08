<#
.SYNOPSIS
Get-LoggedOnUsers - Returns a list of logged on users from a given computer or list of computers

.DESCRIPTION 
Returns a list of logged on users from a given computer or list of computers

.OUTPUTS
Outputs the results, which can be exported to a csv 

.NOTES
Written by: Wayne Arliss

.EXAMPLE
.\Get-LoggedOnUsers.ps1 
Runs and exports the information

Change Log
V1.00, 08/03/2018 - Initial version

License:

The MIT License (MIT)

Copyright (c) 2018 Wayne Arliss

Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights 
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.
#>

[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string[]]$ComputerList)

## Check if $ComputerList is not empty
if ($ComputerList.Length -ne 0){
    foreach ($Computer in $ComputerList){
        $ComputerDetails = Get-WmiObject -ComputerName $Computer -Class Win32_ComputerSystem
        #Write-Host $ComputerDetails.Name "-" $ComputerDetails.UserName
        $OutputObject = New-Object -TypeName PSObject
        $OutputObject | Add-Member -MemberType NoteProperty -Name ComputerName -Value $ComputerDetails.Name
        $OutputObject | Add-Member -MemberType NoteProperty -Name LoggedOnUser -Value $ComputerDetails.UserName
        $OutputObject
    }
}