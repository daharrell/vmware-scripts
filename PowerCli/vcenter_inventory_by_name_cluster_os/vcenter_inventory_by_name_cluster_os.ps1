#Authored by Dan Harrell
#Updated 5/22/2019

#vcenter name or IP
$vcenter = "NameOrIPofVcenter"
#Path to export CSV
$PathToExport = "c:\users\$env:USERNAME\desktop\inventory_report_name_ds_host.csv"

Connect-VIServer $vcenter
get-vm | Select Name,@{N="Configured OS";E={$_.ExtensionData.Config.GuestFullname}},@{N="Running OS";E={$_.Guest.OsFullName}}, @{N="Powered On";E={ $_.PowerState -eq “PoweredOn”}}, @{N="Host";E={$_.VMHost}} | Export-Csv $PathToExport -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
