<#
 .Synopsis
  Displays last logon date/time for given user

 .Description
  Displays last logon date/time for given user, this returns the Users name, the last logon date & time and if the account is enabled

 .Parameter UserName
  Which AD User do you want the information for?
  
 .Example
   # Get the Last Logon for a specified user
   Get-ADUserLastLogon -UserName WayneArliss

 .Example
   # Get the Last Logon for a list of users
   Get-ADUserLastLogon -UserName WayneArliss, RobertRitchie
#>
function Get-ADUserLastLogon{
    [cmdletbinding()]
    param (
    [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [string[]]$UserName
    )
    
    if ($UserName -eq $null){
        Write-Host("No user name passed.")
    }else{
        foreach ($User in $UserName){
            Get-ADUser -Identity $User -Properties * |Select-Object Name, LastLogonDate, Enabled, LockedOut
        }    
    }
}

<# OLD METHOD
function Get-ADUserLastLogon{
param(
    [string]$UserName = $env:UserName
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
}#>

Function Get-Food{
    Write-Host ("Remember to eat")
}

Export-ModuleMember -Function Get-ADUserLastLogon, Get-Food