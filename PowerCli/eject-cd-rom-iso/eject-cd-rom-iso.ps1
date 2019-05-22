#Ejects all iso files for every vm within a vCenter Datacenter
#Authored by Dan Harrell
#Updated 5/22/2019

#vcenter name or IP
$vcenter = "NameOrIPofVcenter"
#Name of DC inside vcenter
$dcname = "SomeDCName

Connect-Viserver $vcenter
Get-Datacenter $dcname | Get-VM | Get-CDDrive | where {$_.IsoPath -ne $null} | Set-CDDrive -NoMedia -Confirm:$False 
Disconnect-viserver * -confirm:$false
