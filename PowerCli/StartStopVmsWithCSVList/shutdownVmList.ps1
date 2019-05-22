#Add Name or IP to Connect-vcenter comman
#Add path to where the csv is stored for import-csv command
#Authored by Dan Harrell
#Updated 5/22/2019

#vcenter name or IP
$vcenter = "NameOrIPofVcenter"
#Path to csv file
$path = "c:\some\path\to\vmlist.csv"

connect-viserver $vcenter
$vmlist = import-csv $path  | select -ExpandProperty NAME
foreach ($vm in $vmlist) {
Get-VM $vm | Where-Object {$_.powerstate -eq ‘PoweredOn’} | Shutdown-vmguest -Confirm:$false}
Disconnect-VIServer -confirm:$false
