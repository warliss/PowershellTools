# Output location and filename - This needs to be changed to a parameter that will be passed from the command line
$OutputLocation = 'H:\'
$OutputFile = $OutputLocation + "UserDetails.csv"

# Name, SamAccountName, Enabled, PasswordLastSet, PasswordNeverExpires, Department, Office, LastLogonDate, CanonicalName

$UserDetails = Get-ADUser -Filter * -Properties *

foreach($User in $UserDetails){
$OutputObject = New-Object -TypeName psobject

$OutputObject | Add-Member -MemberType NoteProperty -Name Name -Value ($User.Name)
$OutputObject | Add-Member -MemberType NoteProperty -Name SAMAccountName -Value ($User.SamAccountName)
$OutputObject | Add-Member -MemberType NoteProperty -Name EmailAddress -Value ($User.EmailAddress)
$OutputObject | Add-Member -MemberType NoteProperty -Name Enabled -Value ($User.Enabled)
$OutputObject | Add-Member -MemberType NoteProperty -Name PasswordExpired -Value ($User.PasswordExpired)
$OutputObject | Add-Member -MemberType NoteProperty -Name PasswordLastSet -Value ($User.PasswordLastSet)
$OutputObject | Add-Member -MemberType NoteProperty -Name PasswordNeverExpires -Value ($User.PasswordNeverExpires)
$OutputObject | Add-Member -MemberType NoteProperty -Name PasswordNotRequired -Value ($User.PasswordNotRequired)
$OutputObject | Add-Member -MemberType NoteProperty -Name CannotChangePassword -Value ($User.CannotChangePassword)
$OutputObject | Add-Member -MemberType NoteProperty -Name Created -Value ($User.Created)
$OutputObject | Add-Member -MemberType NoteProperty -Name whenChanged -Value ($User.whenChanged)
$OutputObject | Add-Member -MemberType NoteProperty -Name LastLogon -Value ($User.LastLogonDate)
$OutputObject | Add-Member -MemberType NoteProperty -Name Department -Value ($User.Department)
$OutputObject | Add-Member -MemberType NoteProperty -Name JobTitle -Value ($User.Title)
$OutputObject | Add-Member -MemberType NoteProperty -Name Office -Value ($User.Office)
$OutputObject | Add-Member -MemberType NoteProperty -Name CanonicalName -Value ($User.CanonicalName)

$OutputObject | Export-Csv -Path $OutputFile -Append -NoTypeInformation 

#| Select-object Name, EmailAddress, JobTitle , Department, Office | Format-Table -AutoSize 

#| Export-Csv -Path $OutputFile -Append -NoTypeInformation 
}