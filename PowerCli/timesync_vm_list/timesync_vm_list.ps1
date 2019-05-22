#Pulls list of VM's that Sync Time with Host
#Authored by Dan Harrell
#Updated 5/22/2019

#vcenter name or IP
$vcenter = "NameOrIPofVcenter"
#exports list to current users desktop
$pathToExport = “c:\users\$env:USERNAME\desktop\timesync.csv

Connect-VIserver $vcenter
get-view -viewtype virtualmachine -Filter @{'Config.Tools.SyncTimeWithHost'='True'} | select name |Export-Csv $pathToExport -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
