﻿## 
# ADTasks - A collection of quick scripts put into one place and accessible from a rudimentary menu.
# 
# 1 - Get-LockedADAccounts - this list any AD account in the domain that has been locked out (usually
#     due to incorrect password put in too many times.
# 2 - Update-ADPassword - this resets a users password
# 3 - Create a new AD User
# 4 - Disable an AD User
# 5 - Display AD User details
# 6 - Display hostname of last computer added to AD (one for each site)
# 7 - Look up user by SID
# 
# This harks back to a simpler time, no GUI required here I think.
##
#
# To do:
# 1. Add logging, so we know who changed what & when
# 2. Add new user - need to know exactly what the requirements will be
#      What fields are essential etc...
# 3. Automated locked user check - if there is a parameter passed from the command line then only perform 
#      option 1 and do not offer to unlock the accounts.
##
[cmdletbinding()]
    param(
    [switch]$AutomatedCheck
    )
## Functions

function Logging{
## Logging
    $loggingActive = $false
    $LogFileLocation = "c:\ADLog"
    $LogFile = $LogFileLocation + "\ADLog.txt"

# Check if file exists
    if (Test-Path $LogFile){
        # Whst to do here?
    } else {
        # Log file doesn't exist, create it
        New-Item -Path $LogFile -Force -ErrorAction Stop # This will also create the folder structure too
        $FirstLine = "Date`tTime`tMessage"
        $FirstLine | Out-File -FilePath $LogFile
    }
    $loggingActive = $true
}

function Invoke-Menu{
     Clear-Host
     Write-Host "============= AD Accounts =============`r`n"
     Write-Host "  1: List all locked AD Accounts`r`n"
     Write-Host "  2: Reset a Users AD Account Password`r`n"
     Write-Host "  3: Create a new AD user`r`n"
     Write-Host "  4: Disable an AD user`r`n"
     Write-Host "  5: Show details of an AD user`r`n"
     Write-Host "  6: Show name of Last AD Computer Added`r`n"
     Write-Host "  7: Get User ID from SID`r`n"
     Write-Host "  Q: Quit.`r`n"
}

function Are-YouSure{
    [cmdletbinding()]
    param(
    [string]$Question = "Are you sure?"
    )
    $Response = Read-Host $Question
    if ($Response -eq "y"){
        return $true
    }else{
        return $false
    }
}

function Output-ToFile{
    [CmdletBinding()]
    param([string]$OutputMessage = "Unknown - Check the code...")
    $DateTimeStamp = Get-Date -Format "dd/MM/yyyy`tHH:mm:ss`t"
    $Output = $DateTimeStamp + $OutputMessage
    $Output | Out-File -FilePath $LogFile -Append 
}

# Option 1 - Get all locked AD User Accounts
function Get-LockedADAccounts{
    Clear-Host
    Write-Host "======== Getting Locked Accounts ========`r`n"
    Write-Host "Working....`r`n"
    ## List all users that have their AD Account locked
    $SearchBase = "OU=SEACHILL,DC=seachill,DC=com"
    $LockedAccounts = Search-ADAccount -LockedOut -SearchBase $SearchBase
    $Count = (($LockedAccounts).Name).Count
    if ($Count -gt 0){
        foreach($Account in $LockedAccounts){
            Write-Host($Account.Name + ": Locked")
            $Unlock = Read-Host -Prompt "Unlock Account?"
            if ($Unlock -eq "Y" -or $Unlock -eq "y"){
                Unlock-ADAccount -Identity $Account.SamAccountName
                Write-Host "Unlocked`r`n"
                if ($loggingActive){
                    $LogMessage = $Account + " is unlocked."
                    Output-ToFile -OutputMessage $LogMessage
                }
            } else {
                Write-Host "Still Locked`r`n"
                if ($loggingActive){
                    $LogMessage = $Account + " is still locked."
                    Output-ToFile -OutputMessage $LogMessage
                }
            }
        }
    } else {
        Write-host "There are $Count locked AD accounts.`r`n"
        if ($loggingActive){
            $LogMessage = "There are $Count locked AD accounts."
            Output-ToFile -OutputMessage $LogMessage
        }
    }
}

# Option 2 - Reset a specific users account password
function Update-ADPassword{
    Clear-Host
    Write-Host "========== Resetting Passwords ==========`r`n"
    Write-Host "Enter q to quit`r`n"
    $UserNameValid = $false
    do {
        $ResetUser = Read-Host "Login name for user account"
        if ($ResetUser -eq $null -or $ResetUser -eq "" ){
            Write-Host "Please enter a username"
        } else {
            $UserNameValid = $true
            if ($ResetUser -eq "q"){
                Write-Host "Exiting..."
            }else{
                # Reset the Users Password
                $NewPassword = (Read-Host -Prompt "New Password" -AsSecureString)
                Write-Host "Resetting Password"
                Set-ADAccountPassword -Identity $ResetUser -Reset -NewPassword $NewPassword
                if ($loggingActive){
                    $LogMessage = $ResetUser + " password changed."
                    Output-ToFile -OutputMessage $LogMessage
                }
            }
        }
    } until ($ResetUser -eq "q" -or $UserNameValid)
}

