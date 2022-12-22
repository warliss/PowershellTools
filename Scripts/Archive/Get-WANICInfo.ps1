function Get-WANICInfo {
    param(
    [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [string[]] $Computers = $env:COMPUTERNAME,
    [string] $ComputerList,
    [switch] $UseCredentials
    )

    if($UseCredentials){
        $WMI_Credential = Get-Credential
    }

    if($ComputerList){
        # take the contents of the file and add it to the $Computers array
        $Computers = Get-Content $ComputerList
    }

    foreach ($Computer in $Computers){
        ## Create the output object ##
        $OutputObj = New-Object -TypeName psobject
    
        ## Test if the computer is up ##
        if(Test-Connection -ComputerName $Computer -Quiet -Count 1){
        try{
            Write-Verbose("Online")
            if($UseCredentials){
                Write-Verbose("Getting credentials")
                $nwInfo = Get-WmiObject -ComputerName $Computer -Class Win32_NetworkAdapterConfiguration -Credential $WMI_Credential | Where-Object { $_.IPAddress -ne $null }
            }else{
                Write-Verbose("Using current credentials")
                $nwInfo = Get-WmiObject -ComputerName $Computer -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null }
            }
            $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer
            $OutputObj | Add-Member -MemberType NoteProperty -Name Description -Value $nwInfo.Description
            $OutputObj | Add-Member -MemberType NoteProperty -Name IPAddress -Value $nwInfo.IPAddress[0]
            $OutputObj | Add-Member -MemberType NoteProperty -Name DefaultIPGateway -Value $nwInfo.DefaultIPGateway[0]
            }
        catch {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Write-Verbose "Error: $FailedItem"
            Write-Verbose "$ErrorMessage"
            }
        }else{
            Write-Verbose("Offline")
            $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer
            $OutputObj | Add-Member -MemberType NoteProperty -Name Description -Value "Offline"
            $OutputObj | Add-Member -MemberType NoteProperty -Name IPAddress -Value ""
            $OutputObj | Add-Member -MemberType NoteProperty -Name DefaultIPGateway -Value ""
        }
        $OutputObj | Export-Csv -Path "H:\DefaultGateWay.csv" -NoClobber -NoTypeInformation -Append -Force
    }
    
}