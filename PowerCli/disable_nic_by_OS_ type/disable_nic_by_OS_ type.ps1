
#Authored by Dan Harrell
#Updated 5/22/2019
#vcenter name or IP
$vcenter = "NameOrIPofVcenter"

Connect-VIServer $vcenter
Get-VM | Where{$_.Guest.OSFullName -match 'windows'}|Get-NetworkAdapter | Set-NetworkAdapter -Connected:$true -Confirm:$false
Disconnect-viserver * -confirm:$false
