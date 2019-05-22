#Used to assign advanced settings to all VM's in a Vcenter DataCenter
#Create a two column csv with the setting name and the value the setting needs to be
#Input file is the path to where the csv is located - exampe shows it located on a users desktop
$InputFile = “c:\users\$env:USERNAME\desktop\AdvancedSettings.csv"
$dcname = "NameOfTheVMdatacentergoeshere"
$KeyValue = Import-Csv $InputFile -Header Name,Value

foreach ($line in $KeyValue) {
Get-Datacenter -Name $dcname| Get-VM | New-AdvancedSetting -Name ($line.Name) -value ($line.value) -Force -Confirm:$false
}

Disconnect-viserver * -confirm:$false

