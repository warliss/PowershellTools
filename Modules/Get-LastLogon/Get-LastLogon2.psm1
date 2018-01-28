#Import-Module ActiveDirectory

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
    Write-Host $username "last logged on at:" $dt
}

Get-ADUserLastLogon -UserName TimKnight