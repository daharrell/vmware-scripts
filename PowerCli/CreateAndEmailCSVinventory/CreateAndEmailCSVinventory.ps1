add-pssnapin VMware.VimAutomation.Core
$pwd = Get-Content c:\pathtocredfile | ConvertTo-SecureString
$cred = New-Object System.Management.Automation.PsCredential “usernamehere“, $pwd
connect-viserver -server vcenterservernamehere -credential $cred
Get-VM | Select Name,@{N="Datastore";E={[string]::Join(',',(Get-Datastore -Id $_.DatastoreIdList | Select -ExpandProperty Name))}},@{N="Host";E={$_.VMHost}},@{N="Operating system"; E={@($_.guest.OSfullname)}}, @{N="IP";E={@($_.Guest.IPAddress)}}, @{N="Power State";E={@($_.Powerstate)}} |Export-Csv C:\Users\Dan_Harrell\vmware\inventory\172.19.3.4_inventory_report.csv -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
$file = "C:\pathtoinventory_report.csv"
$SMTPServer = "SMTPServerAddress"
$Username = "smtprelayemailaddress"
$to = "sendtoemailaddress"
$subject = "Put your subject here"
$body = "Put your body here"
$attachment = new-object Net.Mail.Attachment($file)
$message = New-Object System.Net.Mail.MailMessage
$message.subject = $subject
$message.body = $body
$message.to.add($to)
$message.from = $username
$message.attachments.add($attachment)
$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer,25);
$smtp.send($message)
