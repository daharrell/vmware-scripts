connect-viserver  vCenterNameORip
Get-Datacenter DCNAME | Get-Folder Infected_DO_NOT_POWER_ON |Get-VM | Set-VM -Notes "$($_.Notes) Your Note here"
