## Parameters
# $SearchBase - this is the location in AD that the search is done on in the format "OU=ouname,DC=dcname,DC=com"
# $OutputFile - the file path for the results of the query/script in CSV format. this defaults to 'C:\Output.csv'

[cmdletbinding()]
param (
    [string]$SearchBase,
    [string]$OutputFile = 'c:\Output.csv'
)

#$OutputFile = 'h:\ADUserLastLogin_Coated.csv'
#$SearchBase = "OU=Users,OU=CHILLED,OU=SEACHILL,DC=seachill,DC=com"

#Get-ADUser -Filter * -SearchBase "OU=Users,OU=CHILLED,OU=SEACHILL,DC=seachill,DC=com" -ResultPageSize 0 -Prop CN,samaccountname,lastLogonTimestamp,UserPrincipalName,Enabled | 
#    Select CN,samaccountname,@{n="lastLogonDate";e={[datetime]::FromFileTime($_.lastLogonTimestamp)}},UserPrincipalName,Enabled |
#    Export-CSV -NoType -Path $OutputFile

$Results = Get-ADUser -Filter * -SearchBase $SearchBase
$Results.CN
foreach ($obj in $Results){
    [string]$LastLoggedTime = $obj.lastLogonTimestamp
    $OutputObject = New-Object -TypeName PSObject
    #$OutputObject | Add-Member -MemberType CN -Name ComputerName -Value $obj.CN
    $OutputObject | Add-Member -MemberType NoteProperty -Name SamAccountName -Value $obj.samaccountname
    $OutputObject | Add-Member -MemberType NoteProperty -Name LastLogonDate -Value {[datetime]::FromFileTime($LastLoggedTime)} # This might not work
    $OutputObject | Add-Member -MemberType NoteProperty -Name UserPrincipalName -Value $obj.UserPrincipalName
    $OutputObject | Add-Member -MemberType NoteProperty -Name Enabled -Value $obj.Enabled
    $OutputObject | Sort-Object -Property Surname | Export-Csv -Path $OutputFile -NoTypeInformation -Append
}