# Option 3 - Create a new user from entered details
function Create-NewADUser {
    Clear-Host
    Write-Host "=========== New User Account ============`r`n"
    Write-Host "`r`nNot implemented yet`r`n"

    ## What information will be needed?
    #  1. First Name
    #  2. Last Name
    #  3. Email address - could suggest based on the first two options
    #  4. Login name - Again a suggestion from the given details
    #  5. Location - This should be a selection - 1 for ER2, 2 for LFR, 3 for Russells - 
    #        this detail is then used for the address in AD and the end OU that the object sits in
    #  6. Telephone numbers - both mobile and desk
    #  7. Job Title
    #  8. Team - Which base group will the user belong to
}

# Option 4 - Disable a user
function Disable-ADUser{
    Clear-Host 
    Write-Host "============ Disable AD User ============`r`n"
    Write-Host "Enter q to quit`r`n"
    $UserNameValid = $false
    do{
        # 1. get username
        $UserToDisable = Read-Host "Login name for user to disable"

        # 2. check if username is valid & not disabled

        try {
            $ADUserAccount = Get-ADUser $UserToDisable -ErrorAction Stop
            # Do stuff if found
            if (($ADUserAccount).Enabled){
                Write-Host "User account meets 2 checks... Disable account from here"
                $UserNameValid = $true
            } else {
                Write-Host "User account already disabled."
                $UserNameValid = $true
            }
        } 
        catch 
            [System.Management.Automation.ParameterBindingException],
            [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            # Do stuff if not found
            Write-Host "User account unknown - Check the spelling & try again"
        } 
        catch {
            # A different type of error...

            Write-Host "Broken in a different way!!"
            foreach ($Err in $Error){
                $Err.Exception.GetType().FullName
            }
        }
        # 3. disable the account if BOTH answers for #2 are true
    }until ($UserToDisable -eq "q" -or $UserNameValid)
}

# Option 5 - List User Details
function Get-UserDetails{
    Clear-Host
    Write-Host "======== User AD Account Details ========`r`n"
    Write-Host "Enter q to quit`r`n"
    $UserNameValid = $false
    do {
        $SearchUser = Read-Host "Login name for user account"
        if ($SearchUser -eq $null -or $SearchUser -eq "" ){
            Write-Host "Please enter a username"
        } else {
            $UserNameValid = $true ## Need better username checking here.
            if ($SearchUser -eq "q"){
                Write-Host "Exiting..."
            }else{
                try{
                    $UserDetails = Get-ADUser -Identity $SearchUser -Properties * -ErrorAction Stop
                    $HomeDirSize = 0
                    if(($UserDetails.HomeDirectory) -ne $null){
                        $HomeDirSize = [math]::Round(((Get-ChildItem -Path $UserDetails.HomeDirectory -Recurse | Measure-Object -Property Length -Sum).Sum /1Mb),2)
                    }
                    $User = New-Object -TypeName psobject
                        $User | Add-Member -MemberType NoteProperty -Name DisplayName -Value $UserDetails.DisplayName
                        $User | Add-Member -MemberType NoteProperty -Name EmailAddress -Value $UserDetails.EmailAddress
                        $User | Add-Member -MemberType NoteProperty -Name Enabled -Value $UserDetails.Enabled
                        $User | Add-Member -MemberType NoteProperty -Name Lockedout -Value $UserDetails.LockedOut
                        $User | Add-Member -MemberType NoteProperty -Name HomeDirectory -Value $UserDetails.HomeDirectory
                        $User | Add-Member -MemberType NoteProperty -Name HomeDirSize -Value $HomeDirSize
                        $User | Add-Member -MemberType NoteProperty -Name LastLogonDate -Value $UserDetails.LastLogonDate
                        $User | Add-Member -MemberType NoteProperty -Name LastBadPasswordAttempt -Value $UserDetails.LastBadPasswordAttempt
                        $User | Add-Member -MemberType NoteProperty -Name WhenCreated -Value $UserDetails.whenCreated
                        $User | Add-Member -MemberType NoteProperty -Name WhenChanged -Value $UserDetails.whenChanged
                        $User | Add-Member -MemberType NoteProperty -Name SID -Value $UserDetails.SID.Value
                        # Display phone numbers
                    $User
                }catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
                    ## error
                    Write-Host "User Not Found"
                }catch {
                    ## error
                    Write-Host "Another Error:"
                    Write-Host $_.Exception
                    Write-Verbose $_.ErrorDetails
                }
            }
                if ($loggingActive){
                    $LogMessage = "User Details returned for " + ($User.DisplayName)
                    Output-ToFile -OutputMessage $LogMessage
                }

            }
    } until ($ResetUser -eq "q" -or $UserNameValid)

}

