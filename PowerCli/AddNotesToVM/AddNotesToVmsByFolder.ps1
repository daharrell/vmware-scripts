#Variables to be entered here
$vcentername = "NameOrIpOfVcenterGoesHere:
$dcname = "NameOfTheVMdatacenterGoeshere"
$folder = "NameOfFolderInVcenterGoesHere"
#Connect to Vcenter
connect-viserver $vcentername
#Command to add notes to the specified folder go here
Write-Host "Notes are being added to $folder in $dcname on vCenter $vcentername"
Get-Datacenter $vcentername | Get-Folder $folder |Get-VM | Set-VM -Notes "$($_.Notes) Your Note here"
Disconnect-viserver * -confirm:$false
