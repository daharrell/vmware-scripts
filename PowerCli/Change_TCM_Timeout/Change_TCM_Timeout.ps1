#Sets the timeout of TCM to whatever the variable is set to, 
#Authored by Dan Harrell
#Updated 5/22/2019

vcenter = "NameOrIPofVcenter"
$dcname = "dcnameinsidevcenter"
$tcmValue = "300"

Connect-VIServer $vcenter
Get-Datacenter $dcname | Get-vmhost -state Connected | Get-AdvancedSetting -Name 'UserVars.ESXiShellInteractiveTimeOut' | Set-AdvancedSetting -Value $tcmValue -Confirm:$false
Disconnect-viserver * -confirm:$false
