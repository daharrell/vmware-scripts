#Get VMTools status with VM Name, OS, and Powerstate
#Authored by Dan Harrell
#Updated 5/22/2019

$vcenter = "NameOrIPofVcenter"
$PathToExport = "c:\users\$env:USERNAME\desktop\" + $vcenter+"_vmtools_status.csv"

Connect-Viserver $vcenter
#Exports status report to your desktop
Get-VM | Get-View | Select-Object @{N="VM Name";E={$_.Name}},@{Name="VMware Tools";E={$_.Guest.ToolsStatus}},@{Name="OS";E={$_.Guest.GuestFullName}},@{Name="PowerState";E={$_.Guest.GuestState}}| Export-Csv -path $PathToExport -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
