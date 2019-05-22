#Script will add mem to all vm's listed in csv
#Authored by Dan Harrell
#Created 5/22/2019
#CSV has to be located on your desktop 
#CSV has to have two columns, one labled name and the other named mem. 
#Mem needs to be listed as a number equal to the amount of GB you want to add
$InputFile = “c:\users\$env:USERNAME\desktop\vcenter1MemAdder.csv"
# Read the input file which is formatted as name and amount of mem to add with a header row
$vcenter = "NameOrIPofVcenter"

$vms = Import-CSV $InputFile

Connect-VIserver $vcenter
ForEach ($vm in $vms) {

    # Capture the csv contents to variables
    $vmName = $vm.name
    $vmMem = $vm.mem

    Write-Host "Adding $recordRam to $recordName"
    #Lets add mem to the vm's
    Get-VM -Name $vmName | Set-VM -MemoryGB $vmMem
    }
Disconnect-viserver * -confirm:$false
