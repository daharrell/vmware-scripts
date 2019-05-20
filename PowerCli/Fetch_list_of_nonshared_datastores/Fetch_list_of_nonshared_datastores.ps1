#If you want to run against a specific Datacenter, add the Datacenter name after Get-Datacenter
#Ex. Get-Datacenter "SomeDCName"
#If you are unsure of what the Datacenter names are you can just run Get-Datacenter by itself to output a list
#Authored by Dan Harrell
Connect_Viserver    
Get-Datacenter | get-datastore|get-view | ? {$_.summary.multiplehostaccess -eq $false} | select @{n=”DS: Name”;e={$_.name}},@{n=”DS: Shared”;e={$_.summary.multiplehostaccess}} | Export-Csv -path "c:\users\$env:USERNAME\Desktop\FetchedSharedDatastoreList.csv" -NoTypeInformation -UseCulture
Disconnect-viserver * -confirm:$false
