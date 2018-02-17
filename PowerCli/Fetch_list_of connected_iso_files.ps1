Connect-Viserver
Get-Datacenter "DC NAME" | Get-VM | Get-CDDrive | where {$_.IsoPath} | Select Parent,Name,ConnectionState,IsoPath |Export-Csv C:\Your PATH\cdrom-inventory.csv -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
