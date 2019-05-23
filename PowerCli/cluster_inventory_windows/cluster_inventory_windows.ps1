#Creates a list of all Windows Servers within a Cluster, their power state, number of CPUS and memory
#If you want to run against a specific cluster, add the cluster name after Get-Cluster
#Ex. Get-Cluster "SomeClusterName"
#If you are unsure of what the clusters names are you can just run Get-Cluster by itself to output a list

#Authored by Dan Harrell
#Updated 5/22/2019

#vcenter name or IP
$vcenter = "NameOrIPofVcenter"
$PathToExport = "c:\users\$env:USERNAME\desktop\" + $vcenter+"_ListOfWindowsServers.csv"

Connect-Viserver $vcenter
Get-Cluster | Get-VM | Where{$_.Guest.OSFullName -match 'windows'} | Export-Csv -path $PathToExport -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
