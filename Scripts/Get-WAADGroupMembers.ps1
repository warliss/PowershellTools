$ADGroupDetails = Get-ADGroupMember "vpn_coated"
foreach ($Detail in $ADGroupDetails){
    $Detail | Export-Csv -Path "H:\VPNUsers_Coated.csv" -NoTypeInformation -Append
}