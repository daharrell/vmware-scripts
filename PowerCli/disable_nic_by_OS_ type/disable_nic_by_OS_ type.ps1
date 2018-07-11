Connect-VIServer
Get-VM | Where{$_.Guest.OSFullName -match 'windows'}|Get-NetworkAdapter | Set-NetworkAdapter -Connected:$true -Confirm:$false
Disconnect-viserver * -confirm:$false
