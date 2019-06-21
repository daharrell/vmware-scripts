#Script to create a list of snapshots older than 7 days, remove them, and email Platform@hf.org 
#Some minor error checking is set, which checks to make sure inventory is pulled and exported and email Daniel.Harrell@HF.org if the necessary files are not deleted.
#Authored by Dan Harrell
#Created on 6/21/2019


#vCenter Servers
$vc1 = "SomeVcenterName1"
$vc2 = "SomeVcenterName2"
$vc3 = "SomeVcenterName3"
$vc4 = "SomeVcenterName4"
$vc5 = "SomeVcenterName5"
$viserver = $vc1, $vc2, $vc3, $vc4, $vc5

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false

$username = "Username"
$password = "C:\Path\To\Password.txt"
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, (Get-Content $password | ConvertTo-SecureString)
$sendTo = "EmailToSendTo"
$from = "EmailToSendFrom"
$sendToErr= "EmailToSendToErrorsTo"
$smtp = "SomeSmtpServer"

#n = number of days to check for old snapshots
$n = -7
$days = [math]::abs($n)

foreach ($vc in $viserver){
    Connect-VIServer $vc -credential $cred
    $subject = "VMware Weekly Snapshot Removal Report for $vc"
    $PathToExport = "c:\users\$env:USERNAME\desktop\" + $vc+ "_Snapshot_Report.csv"
    $snapList = Get-Snapshot -vm * | ? {$_.Created -lt (Get-Date).AddDays($n)} 
    $snapOutput = $snapList | Select-Object VM, Name, Description, Created 
    $snapOutput | Export-Csv -path $PathToExport -NoTypeInformation -UseCulture
    $testPath = Test-Path $PathToExport
If ($testPath -eq $True) {
    if ($snapList -ne $null){
            $csv = Import-Csv -Path $PathToExport | ConvertTo-Html -Fragment
            $body = "
            The following list of Snapshots were removed due to being older than $days :
        
            $csv
            "
            Send-MailMessage -to $sendTo -from $from -Subject $subject -body ($body | Out-String)  -SmtpServer $smtp -BodyAsHtml
            $snaplist | Remove-Snapshot  -RemoveChildren -Confirm:$False
            }
            else {
                $body = "There are currently no snapshots on $vc to be removed at this time"
                Send-MailMessage -to $sendTo -from $from -Subject $subject -body ($body | Out-String)  -SmtpServer $smtp -BodyAsHtml
                }
    Disconnect-viserver $vc -confirm:$false
    Remove-Item -path $pathToExport
}
else {
    Send-MailMessage -to $sendToErr -from $from -subject "SnapShot Removal PowerShell Script is Broken" -body "SnapShot Removal PowerShell Script is Broken"  -SmtpServer $smtp -BodyAsHtml
                }
    }







