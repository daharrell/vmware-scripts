#Authored by Dan Harrell
#Updated 5/22/2019

#vcenter name or IP
$vcenter = "nameofvcenter"
#Path to export CSV
$PathToExport = "c:\users\$env:USERNAME\desktop\" + $vcenter+"_inventory_report.csv"

Connect-VIServer $vcenter

Get-VM | Select Name,@{N="Datastore";E={[string]::Join(',',(Get-Datastore -Id $_.DatastoreIdList | Select -ExpandProperty Name))}},@{N="Folder";E={$_.Folder.Name}} |Export-Csv -path $PathToExport -NoTypeInformation -UseCulture

Disconnect-viserver * -confirm:$false
