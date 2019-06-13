#List of VM's, The cluster they are in, and which host it belongs to
#Written by Dan Harrell
#VARIABLE to define Datacenter name from vcenter

Set-StrictMode -Off
$dc = "Name of your vcenter datacenter"

#VARIABLE to define the vcenter server name to connect to

$vc = "vcenter.servername.com"

Connect-VIServer $vc

#Pulls inventory from the datacenter by VM, Cluster and its respective host
get-datacenter $dc | Get-VMhost | GET-VM | Select Name, @{N="Cluster";E={Get-Cluster -VM $_}}, @{N="ESX Host";E={Get-VMHost -VM $_}} | Export-Csv -path "c:\users\$env:USERNAME\desktop\vcenter_hosts.csv" -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
