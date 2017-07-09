Connect-VIServer
Get-VM | Select Name,@{N="Datastore";E={[string]::Join(',',(Get-Datastore -Id $_.DatastoreIdList | Select -ExpandProperty Name))}},@{N="Folder";E={$_.Folder.Name}} |Export-Csv C:\inventory_report.csv -NoTypeInformation -UseCulture
