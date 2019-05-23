#If you want to run against a specific Datacenter, add the Datacenter name after Get-Datacenter
#Ex. Get-Datacenter "SomeDCName"
#If you are unsure of what the Datacenter names are you can just run Get-Datacenter by itself to output a list
#Authored by Dan Harrell
#Updated 5/22/2019

$vcenter = "NameOrIPofVcenter"
$PathToExport = "c:\users\$env:USERNAME\desktop\" + $vcenter+"FetchedSharedDatastoreList.csv"
Connect_Viserver $vcenter 
#Exports the list to your desktop
Get-Datacenter | get-datastore|get-view | ? {$_.summary.multiplehostaccess -eq $false} | select @{n=”DS: Name”;e={$_.name}},@{n=”DS: Shared”;e={$_.summary.multiplehostaccess}} | Export-Csv -path $PathToExport -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
