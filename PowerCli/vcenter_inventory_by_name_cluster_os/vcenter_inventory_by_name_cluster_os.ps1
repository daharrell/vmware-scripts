#Written by Dan Harrell
Connect-VIServer
get-vm | Select Name,@{N="Configured OS";E={$_.ExtensionData.Config.GuestFullname}},@{N="Running OS";E={$_.Guest.OsFullName}}, @{N="Powered On";E={ $_.PowerState -eq “PoweredOn”}}, @{N="Host";E={$_.VMHost}} |Export-Csv C:\users\Dan_Harrell\Desktop\inventory_report_name_ds_host.csv -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
