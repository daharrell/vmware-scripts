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
#User Configuration Settings
$username = "YourUserName"
$password = "C:\Path\to\Password.txt"
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, (Get-Content $password | ConvertTo-SecureString)
#Email Configuration Settings
$sendTo = "EmailToSendTo"
$from = "EmailToSendFrom"
$sendToErr= "EmailToSendToErrorsTo"
$smtp = "SomeSmtpServer"

$HostName = $Env:Computername
#Date Calculation Settings
$date = date
#n = number of days
$n = -7
$days = [math]::abs($n)

#WorkDirectory Configuration
$workDirectory= "C:\Temp\SnapShotCleanup\"
$TestPath = Test-Path -Path $workDirectory
If($TestPath -eq $false){
    New-Item -Path "c:\Temp\" -Name "SnapShotCleanup" -ItemType "directory"}

#Loop to pull the list of Snapshots older than 7 Days and transform that into two lists of VM names bases on tag assignments for each vCenter Server
foreach ($vcenter in $viserver){

Connect-VIServer $vcenter -credential $cred
        
    $ResultsPath = $workDirectory + $vcenter+"_Unprocessed_Results.CSV"
    $SortedPathDelete = $workDirectory+ $vcenter+"_Snapshot_Removable.csv"
    $SortedPathExclude = $workDirectory+ $vcenter+"_Snapshot_Exclude.csv"
               
     
    #Gets base snapshot list older than $N days
    $snaplist = $null
    $snapOutput = $null

    $snapList = Get-Snapshot -vm * | ? {$_.Created -lt (Get-Date).AddDays($n)} 
    $snapoutput = $snapList | Select-Object VM
    $snapoutput | export-csv -Path $ResultsPath  -NoTypeInformation -UseCulture
    $SortedSnap = Import-Csv -Path $ResultsPath | sort VM -Unique 
           
        Foreach ($snap in $SortedSnap){
            $tagstatus = Get-TagAssignment $snap.vm
                If ($TagStatus.tag.name -notcontains 'SnapExclude'){
                    $snap.vm | out-file $SortedPathDelete -Append
                }
                If ($TagStatus.tag.name -contains 'SnapExclude'){
                    $snap.vm | Out-File $SortedPathExclude -Append
                }                             
        }
Disconnect-VIServer * -Confirm:$false
}

#Coerces lists into 1) removing the older than 7 day snapshots and 2) those with the correct tag sends as part of the email that they were not deleted
foreach ($vcenter in $viserver){
Connect-VIServer $vcenter -credential $cred
        $subject = "VMware Weekly Snapshot Removal Report for $vcenter"
        $SortedPathDelete = $workDirectory+ $vcenter+"_Snapshot_Removable.csv"
        $SortedPathExclude = $workDirectory+ $vcenter+"_Snapshot_Exclude.csv"
        $DeletePathToExport = $workDirectory + $vcenter+ "_Snapshot_Removal_Report.csv"
        $ExcludedPathToExport = $workDirectory + $vcenter+ "_Snapshot_Exclusion_Report.csv"

        $TestpathDeleteFinal = test-path $SortedPathDelete
        If($TestpathDeleteFinal -eq $True){
        $FinalImport = Import-csv $SortedPathDelete -UseCulture -Header Name
        $FinalSnapList = Get-Snapshot -vm $FinalImport.name | ? {$_.Created -lt (Get-Date).AddDays($n)}
        $FinalSnapOutput = $FinalSnapList | Select-Object VM, Name, Description, Created 
        $FinalSnapOutput | Export-Csv -path $DeletePathToExport -NoTypeInformation -UseCulture
        $FinalSnaplist | Remove-Snapshot  -RemoveChildren -Confirm:$False
        }

        $TestpathExcludeFinal = test-path $SortedPathExclude
        If($TestpathExcludeFinal -eq $True){
        $ExcludedImport = Import-csv $SortedPathExclude -UseCulture -Header Name
        $ExcludedSnapList = Get-Snapshot -vm $ExcludedImport.name | ? {$_.Created -lt (Get-Date).AddDays($n)}
        $ExcludedSnapOutput = $ExcludedSnapList | Select-Object VM, Name, Description, Created 
        $ExcludedSnapOutput | Export-Csv -path $ExcludedPathToExport -NoTypeInformation -UseCulture
        }
        else {$ExcludedPathToExport = $false}

        #Email 
        $testPathEmail = Test-Path -Path $DeletePathToExport
            If ($testPathEmail -eq $True) {
                if ($FinalSnapList -ne $null){
                    $csv = Import-Csv -Path $DeletePathToExport | ConvertTo-Html -Fragment
                        $testPathEmailexclusion = Test-Path -path $ExcludedPathToExport
                        if ($testPathEmailexclusion -eq $true){
                            $csvExclusion =  Import-Csv -Path $ExcludedPathToExport | ConvertTo-Html -Fragment
                        }
                        else {$csvExclusion = "No VM's are currently tagged with the SnapExclude tag on $vcenter"
                        }
                    $body = "
                    <b>The following list of Snapshots were removed due to being older than $days from $date :</b>
                    <br />
                    $csv
                    <b>The following list of Snapshots were <b>NOT</b> removed due to currently being excluded from the script :</b>
                    <br />
                    A VM is excluded by the use of the tag <b>SnapExclude</b> within it's respective vCenter Server
                    <br />        
                    $csvExclusion


                    "
                    Send-MailMessage -to $sendTo -from $from -Subject $subject -body ($body | Out-String)  -SmtpServer $smtp -BodyAsHtml
                    
                }
           }            
        
Disconnect-VIServer * -Confirm:$false
}
