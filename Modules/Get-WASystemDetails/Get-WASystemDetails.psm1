<# 
 .Synopsis
  Gets system details for provided hostname (or IP address)

 .Description
  Gets system details for provided hostname (or IP address) returns the following detials:-
    Computer name
    Operating System name
    Operating System Version
    Service pack level (major and minor)
    Current logged on user
    Bootime and
    Date windows was installed - for Windows 10 this is the date of the last major update

 .Parameter computerName
  Which computer to get the install date for.

 .Example
   # Get the system details for the local computer
   Get-WASystemDetails

 .Example
   # Get the system details for a remote computer
   Get-WASystemDetails -computerName seachw101

 .Example
   # Get the system details for multiple remote computers
   Get-WASystemDetails -computerName seachw101, seachw102

#>

function Get-WASystemDetails
{
[cmdletbinding()]
param (
    [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [string[]]$ComputerName = $env:computername
)
begin {}
process 
{
    foreach ($Computer in $ComputerName) 
        {
            if(Test-Connection -ComputerName $Computer -Count 1 -ea 0) 
            {
                Write-Verbose "$Computer is online"
                try
				{
					## OS Settings
                    $OS    = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer
                    $InstalledDate = $OS.ConvertToDateTime($OS.Installdate)
                    $LastBootTime = [Management.ManagementDateTimeConverter]::ToDateTime($OS.LastBootUpTime)

                    
                    ## Computer Systems Settings
                    $ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer

                    ## Build the output object
                    $OutputObj  = New-Object -Type PSObject
                    $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer
                    $OutputObj | Add-Member -MemberType NoteProperty -Name OperatingSystem -Value $OS.Caption
                    $OutputObj | Add-Member -MemberType NoteProperty -Name OSVersion -Value $OS.Version
                    $OutputObj | Add-Member -MemberType NoteProperty -Name ServicePack -Value $OS.ServicePackMajorVersion
                    $OutputObj | Add-Member -MemberType NoteProperty -Name ServicePackMinor -Value $OS.ServicePackMinorVersion
                    $OutputObj | Add-Member -MemberType NoteProperty -Name CurrentUser -Value $ComputerSystem.UserName
                    $OutputObj | Add-Member -MemberType NoteProperty -Name BootTime -Value $LastBootTime
					$OutputObj | Add-Member -MemberType NoteProperty -Name InstalledDate -Value $InstalledDate
					$OutputObj
				}
				catch
				{
					$ErrorMessage = $_.Exception.Message
					$FailedItem = $_.Exception.ItemName
					Write-Verbose "Error: $FailedItem"
					Write-Verbose "$ErrorMessage"
				}
			} 
			else
			{
                Write-Host "$Computer is Offline"
                Write-Verbose "$Computer is offline"
			}
		}	
	}
	end {}
}
Export-ModuleMember -Function Get-WASystemDetails