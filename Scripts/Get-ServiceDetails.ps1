[cmdletbinding()]
param (
    [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [string]$ComputerFileName,
    [string[]]$ComputerList = $env:COMPUTERNAME,
    [string]$ServiceName = 'TeamViewer',
    [string]$OutputFileName = "h:\temp.csv"
)

if ($ComputerFileName){
    if(Test-Path -Path $ComputerFileName){
        $ComputerList = Get-Content -Path $ComputerFileName
    }
}

foreach ($Computer in $ComputerList){
    ## Create the output object
    $OutputObject = New-Object -TypeName psobject

    # Add the computer name to the object
    $OutputObject | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer

    # Check the if the computer is online
    if (Test-Connection -ComputerName $Computer -Count 1 -Quiet){
        Write-Verbose ("$Computer is online")
        # Get the details of the service
        $ServiceResult = Get-Service -ComputerName $Computer -Name $ServiceName

        # Add the results to the output object
        $OutputObject | Add-Member -MemberType NoteProperty -Name ComputerStatus -Value "Online"
        $OutputObject | Add-Member -MemberType NoteProperty -Name ServiceName -Value $ServiceResult.Name
        $OutputObject | Add-Member -MemberType NoteProperty -Name DisplayName -Value $ServiceResult.DisplayName
        $OutputObject | Add-Member -MemberType NoteProperty -Name ServiceStatus -Value $ServiceResult.Status
    } else {
        Write-Verbose ("$Computer is offline")
        # Add the results to the output object
        $OutputObject | Add-Member -MemberType NoteProperty -Name ComputerStatus -Value "Offline"
        $OutputObject | Add-Member -MemberType NoteProperty -Name ServiceName -Value $null
        $OutputObject | Add-Member -MemberType NoteProperty -Name DisplayName -Value $null
        $OutputObject | Add-Member -MemberType NoteProperty -Name ServiceStatus -Value $null
    }
    ## Export to CSV at this point 
    $OutputObject | Export-Csv -Path $OutputFileName -Append -NoTypeInformation
    #Write-Verbose $OutputObject
}