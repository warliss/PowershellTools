# Get Session
$office365Credential = Get-Credential
$global:office365= New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $office365Credential  -Authentication Basic   –AllowRedirection
Import-PSSession $office365

# Get mailboxes
$Mailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited |Select Identity,Alias,DisplayName |sort DisplayName
$AccessRights = $Mailboxes | foreach{Get-MailboxPermission -Identity $_.Alias}