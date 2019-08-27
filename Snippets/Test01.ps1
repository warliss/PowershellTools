[CmdletBinding()]
Param(
    [parameter(Mandatory=$True)]
    [string]$MACAddress,
    [string]$FilePath
    )

[string]$output = ""

if(!$FilePath){
    Write-Host "No File path specified"
    } else {
        $files = Get-ChildItem $FilePath *.log
        foreach ($file in $files)
        {
            $result = Get-Content $file.FullName
            foreach ($line in $result)
            {
                Select-String $line -Pattern $MACAddress
                $output = $FilePath + " " + $line
                #Write-Host $output

            }            
        }
    }

