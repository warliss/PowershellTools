Function Get-FirewallStatus{
[cmdletbinding()]
param([string[]]$Computers = $env:COMPUTERNAME)
    foreach($Computer in $Computers){
        if (Test-Connection -ComputerName $Computer -BufferSize 16 -Count 1 -Quiet){
            $Session = New-PSSession -ComputerName $Computer
            $Firewall = Invoke-Command -Session $Session -ScriptBlock {Get-NetFirewallProfile -PolicyStore ActiveStore}
            foreach ($network in $Firewall){
                $CurrentNetwork = New-Object -TypeName PSObject
                $CurrentNetwork | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer
                $CurrentNetwork | Add-Member -MemberType NoteProperty -Name NetworkName -Value $network.Name
                $CurrentNetwork | Add-Member -MemberType NoteProperty -Name IsEnabled -Value $network.Enabled
                $CurrentNetwork
            }
        } else {
            $CurrentNetwork = New-Object -TypeName PSObject
            $CurrentNetwork | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer
            $CurrentNetwork | Add-Member -MemberType NoteProperty -Name NetworkName -Value "Offline"
            $CurrentNetwork | Add-Member -MemberType NoteProperty -Name IsEnabled -Value ""
            $CurrentNetwork
        }
    }
}
