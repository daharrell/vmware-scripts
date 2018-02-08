#Written by Dan Harrell
Connect-VIServer
Get-VM | Select Name,@{N="Datastore";E={[string]::Join(',',(Get-Datastore -Id $_.DatastoreIdList | Select -ExpandProperty Name))}},@{N="Host";E={$_.VMHost}} |Export-Csv C:\inventory_report_name_ds_host.csv -NoTypeInformation -UseCulture
