Connect-Viserver
Get-Datacenter "DC Name" | Get-VM | Get-CDDrive | where {$_.IsoPath -ne $null} | Set-CDDrive -NoMedia -Confirm:$False 
Disconnect-viserver * -confirm:$false