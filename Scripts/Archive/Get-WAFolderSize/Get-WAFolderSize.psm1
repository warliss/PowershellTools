<# 
 .Synopsis
  Display the total size of a folder.

 .Description
  Display the total size of a folder.

 .Parameter folderName
  Which folder you require the size of, this can be either in UNC (\\servername\path\to\folder) or local format (c:\path\to\folder)

 .Parameter folderListFile
  Path to a textfile or CSV with the required details in.

 .Example
  I'll add some examples later...

#>

function Get-WAFolderSize {
## Parameters
    param(
    [cmdletbinding()]
        [string] $folderName,
        [string] $folderListFile,
        [switch] $verbose
)
## check for Verbose output
    if($verbose){
        $oldVerbose = $VerbosePreference
        $VerbosePreference = "continue"
        Write-Verbose("Verbose enabled")
    }

## Other variables
    $CurrentDateTime = Get-Date 

## If both $folderName and $folderListFile are not present warn and exit the script
    if (!$folderName -and !$folderListFile){
        Write-Verbose("doing nothing...")
    }else{
        if ($folderName){
        $FolderSize = (Get-ChildItem -Path $folderName -Recurse | Measure-Object -Property Length -Sum -Minimum -Maximum -Average)
        Write-Verbose("Size = " + "{0:N2}" -f $FolderSize.Sum/1Gb + "Gb")
        }
    }
}

## Clean up
$VerbosePreference = $oldVerbose

Export-ModuleMember -Function Get-WAFolderSize
