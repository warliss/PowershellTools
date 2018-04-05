##Get-Service -ComputerName xxxx -Name TeamViewer##
$ComputerList = 'seachw011', 'seachw010', 'seachearnie', 'seaisys'

foreach ($Computer in $ComputerList){
    if (Test-Connection -ComputerName $Computer -Count 1 -Quiet){
        $ServiceResult = Get-Service -ComputerName $Computer -Name TeamViewer
        $OutputObject = New-Object -TypeName psobject
        $OutputObject | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer
        $OutputObject | Add-Member -MemberType NoteProperty -Name ComputerStatus -Value "Online"
        $OutputObject | Add-Member -MemberType NoteProperty -Name ServiceName -Value $ServiceResult.Name
        $OutputObject | Add-Member -MemberType NoteProperty -Name DisplayName -Value $ServiceResult.DisplayName
        $OutputObject | Add-Member -MemberType NoteProperty -Name ServiceStatus -Value $ServiceResult.Status
        $OutputObject
    } else {
        $OutputObject = New-Object -TypeName psobject
        $OutputObject | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer
        $OutputObject | Add-Member -MemberType NoteProperty -Name ComputerStatus -Value "Offline"
        $OutputObject | Add-Member -MemberType NoteProperty -Name ServiceName -Value $null
        $OutputObject | Add-Member -MemberType NoteProperty -Name DisplayName -Value $null
        $OutputObject | Add-Member -MemberType NoteProperty -Name ServiceStatus -Value $null
        $OutputObject
        #Write-Host "$Computer - Not Running"
    }
}