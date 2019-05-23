add-pssnapin VMware.VimAutomation.Core

$user="VcenterUsername"
$pwd = Get-Content c:\pathtocredfile | ConvertTo-SecureString
$cred = New-Object System.Management.Automation.PsCredential $user, $pwd
#vcenter name or IP
$vcenter = "Name or IP of Vcenter"
#Path to export CSV
$PathToExport = "c:\users\$env:USERNAME\desktop\" + $vcenter + "_inventory_report.csv"

#Important Variables for sending the email address
$SMTPServer = "SMTPServerAddress"
$Username = "smtprelayemailaddress"
$to = "sendtoemailaddress"



connect-viserver -server $vcenter -credential $cred
Get-VM | Select Name,@{N="Datastore";E={[string]::Join(',',(Get-Datastore -Id $_.DatastoreIdList | Select -ExpandProperty Name))}},@{N="Host";E={$_.VMHost}},@{N="Operating system"; E={@($_.guest.OSfullname)}}, @{N="IP";E={@($_.Guest.IPAddress)}}, @{N="Power State";E={@($_.Powerstate)}} |Export-Csv -path $PathToExport -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false

#Building and sending of email with inventory exported and attached
$subject = $vcenter + " Inventory Report"
$body = "Attached is the Inventory Report for " +$vcenter
$file = $PathToExport
$attachment = new-object Net.Mail.Attachment($file)
$message = New-Object System.Net.Mail.MailMessage
$message.subject = $subject
$message.body = $body
$message.to.add($to)
$message.from = $username
$message.attachments.add($attachment)
$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer,25);
$smtp.send($message)