# Option 6 - Get last computer name
function Get-LastComputerName($filter){
    $ComputerList = Get-ADComputer -Filter $Filter -Properties Name, DNSHostName, IPV4Address, whenCreated
    $ComputerList | Sort-Object Name | Select-Object -Last 1
    }

function LastComputer{
    Clear-Host 
    Write-Host "============ Excuse'o'matic =============`r`n"

}

# Option 7 - Get user name from SID

function Get-UserFromSID{
    Clear-Host
    Write-Host "========= User Details From SID =========`r`n"
    Write-Host "Enter q to quit`r`n"
    $UserNameValid = $false
        do {
        $SearchSID = Read-Host "Enter SID"
        if ($SearchSID -eq $null -or $SearchSID -eq "" ){
            Write-Host "Please enter a SID"
        } else {
            $UserNameValid = $true ## Need better username checking here.
            if ($SearchSID -eq "q"){
                Write-Host "Exiting..."
            }else{
                try{
                    $objSID =New-Object System.Security.Principal.SecurityIdentifier($SearchSID)
                    $objUser = $objSID.Translate([System.Security.Principal.NTAccount])
                    $UserDetails = Get-ADUser -Identity (($ObjUser.Value).Substring(9,$ObjUser.Value.Length - 9)) -Properties *
                    $User = New-Object -TypeName psobject
                        $User | Add-Member -MemberType NoteProperty -Name DisplayName -Value $UserDetails.DisplayName
                        $User | Add-Member -MemberType NoteProperty -Name EmailAddress -Value $UserDetails.EmailAddress
                        $User | Add-Member -MemberType NoteProperty -Name Enabled -Value $UserDetails.Enabled
                        $User | Add-Member -MemberType NoteProperty -Name Lockedout -Value $UserDetails.LockedOut
                        $User | Add-Member -MemberType NoteProperty -Name HomeDirectory -Value $UserDetails.HomeDirectory
                        $User | Add-Member -MemberType NoteProperty -Name LastLogonDate -Value $UserDetails.LastLogonDate
                        $User | Add-Member -MemberType NoteProperty -Name LastBadPasswordAttempt -Value $UserDetails.LastBadPasswordAttempt
                        $User | Add-Member -MemberType NoteProperty -Name WhenCreated -Value $UserDetails.whenCreated
                        $User | Add-Member -MemberType NoteProperty -Name WhenChanged -Value $UserDetails.whenChanged
                        $User | Add-Member -MemberType NoteProperty -Name SID -Value $UserDetails.SID.Value
                    $User
                } 
                catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{
                    Write-Host "SID Not Found"            
                }
                catch [System.Management.Automation.MethodInvocationException]{
                    Write-Host "SID not in correct format - it should be S-1-5-21-xxxxxxxxx-xxxxxxxxx-xxxxxxxxx-xxx"
                }
                catch{
                    # What Errors?
                    $_.Exception.GetType().FullName
                    #Write-Host $PSItem.Exception
                }
            }
            if ($loggingActive){
                $LogMessage = "User Details returned for " + ($User.DisplayName)
                Output-ToFile -OutputMessage $LogMessage
            }
        }
    } until ($ResetUser -eq "q" -or $UserNameValid)
}

# Option BOFH - Get an excuse - just a bit of fun, do not use in a live environment
function Excuse{
    Clear-Host 
    Write-Host "============ Excuse'o'matic =============`r`n"
    if (Get-Module -ListAvailable -Name Get-Excuse){
        Get-Excuse
        Write-Host ""
    }else{
        Write-Host "Error: No Module!!`r`n"
    }
}

## Main Loop
do{
    # Start the logging process
    Logging
    if ($AutomatedCheck){
        # Only run option 1
    } else {
        Invoke-Menu
        $input = Read-Host "Make a selection"
        switch($input)
        {
            '1'{ Get-LockedADAccounts }
            '2'{ Update-ADPassword }
            '3'{ Create-NewADUser }
            '4'{ Disable-ADUser}
            '5'{ Get-UserDetails}
            '6'{ LastComputer}
            '7'{ Get-UserFromSID}
            'BOFH'{ Excuse }
            'q'{ return }
        }
        pause
    }
} until ($input -eq 'q')
