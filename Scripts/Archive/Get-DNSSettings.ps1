function Get-DNSSettings{
[cmdletbinding()]
param (
 [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [string[]]$ComputerName = $env:computername
)
 
begin {
# Logging: Open logging file & write starting timestamp
}
process {
    foreach ($Computer in $ComputerName) {
        if(Test-Connection -ComputerName $Computer -Count 1 -ea 0) {
            try { 
                # Logging: Getting network information for $Computer
                $Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Computer -EA Stop | ? {$_.IPEnabled} 
            } catch { 
                # Logging: Unable to connect to $Computer
                Write-Warning "Error occurred while querying $Computer."
                Continue 
            }
            # Logging: Getting Network informatin for $Computer
            foreach ($Network in $Networks) {
                $IPAddress  = $Network.IpAddress[0]
                $SubnetMask  = $Network.IPSubnet[0]
                $DefaultGateway = $Network.DefaultIPGateway
                $DNSServers  = $Network.DNSServerSearchOrder
                
                $DHCPLeaseObtained = $Network.DHCPLeaseObtained
                $DHCPLeaseExpires = $Network.DHCPLeaseExpires

                $IsDHCPEnabled = $false
                If($network.DHCPEnabled) {
                    $IsDHCPEnabled = $true
                }
                $MACAddress  = $Network.MACAddress
                # Logging: Creating output object containing the information.
                $OutputObj  = New-Object -Type PSObject
                $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer.ToUpper()
                $OutputObj | Add-Member -MemberType NoteProperty -Name IPAddress -Value $IPAddress
                $OutputObj | Add-Member -MemberType NoteProperty -Name SubnetMask -Value $SubnetMask
                $OutputObj | Add-Member -MemberType NoteProperty -Name Gateway -Value ($DefaultGateway -join ",")      
                $OutputObj | Add-Member -MemberType NoteProperty -Name IsDHCPEnabled -Value $IsDHCPEnabled
                $OutputObj | Add-Member -MemberType NoteProperty -Name DNSServers -Value ($DNSServers -join ",")     
                $OutputObj | Add-Member -MemberType NoteProperty -Name DHCPLeaseObtained -Value ($DHCPLeaseObtained -join ",")
                $OutputObj | Add-Member -MemberType NoteProperty -Name DHCPLeaseExpires -Value ($DHCPLeaseExpires -join ",")

                $OutputObj | Add-Member -MemberType NoteProperty -Name MACAddress -Value $MACAddress
                # Logging: outputting the network information of $Computer
                # Note: The next line just outputs the infomration to the screen, this will need to be changed to incorporate an export file.
                $OutputObj
            }
        }
    }
}
end {
# Logging: Write end time stamp and close logfile
}
}
$Servers = "seaacc", "seaadmin", "seadc2", "seaherb", "seadimaco", "seasysint", "seaacronis", "seadb2", "seadc3", "seaexch", "seaisys", "seanps1", "seaqpulse2", "seass1"
$Servers = $Servers + "seachtouch001", "192.168.45.83", "seachtouch003", "seachtouch004", "seachw035", "seachtouch006"
