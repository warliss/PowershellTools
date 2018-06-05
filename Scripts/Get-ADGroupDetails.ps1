# OU=Shares,OU=Groups,OU=CHILLED,OU=SEACHILL,DC=seachill,DC=com
$OU = Get-ADOrganizationalUnit -Identity 'OU=Shares,OU=Groups,OU=CHILLED,OU=SEACHILL,DC=seachill,DC=com'

$Groups = Get-ADGroup -Filter * -SearchBase 'OU=Shares,OU=Groups,OU=CHILLED,OU=SEACHILL,DC=seachill,DC=com' | Sort-Object -Property Name

foreach ($Group in $Groups){
    # Get a members list/count
    $Members = Get-ADGroupMember -Identity $Group.Name

    # Build the output object
    $OutObj = New-Object -TypeName PSObject
    $OutObj | Add-Member -MemberType NoteProperty -Name GroupName -Value $Group.Name
    $OutObj | Add-Member -MemberType NoteProperty -Name ObjClass -Value $Group.ObjectClass
    $OutObj | Add-Member -MemberType NoteProperty -Name GroupCategory -Value $Group.GroupCategory
    $OutObj | Add-Member -MemberType NoteProperty -Name GroupScope -Value $Group.GroupScope
    $OutObj | Add-Member -MemberType NoteProperty -Name MemberCount -Value $Members.Count
    $OutObj
}