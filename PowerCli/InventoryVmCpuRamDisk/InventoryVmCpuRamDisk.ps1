#Inventory for all VM's, Number of vCpu's, Memory in GB and Used Diskspace and exports it to the users desktop
#Authored by Dan Harrell
#Created on 6/11/2019

#Define these variables
$vc = "vcenterServer"

Connect-viserver $vc
Get-VM | Select Name,@{N='VMHost';E={$_.VMHost.Name}}, NumCpu,MemoryGB,UsedSpaceGB | Export-Csv "c:\users\$env:USERNAME\desktop\" + $vc + "_Vm_Cpu_Ram_Disk.csv" -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
