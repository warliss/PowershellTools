<# 
 .Synopsis
  Checks & can update the Default Gateway on a list of computers

 .Description
  Checks & can update the Default Gateway on a list of computers & returns the following detials:-
    IP Address
    Default Gateway

 .Parameter Computers
  The list of computers (name or IP Address) to be checked/updated if set from the command line

 .Parameter ComputerList
  The list of computers (name or IP Address) to be checked/updated taken from a text file, each 
  computer is on a separate line

 .Parameter DefaultGateway
  When changing the Default Gateway it is specified here, there is a default of 192.168.45.252 which 
  is used if none is supplied

 .Parameter UseCredentials
  A switch to show the system Credential dialog (rather than adding it to the command line in plain text

 .Parameter UpdateGateway
  A switch that performs an update to the targets Default Gateway, if this is missed only a check is done.


 .Example
  

 .Example
   

#>

function Set-WADefaultGateway{
param(
    [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [string[]] $Computers = $env:COMPUTERNAME,
    [string] $DefaultGateway = "192.168.45.252",
    [string] $ComputerList,
    [switch] $UseCredentials,
    [switch] $UpdateGateway
    )

# Counter for how many computers require fixing
$cc = 0

# Get credentials to use, if -UseCredentials not specified then the current credentials will be used (Users account)
if($UseCredentials){
    Write-Verbose("Get Credentials")
    $WMI_Credential = Get-Credential
    }

# Read the contents of the file and add it to the $Computers array
if($ComputerList){
    Write-Verbose("Read the text file list of computers")
    $Computers = Get-Content $ComputerList
    }

# Process the list of computers
foreach($Computer in $Computers){
    if(Test-Connection -ComputerName $Computer -Quiet -Count 1){
        Write-Verbose("$Computer - Online")
        try {
            $nics = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Computer -Filter "IPEnabled=TRUE" -Credential $WMI_Credential -ErrorAction Stop
            foreach($nic in $nics){
                
                # fetch the right nic based on its IP address
                if($nic.ipaddress -match $Computer -And $nic.DefaultIPGateway  -ne $DefaultGateway) {
                    
                    # Check to see if Gateway should be changed
                    if($UpdateGateway){
                        $nic.SetGateways($DefaultGateway)
                    }else{
                        Write-Verbose("$Computer Change required: No change made")
                        }
                    $cc++
                    }
                }
            }
        catch {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Write-Verbose "Error: $Computer"
            Write-Verbose "Error: $FailedItem"
            Write-Verbose "$ErrorMessage"
            }
        }else{
            # Offline
            Write-Verbose("$Computer - Offline")
        }
    }
    Write-Verbose("Total number of computers changed: $cc")
}