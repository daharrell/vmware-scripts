#Script to pull the list of the vmTools status for all vm's on the defined vCenter Server.
#This script is assuming that it is be setup to run in Task Scheduler on a Schedule.
#Authored by Dan Harrell
#Updated on 6/18/2019

#vCenter Servers
$vc1 = "vcenterServerAddress"

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false

#Variables that need to be defined
$username = "Your Username"

#
$password = "C:\PathtoPassword.txt"
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, (Get-Content $password | ConvertTo-SecureString)

#SMTP Settings that need to be defined
$sendTo = "SendToEmailAddress"
$from = "SendFromEmailAddress"
$stmp = "SmtpServerAddress"

#Define the name of the server that this script is set to run from.
$server = "Server where script is running"


#Pull and send for vc1
Connect-VIServer $vc1 -credential $cred
$pathToExport = "c:\users\$env:USERNAME\desktop\" + $vc1 + "_vmTools_Status.csv"
#Get VMTOOLS Status and Export it to a CSV
Get-VM | Get-View | Select-Object @{N="VM Name";E={$_.Name}},@{Name="VMware Tools";E={$_.Guest.ToolsStatus}},@{Name="OS";E={$_.Guest.GuestFullName}},@{Name="PowerState";E={$_.Guest.GuestState}}| Export-Csv -path $PathToExport -NoTypeInformation -UseCulture

#Defined as the subject and body to build the email
$Subject =  "Status Report of VM Tools on $vc1"
$Body = "Attached is the list of VM's on $vc1 and their VM Tools status"

#Test file size - if less than 1kb then it will send an error message
if (Test-Path $pathToExport) {
    If ((Get-Item $pathToExport).length -gt 1kb) {
        Send-MailMessage -to $sendTo -from $from -Subject $subject -body $body -Attachments $pathToExport -SmtpServer $smtp 
        }
else {
    Send-MailMessage -to $from -from $from -Subject "EmailVMToolsStatus PowerShell Script is Broken" -body "EmailVMToolsStatus PowerShell Script is Broken on $server" -SmtpServer $smtp  
        }
    }
Disconnect-viserver * -confirm:$false

#Deletes the CSV to avoid space constraints
Remove-Item -path $pathToExport



exit
