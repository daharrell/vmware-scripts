#Creates a list of VM's that have high disk utilization, the path that is running low on resources and the amount of space remaining.
#Authored by Dan Harrell
#Created on 6/24/2019

#vcenter name or IP
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
$smtp = "YourSmtpServer"

foreach ($vc in $viserver){
    Connect-VIServer $vc -credential $cred
    $PathToExportTxt = "c:\users\$env:USERNAME\desktop\" + $vc+ "_Low_Disk_Report.txt"
    $PathToExportCsv = "c:\users\$env:USERNAME\desktop\" + $vc+ "_Low_Disk_Report.CSV"
    $subject = "Disk Utilization Report: Disk Space Free: $vc"
    ForEach ($VM in Get-VM | where-object {($_.powerstate -ne "PoweredOff") -and ($_.Extensiondata.Guest.ToolsStatus -Match ".*Ok.*")}){
        ForEach ($Drive in $VM.Extensiondata.Guest.Disk) {
            $Path = $Drive.DiskPath
            #Calculations 
            $Freespace = [math]::Round($Drive.FreeSpace / 1MB)
            $Capacity = [math]::Round($Drive.Capacity/ 1MB)
            $SpaceOverview = "$Freespace" + "/" + "$capacity" 
            $PercentFree = [math]::Round(($FreeSpace)/ ($Capacity) * 100) 
            #VMs with less space
                if ($PercentFree -lt 20 -And $path -NE "T:\") {     
                  $VmName = $VM.Name 
                  $VMPath = $Path 
                  $VmFreeSpace = $Freespace
                  $VmPerFree = $PercentFree 
                    $Output = [PSCustomObject]@{
                    "VM Name" = $VmName 
                    "VM Path" = $VMPath 
                    "Disk Space Free" = $VmFreeSpace
                    "Percentage of Space Free" = $VmPerFree
                     } | Select-Object "VM Name", "VM Path", "Disk Space Free", "Percentage of Space Free"
                  $Output | export-csv -append -path $PathToExportTxt
                  }
             } 
        } 
Import-csv $PathToExportTxt | export-csv $PathToExportCsv
Remove-Item $PathToExportTxt
$testPath = Test-Path $PathToExportCsv
If ($testPath -eq $True) {
            $csv = Import-Csv -Path $PathToExportCsv | ConvertTo-Html -Fragment
            $body = "
            The following VM's have less than 20 percent free disk space as of $date :
        
            $csv
            "
            Send-MailMessage -to $sendTo -from $from -Subject $subject -body ($body | Out-String) -Attachments $PathToExportCsv -SmtpServer $smtp -BodyAsHtml
            }
Remove-Item $PathToExportCsv
}

 
