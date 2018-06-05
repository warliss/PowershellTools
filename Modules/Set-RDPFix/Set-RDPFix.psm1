<# 
 .Synopsis
  Sets a registry key to enable RDP connections from Windows 7 PCs to Windows Server 2012 (and higher) via RDP

 .Description
  Sets a registry key to enable RDP connections from Windows 7 PCs to Windows Server 2012 (and higher) via RDP

 .Parameter ComputerName
  ComputerName - a string containing the host name of the Windows 7 PC

 .Example
  Set-RDPFix -ComputerName seachw034
  This checks for the existance of a specific key and if not present creates it.

#>

function Set-RDPFix{
param(
    [string]$ComputerName
    )

    if ($ComputerName -eq $null){
        Write-Host('ComputerName not specified')
        }else{
        $RegBaseLocation = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        $RegFinalLocation = $RegBaseLocation + "\CredSSP\Parameters"
        $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$ComputerName)
        $RegSubKey = $Reg.OpenSubKey($RegBaseLocation,$true)
        
        $RegSubKeys = $RegSubKey.GetSubKeyNames()
        if ($RegSubKeys.Contains('CredSSP')){
            #No update required
            Write-Host("Present")
        }else{
            # Registry key requires adding
            Write-Host("Not Present")
            
            #Create SubKeys
            $RegSubKey.CreateSubKey("CredSSP\Parameters")
            
            $SubKey = $RegSubKey.OpenSubKey($RegFinalLocation,$true)
            $ValueName = "AllowEncryptionOracle"
            $ValueData = 2
            $SubKey.SetValue($ValueName, $ValueData, [Microsoft.Win32.RegistryValueKind]::DWORD)
        }
    }
}
Export-ModuleMember -function Set-RDPFix