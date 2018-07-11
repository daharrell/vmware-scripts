#Get VMTools status with VM Name, OS, and Powerstate
Get-VM | Get-View | Select-Object @{N="VM Name";E={$_.Name}},@{Name="VMware Tools";E={$_.Guest.ToolsStatus}},@{Name="OS";E={$_.Guest.GuestFullName}},@{Name="PowerState";E={$_.Guest.GuestState}}| Export-CSV C:\VMwareToolsState.csv
