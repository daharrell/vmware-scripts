#Creates Inventory and emails it as an attachment for all Vcenters defined in $viserver
#Authored by Dan Harrell
#Updated 6/22/2019

#vCenter Servers
$vc1 = "SomeVcenterServer1"
$vc2 = "SomeVcenterServer2"
$vc3 = "SomeVcenterServer3"
$vc4 = "SomeVcenterServer4"
$vc5 = "SomeVcenterServer5"
$viserver = $vc1, $vc2, $vc3, $vc4, $vc5

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false

#Define your variables
$username = "YourUserName"
$password = "C:\Path\to\Password.txt"
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, (Get-Content $password | ConvertTo-SecureString)
$sendTo = "SendToEmailAddress"
$from = "SendFromEmailAddress"
$sendToErr= "SendToEmailAddressErrors"
$smtp = "YourSmtpServer"
$HostName = $Env:Computername


foreach ($vc in $viserver){
    Connect-VIServer $vc -credential $cred
    $PathToExport = "c:\users\$env:USERNAME\desktop\" + $vc+ "_inventory_report_name_ds_host.csv"
    get-vm | Select Name,@{N="Configured OS";E={$_.ExtensionData.Config.GuestFullname}},@{N="Running OS";E={$_.Guest.OsFullName}}, @{N="Powered On";E={ $_.PowerState -eq “PoweredOn”}}, @{N="Host";E={$_.VMHost}} | Export-Csv $PathToExport -NoTypeInformation -UseCulture
    $Subject =  "Inventory Report of VMs on $vc"
    $Body = "Attached is the list of VM's on $vc."
    $testPath = Test-Path $PathToExport
If ($testPath -eq $True) {
    Send-MailMessage -to $sendTo -from $from -Subject $subject -body $body -Attachments $pathToExport -SmtpServer $smtp
    }
else {
    Send-MailMessage -to $sendToErr -from $sendToErr -Subject "EmailPoweredOnInventory PowerShell Script is Broken" -body "EmailPoweredOnInventory PowerShell Script is broken on $HostName." -SmtpServer $smtp 
        }
Disconnect-viserver * -confirm:$false
}

