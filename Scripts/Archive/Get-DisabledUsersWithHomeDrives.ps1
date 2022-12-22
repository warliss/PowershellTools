# Get-DisabledUsersWithHomeDrives
$UserHomeBase = "\\SEACHFS1\Users\"
$UserList = Search-ADAccount -UsersOnly -AccountDisabled
foreach ($User in $UserList){
    $UserHome = $UserHomeBase + $User.SamAccountName
    #Write-Host $UserHome
    ## search to see if the user has a h: 
    $DisabledUser = Get-ADUser -Identity $User.SamAccountName -Properties Name, HomeDirectory, Created, whenChanged |Select-Object Name, HomeDirectory, Created, whenChanged
    $HomeDirectory = $DisabledUser.HomeDirectory
    $UserHomeSize = 0
    $HomeDireExists = $false
    if ($HomeDirectory -ne $null){
        if (Test-Path $HomeDirectory){
            $HomeDireExists = $true
            $UserHomePath = $HomeDirectory
            #$HomeDirectory
            $UserHomeSize = "{0}" -f ((Get-ChildItem $HomeDirectory -Recurse | Measure-Object -Property Length -Sum -ErrorAction Continue).Sum / 1MB)
            #$UserHomeSize

        }else{
            $UserHomePath = $HomeDirectory
            $UserHomeSize = 0
        }
    }else{
        $UserHomePath = "None"
        $UserHomeSize = 0
    }
    $OutputObj = New-Object -TypeName PSObject
    $OutputObj | Add-Member -MemberType NoteProperty -Name UserName -Value $DisabledUser.Name
    $OutputObj | Add-Member -MemberType NoteProperty -Name SAMAccountName -Value $User.SamAccountName
    $OutputObj | Add-Member -MemberType NoteProperty -Name UserAccountCreated -Value $DisabledUser.Created
    $OutputObj | Add-Member -MemberType NoteProperty -Name UserAccountModified -Value $DisabledUser.WhenChanged
    $OutputObj | Add-Member -MemberType NoteProperty -Name HomeDirectoryPath -Value $UserHomePath
    $OutputObj | Add-Member -MemberType NoteProperty -Name HomeDirectorySize -Value $UserHomeSize
    $OutputObj | Add-Member -MemberType NoteProperty -Name HomeDirectoryExists -Value $HomeDireExists
    $OutputObj | Export-Csv -Path H:\DisabledUserHomeDrive.csv -Append -NoTypeInformation
}