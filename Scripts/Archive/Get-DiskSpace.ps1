## Server Disk Space Check
# 
# 1. Get list of servers to be checked
#  1.1 get physical list
#  1.2 get list of VMs running Windows OS
#  1.3 remove servers from new domain (no credentials yet)
# 2. For each server in the list get a list of attached drives (only hard drives not optical)
# 3. Get the statistics required for each disk.
# 4. Output to a CSV in the same format as the current one.

# Physical servers - this could be picked up form a flat file or just added as below
[string[]]$PhysicalServers = 'citrix','seabackup'

# Virtual Servers - taken from vSphere
[string]$VMHostServer = 'seavc.seachill.co.uk'
[string[]]$VMOSGoodList = '2008', '2012','2016', '2019'
[string[]]$VirtualServers = ''

# All servers to be checked
[string[]]$ServerList

# Connect to the VMHost
Connect-VIServer -Server $VMHostServer
$VMs = Get-VM -Server $VMHostServer | Select-Object Name, PowerState, Guest

foreach ($VM in $VMs){
    #$VM.Name $VM.Guest.OSFullName
    if (($VM.Guest.OSFullName) -match $VMOSGoodList){
        Write-Host "$VM is a Windows Server"
    }else{
        #Write-Host "$VM is not Windows"
    }
}
