﻿function Get-WAInstalldate
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
					$OS    = Get-WmiObject -Class Win32_OperatingSystem -Computer $Computer
					$InstalledDate = $OS.ConvertToDateTime($OS.Installdate)
					$OutputObj  = New-Object -Type PSObject		
					$OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer
					$OutputObj | Add-Member -MemberType NoteProperty -Name InstalledDate -Value $InstalledDate
					$OutputObj
				}
				catch
				{
					$ErrorMessage = $_.Exception.Message
					$FailedItem = $_.Exception.ItemName
					Write
					Write-Verbose "Error: $FailedItem"
					Write-Verbose "$ErrorMessage"
				}
			} 
			else
			{
				Write-Verbose "$Computer is offline"
			}
		}	
	}
	end {}
}
Export-ModuleMember -Function Get-WAInstalldate