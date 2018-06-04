function Set-RDPFix2{
param(
    [string]$ComputerName
    )

    if ($ComputerName -eq $null){
        Write-Host('ComputerName not specified')
    }else{
    $RegBaseLocation = "SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $RegFinalLocation = $RegBaseLocation + "\CredSSP\Parameters\"
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
        
        $SubKey = $BaseKey.OpenSubKey($RegFinalLocation,$true)
        $ValueName = "AllowEncryptionOracle"
        $ValueData = 2
        $SubKey.SetValue($ValueName, $ValueData, [Microsoft.Win32.RegistryValueKind]::DWORD)
    }
}
}
#Export-ModuleMember -function Set-RDPFix