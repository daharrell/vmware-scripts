#Get VMTools status with VM Name, OS, and Powerstate
#Authored by Dan Harrell
Connect-Viserver
Get-VM | Get-View | Select-Object @{N="VM Name";E={$_.Name}},@{Name="VMware Tools";E={$_.Guest.ToolsStatus}},@{Name="OS";E={$_.Guest.GuestFullName}},@{Name="PowerState";E={$_.Guest.GuestState}}| Export-Csv -path "c:\users\$env:USERNAME\desktop\vcenter_vmtools_status.csv" -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
