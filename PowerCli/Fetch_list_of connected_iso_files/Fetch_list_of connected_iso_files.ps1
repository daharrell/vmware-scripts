# Fetchs a list of ISO files that are currently connect to VM's from vCenter
#Authored by Dan Harrell
#Updated 5/22/2019

$vcenter = "NameOrIPofVcenter"
$PathToExport = "c:\users\$env:USERNAME\desktop\" + $vcenter+"_cdrom_inventory.csv"

Connect-Viserver $vcenter
#List gets exported to your desktop as a CSV
Get-Datacenter | Get-VM | Get-CDDrive | where {$_.IsoPath} | Select Parent,Name,ConnectionState,IsoPath |Export-Csv -path $PathToExport -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
