Connect_Viserver    
Get-Datacenter "DC NAME" | get-datastore|get-view | ? {$_.summary.multiplehostaccess -eq $false} | select @{n=”DS: Name”;e={$_.name}},@{n=”DS: Shared”;e={$_.summary.multiplehostaccess}}
Disconnect-viserver * -confirm:$false
