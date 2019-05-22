#This will allow you to change one advanced setting on all hosts in a cluster
#Authored by Dan Harrell
#Updated 5/22/2019
#Set variables
$cluster = "ClusterNameGoesHere"
$advance = "SomeAdvancedSettingName"
$advanceValue = "SomeValue"
$vcenter = "NameOrIPofVcenter"

Connect-Viserver $vcenter
Write-Host "Changing $advance setting to $advanceValue for all VM's in $cluster cluster on vcenter $vcenter"
Get-Cluster -name $cluster | Get-vmhost | Get-AdvancedSetting -Name $advance | Set-AdvancedSetting -Value $advanceValue
Disconnect-viserver * -confirm:$false
