#####
##  Emails warning for toners that are below 25% remaining for the copiers over both sites.
#####
## Version 1.0
## Author Wayne Arliss - WayneArliss@seachill.com

# set up list of copiers to check
$printers = "seachpit1","seachpsal1","seachpfac1","seachpnpd1","seachpnpd2","seachpqa1","seachpcom1","seachpeng1"
$printers += "seacopcol2","seacopeng1","seacopfac1","seacopfin1","seacophr1","seacoppla1","seacopsal1","seacoptec1","seacoptec2"

$TonerStatus = @()

# email settings 
$Sender = "Print Server <seachprint1@seachill.com>"
$Recipient = "ITAlerts@seachill.com"
$Subject = "Copier Warning"
$EmailBody = ""
$SendEmail = 0

foreach ($printer in $printers){
    $SNMP = New-Object -ComObject olePrn.OleSNMP
    $SNMP.open($printer,"public",2,3000)
    # OID for printer status
    $raw = $SNMP.gettree("43.11.1.1")
        
    # Break the single string into multipule strings for easier processing
    $split = $raw -split [environment]::NewLine
    
    # Due to all the descriptions appearing first, the associated values are offset 1/2 the total list from their respective descritpion
    $offset = $split.Count / 2
    
    # Magic Value of 8, there are 8 description values, so this gives us the total number of items we are working with
    $lines = $offset / 8
    
    for ($i = 0; $i -lt $lines; $i++){
        <#
        Offset of values
        (0)  MarkerSuppliesMarkerIndex.1.1
        (1)  MarkerSuppliesColorantIndex.1.1
        (2)  MarkerSuppliesClass.1.1
        (3)  MarkerSuppliesType.1.1
        (4)  MarkerSuppliesDescription.1.1
        (5)  MarkerSuppliesSupplyUnit.1.1
        (6)  MarkerSuppliesMaxCapacity.1.1
        (7)  MarkerSuppliesLevel.1.1
        #>
        $description = $split[$offset + $i + ($lines * 4)]
        $maxCapacity = $split[$offset + $i + ($lines * 6)]
        $level = $split[$offset + $i + ($lines * 7)]
        $Remain = [int](100 - $level)
        
        if($description.Contains("Cartridge")){
            $obj = [pscustomobject]@{
                "PrinterDescription" = $printer;
                "Description" = $description;
                "MaxCapacity" = [int]$maxCapacity;
                "Level" = [int]$level;
                "Remaining" = $Remain
            }
            $TonerStatus += $obj
            if($level -gt 74){
                $SendEmail = 1
                $EmailBody += "$printer $description is low ($remain %)`r`n"
            }
        }
    }
    $EmailBody += "`r`n"
}

# Last bit - send the email if there are notifications
if ($SendEmail -eq 1){
    Send-MailMessage -From $Sender -To $Recipient -Subject $Subject -SmtpServer "SMTPRELAY" -Body $EmailBody
}