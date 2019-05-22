# Fetchs a list of ISO files that are currently connect to VM's from vCenter
#Authored by Dan Harrell
#Updated 5/22/2019

$vcenter = "NameOrIPofVcenter"

Connect-Viserver $vcenter
#List gets exported to your desktop as a CSV
Get-Datacenter | Get-VM | Get-CDDrive | where {$_.IsoPath} | Select Parent,Name,ConnectionState,IsoPath |Export-Csv -path "c:\users\$env:USERNAME\desktop\vcenter1_cdrom_inventory.csv" -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
