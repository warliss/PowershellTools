# user account never expires - 
# disabled computer accounts - 
# inactive users accounts - last login more than 90 days
# inactive computer accounts - last connection more than 90 days
# inactive external account - last log in more than 12 months

## Get all AD Users into array/hash
# What to extract
#    SamAccountName (Logon Name)
#    LastLogonDate
#    DisplayName
#    Enabled
#    PasswordNeverExpires
#    EmailAddress


#$Me = Get-ADUser -Identity WayneArliss -Properties SamAccountName, LastLogonDate, DisplayName,Enabled, PasswordNeverExpires, EmailAddress

# Setting the base OU location in AD
$OUPath = 'OU=SEACHILL,DC=seachill,DC=com'
# Getting All users
$Users = Get-ADUser -Filter * -SearchBase $OUPath -Properties SamAccountName, LastLogonDate, DisplayName, Enabled, PasswordNeverExpires, EmailAddress
# Getting All Computers
$Computers = Get-ADComputer -Filter * -SearchBase $OUPath -Properties Name, LastLogonDate, OperatingSystem, WhenCreated, Enabled
# Setting the base output location
$OutputLocation = "h:\AD Scan\"
# Date today
$Today = [datetime]::Today
$CutOffDate = $Today.AddDays(-90)
$DisabledUserCount = 0
$UserNoLogonCount = 0
$DisabledCompCount = 0
$CompNoLogonCount = 0

# Users
Write-Host("Users: `n")
foreach ($User in $Users){
    if (($User.Enabled) -eq $false){
        #$User.Name
        $DisabledUserCount++
        $OutputObject = New-Object -TypeName psobject
        $OutputObject | Add-Member -MemberType NoteProperty -Name DateQueried -Value $Today
        $OutputObject | Add-Member -MemberType NoteProperty -Name UserName -Value ($User.Name)
        $OutputObject | Add-Member -MemberType NoteProperty -Name Enabled -Value ($User.Enabled)
        $OutputObject | Add-Member -MemberType NoteProperty -Name EmailAddress -Value ($User.EmailAddress)
        $OutputObject | Add-Member -MemberType NoteProperty -Name LastLogon -Value ($User.LastLogonDate)
        $OutputFile = $OutputLocation + "DisabledUsers.csv"
        $OutputObject | Export-Csv -Path $OutputFile -Append -NoTypeInformation
    }
        if (($User.LastLogonDate) -lt $CutOffDate){
        #$User.Name
        $UserNoLogonCount++
    }
    
}
Write-Host("$DisabledUserCount Disabled User Accounts")
Write-Host("$UserNoLogonCount User Accounts that have not been accessed in 90 days.`n")

# Computers
Write-Host("Computers: `n")
foreach ($Computer in $Computers){
    if (($Computer.Enabled) -eq $false){
        $DisabledCompCount++
        #$Computer.Name
    }
    if (($Computer.LastLogonDate) -lt $CutOffDate){
        #$Computer.Name
        $CompNoLogonCount++
    }
}
Write-Host("$DisabledCompCount Disabled Computer Accounts")
Write-Host("$CompNoLogonCount Computer Accounts that have not been accessed in 90 days.`n")
