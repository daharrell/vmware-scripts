#Creates a total account of used resources on vcenter1 ,2 and ucsm servers
#Authored by Dan Harrell
#Created on 9/06/2019

#vCenter Servers
$vc1 = "vcenter1"
$vc2 = "vcenter2"
#UCSM Servers
$ucs1 = "ucsm1"
$ucs2 = "ucsm2"
$ucsServer = $ucs1, $ucs2

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false

$username = "Username"
$password = "C:\Path\to\Password.txt"
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, (Get-Content $password | ConvertTo-SecureString)
$sendTo = "SendToEmailAddress"
$from = "SentFromEmailAddress"
$smtp = "SMTPRELAY"
#$HostName = $Env:Computername
$priority = "Normal"
$subject = "VM Usage Report for VM Unit Cost Calculations"
$pathToExport = "C:\temp\UnitCostReport.csv"

#Connects to $vc1
Connect-VIServer $vc1 -credential $cred
   #Total Number of VM's on vCenter1
   $vc1vm = (get-vm).count
   Write-Output $vc1vm
   #Total CPU Allocated on vCenter1
   $vms1cpu = (get-vm | select-object -ExpandProperty NumCPU)
   $total1cpu = $null
   foreach ($vm1cpu in $vms1cpu){
        $total1cpu = $total1cpu + $vm1cpu
   }
   $vc1cpu =[math]::Round($total1cpu)
   Write-Output $vc1cpu 
   
   #Total Memory Allocated on vCenter1  
   $vms1ram = (get-vm | select-object -ExpandProperty  MemoryGB)
   $vc1totalram = $null
   foreach ($vm1ram in $vms1ram){
        $vc1totalram = $vc1totalram + $vm1ram
   }
   $vc1mem =[math]::Round($vc1totalram)
   Write-Output $vc1mem
   
   #Total Used Storage Space 
   #Total Free Space
   $vc1Free = get-datastore | select -ExpandProperty Freespacegb
    $TotalFree = $null
    Foreach ($freespace in $vc1Free){
    $TotalFree = $totalFree + $freespace
    }
    $vc1FreeTotal = [math]::Round($TotalFree)
    Write-Output $vc1FreeTotal
    
    #Total Capacity
    $vc1Capacity = get-datastore | select -ExpandProperty CapacityGB
    $TotalCap = $null
    Foreach ($capspace in $vc1Capacity){
    $TotalCap = $totalcap + $capspace
    }
    $vc1CapTotal = [math]::Round($TotalCap)
    write-output $vc1CapTotal
    
    #Total Used Space
    $vc1UsedStorage = $null
    $vc1UsedStorage = $vc1CapTotal - $vc1FreeTotal

Disconnect-VIServer * -Confirm:$false


#Connects to $v2
Connect-VIServer $vc2 -credential $cred
   #Total Number of VM's on vCenter2
   $vc2vm = (get-vm).count
   Write-Output $vc2vm
   #Total CPU Allocated on vCenter2
   $vms2cpu = (get-vm | select-object -ExpandProperty NumCPU)
   $totalcpu = $null
   foreach ($vmcpu in $vms2cpu){
        $totalcpu = $totalcpu + $vmcpu
   }
   $vc2cpu =[math]::Round($totalcpu) 
   Write-Output $vc2cpu
   
   #Total Memory Allocated on vCenter1  
   $vms2ram = (get-vm | select-object -ExpandProperty  MemoryGB)
   $vc2totalram = $null
   foreach ($vm2ram in $vms2ram){
        $vc2totalram = $vc2totalram + $vm2ram
   }
   $vc2mem =[math]::Round($vc2totalram)
   Write-Output $vc2mem
   
   #Total Used Storage Space 
   
   #Total Free Space
   $vc2Free = get-datastore | select -ExpandProperty Freespacegb
    $TotalFree = $null
    Foreach ($freespace in $vc2Free){
    $TotalFree = $totalFree + $freespace
    }
    $vc2FreeTotal = [math]::Round($TotalFree)
    Write-Output $vc2FreeTotal
    
    #Total Capacity
    $vc2Capacity = get-datastore | select -ExpandProperty CapacityGB
    $TotalCap = $null
    Foreach ($capspace in $vc2Capacity){
    $TotalCap = $totalcap + $capspace
    }
    $vc2CapTotal = [math]::Round($TotalCap)
    write-output $vc2CapTotal
    
    #Total Used Space
    $vc2UsedStorage = $null
    $vc2UsedStorage = $vc2CapTotal - $vc2FreeTotal
    Write-Output $vc2UsedStorage
Disconnect-VIServer * -Confirm:$false


#PowerCli Totals

$FinalTotalVM = $vc1vm + $vc2vm
$FinalTotalCPU = $vc1cpu + $vc2cpu
$FinalTotalMEM = $vc1mem + $vc2mem
$FinalTotalUsed = $vc1UsedStorage + $vc2UsedStorage

#UCS Get-Blade Numbers
Connect-Ucs $ucs1
$hsbcUscBladeCount = (get-ucsblade).count
Disconnect-Ucs

Connect-Ucs $ucs2
$gtwyUscBladeCount = (get-ucsblade).count
Disconnect-Ucs

$totalbladecount = $hsbcUscBladeCount + $gtwyUscBladeCount







$report = $null
$report = @()

$report += New-Object psobject -Property @{Environment=$vc1;TotalMachines=$vc1vm;CPUCount=$vc1cpu;MemoryGB=$vc1mem;UsedSpaceGB=$vc1UsedStorage;BladeCount=$hsbcUscBladeCount}
$report += New-Object psobject -Property @{Environment=$vc2;TotalMachines=$vc2vm;CPUCount=$vc2cpu;MemoryGB=$vc2mem;UsedSpaceGB=$vc2UsedStorage;BladeCount=$gtwyUscBladeCount}
$report += New-Object psobject -Property @{Environment="Total";TotalMachines=$FinalTotalVM;CPUCount=$FinalTotalCPU;MemoryGB=$FinalTotalMEM;UsedSpaceGB=$FinalTotalUsed;BladeCount=$totalbladecount}
$FinalReport = $report| Select-Object Environment,TotalMachines,CPUCount,MemoryGB,UsedSpaceGB,BladeCount
$FinalReport | Export-Csv $pathToExport  -NoTypeInformation -UseCulture



$Head = 
@"
<style>
body {
font-family: "Arial";
font-size: 8pt;
color: #4C607B;
}
th, td { 
border: 1px solid #000000;
border-collapse: collapse;
padding: 5px;
text-align: Center;
}
th {
font-size: 1.2em;
text-align: Center;
background-color: #d2d6da;
color: #000000;
}
td {
color: #000000;
}
.even { background-color: #ffffff; }
.odd { background-color: #bfbfbf; }
</style>
"@

$body = $FinalReport | ConvertTo-HTML -head $Head -Body "<font color=`"Black`"><h4>VM Usage Report for VM Unit Cost Calculations</h4></font>"

Send-MailMessage -To $sendTo -Subject $subject -BodyAsHtml $body -SmtpServer $smtp -From $From -Priority $priority -Attachments $pathToExport


