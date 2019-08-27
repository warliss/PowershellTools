#region Test Elevation
function Test-Administrator
{
    $CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $CurrentUser).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
Write-Verbose "Testing to see if you are running this from an Elevated PowerShell Prompt."
if ((Test-Administrator) -ne $True -and ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name -ne 'NT AUTHORITY\SYSTEM')) {
    Throw "ERROR: You must run this from an Elevated PowerShell Prompt on each WSUS Server in your environment. If this is done through scheduled tasks, you must check the box `"Run with the highest privileges`""
}
else {
    Write-Verbose "Done. You are running this from an Elevated PowerShell Prompt"
}
#endregion Test Elevation