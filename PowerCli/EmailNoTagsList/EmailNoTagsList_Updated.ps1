#Script to create a list of VM's missing tags and email Platform@hf.org 
#Set to run weekly on bc0platops2p01
#Authored by Dan Harrell
#Created on 6/21/2019
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
    $subject =  "VMware Weekly Tag Report: $vc"
    $PathToExport = "c:\users\$env:USERNAME\desktop\" + $vc+ "_Snapshot_Report.csv"
    $tags =  Get-VM | ?{(Get-TagAssignment $_) -eq $null} 
    $tags | Select-Object Name, PowerState | export-csv -Path $pathToExport -NoTypeInformation -UseCulture
    $testPath = Test-Path $PathToExport
If ($testPath -eq $True) {
    if ($tags -ne $null){
            $csv = Import-Csv -Path $PathToExport | ConvertTo-Html -Fragment
            $body = "
            Attached is the list of VM's on $vc that have no tags. Please add tags if you are able to:
        
            $csv
            "
            Send-MailMessage -to $sendTo -from $from -Subject $subject -body ($body | Out-String)  -SmtpServer $smtp -BodyAsHtml
                        }
            else {
                $body = "There are currently no VM's on $vc missing tags."
                Send-MailMessage -to $sendTo -from $from -Subject $subject -body ($body | Out-String)  -SmtpServer $smtp -BodyAsHtml
                }
    Disconnect-viserver $vc -confirm:$false
    Remove-Item -path $pathToExport
}
else {
    Send-MailMessage -to $sendToErr -from $from -subject "NoTags PowerShell Script is Broken" -body "NoTags PowerShell Script is broken on $HostName"  -SmtpServer $smtp -BodyAsHtml
                }
    }
