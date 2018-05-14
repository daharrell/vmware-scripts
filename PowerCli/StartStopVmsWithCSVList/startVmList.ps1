#Add Name or IP to Connect-vcenter comman
#Add path to where the csv is stored for import-csv command
connect-viserver NameOrIpOfVcenter
$vmlist = import-csv c:\someptahtto\vmlist.csv | select -ExpandProperty NAME
foreach ($vm in $vmlist) {
Get-VM $vm | Where-Object {$_.powerstate -eq ‘PoweredOFF’} | Start-VM -Confirm:$false}
Disconnect-VIServer -confirm:$false
