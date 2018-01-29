<# 
 .Synopsis
  Displays the Last logon for given user.

 .Description
  Displays the Last logon for given user.

 .Parameter computerName
  UserName - String containing the user name of the required user

 .Example
   # Displays the last logon for BillWithers
   Get-ADUserLastLogon -UserName BillWithers
#>

Import-Module ActiveDirectory

function Get-ADUserLastLogon{
param(
    [string]$UserName
    )
    $dcs = Get-ADDomainController -Filter {Name -like "*"}
    $time = 0
    foreach($dc in $dcs){
        $hostname = $dc.HostName
        $user = Get-ADUser $UserName | Get-ADObject -Properties lastLogon 
        if($user.LastLogon -gt $time){
            $time = $user.LastLogon
        }
    }
    $dt = [DateTime]::FromFileTime($time)
    Write-Host "$username last logged on at: $dt"
}
Export-ModuleMember -Function Get-ADUserLastLogon
#Get-ADUserLastLogon -UserName TimKnight