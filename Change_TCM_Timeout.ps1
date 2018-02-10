
#Written by Dan Harrell
#Sets the timeout of TCM to 300 seconds.
Connect-VIServer
Get-Datacenter "DC Name" | Get-vmhost -state Connected | Get-AdvancedSetting -Name 'UserVars.ESXiShellInteractiveTimeOut' | Set-AdvancedSetting -Value "300" -Confirm:$false
Disconnect-viserver * -confirm:$false
