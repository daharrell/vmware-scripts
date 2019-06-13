#Create a list of the amount of VMs per host from vcenter
#Authored by Dan Harrell
#Created 5/23/2019

#Define these variables
$vcenter = "vcenter.servername.com"
$pathToExport = "c:\users\$env:USERNAME\desktop\" + $vcenter + "_VM_per_Host_Count.csv"

connect-viserver $vcenter
Get-VMHost | Select @{N=“Cluster“;E={Get-Cluster -VMHost $_}}, Name, @{N=“NumVM“;E={($_ | Get-VM).Count}} | Sort Cluster, Name | Export-Csv -Path $pathToExport -NoTypeInformation -UseCulture
disconnect-viserver * -confirm:$false
