#Connects to vcenter and compiles a list of all vm's that have no tags and places as no_tag.csv on the users desktop
#and then sends it as an attachment to the smtp server that you defined
#Authored by Dan Harrell
#Created on 6/11/2019

#Define these variables
$vc = "vcenterServer"
$email = "Sendtoemail@toSendto.com
$emailFrom = "Email@From.com"
$smtpServer = "YourSmtpServer"

Connect-VIServer $vc
    $pathToExport = "c:\users\$env:USERNAME\desktop\" + $vc + "_no_tag.csv"
  Get-VM | ?{(Get-TagAssignment $_) -eq $null} | export-csv -Path $pathToExport -NoTypeInformation -UseCulture
    $Subject =  "The following VM's have no tags on $vc"
    $Body = "Attached is the list of VM's on $vc that have no tags"
  Send-MailMessage -to $email -from $emailFrom  -Subject $subject -body $body -Attachments $pathToExport -SmtpServer $smtpServer
Disconnect-viserver * -confirm:$false
