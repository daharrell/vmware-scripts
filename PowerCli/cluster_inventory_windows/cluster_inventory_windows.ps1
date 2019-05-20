#Creates a list of all Windows Servers within a Cluster, their power state, number of CPUS and memory
#If you want to run against a specific cluster, add the cluster name after Get-Cluster
#Ex. Get-Cluster "SomeClusterName"
#If you are unsure of what the clusters names are you can just run Get-Cluster by itself to output a list
# Authored by Dan Harrell
Connect-Viserver
Get-Cluster | Get-VM | Where{$_.Guest.OSFullName -match 'windows'} | Export-Csv -path "c:\users\$env:USERNAME\Desktop\ListWindowsServers.csv" -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
