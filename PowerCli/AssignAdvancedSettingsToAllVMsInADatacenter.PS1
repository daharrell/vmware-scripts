#Used to assign advanced settings to all VM's in a Vcenter DataCenter
#Create a two column csv with the setting name and the value the setting needs to be
$KeyValue = Import-Csv 'c:\Pathtocsv' -Header Name,Value
foreach ($line in $KeyValue) {
Get-Datacenter -Name "Needham"| Get-VM | New-AdvancedSetting -Name ($line.Name) -value ($line.value) -Force -Confirm:$false}
