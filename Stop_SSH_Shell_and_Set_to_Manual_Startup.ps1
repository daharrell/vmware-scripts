#These are set to run on all ESX hosts within a vCenter Datacenter. Change "DC Name to the name of your vCenter Datacenter.
#If you want to only run this on the hosts in a cluster instead, change Get-Datacenter to Get-Cluster. If you want to just run on
#a single host then delete Get-Datacenter "DC Name" |  then add the host name after Get-vmhost.
#Comment out which ever commands you dont want to run if you're trying to run this as actual script instead of just using the oneliner
#in powercli.
Connect-Viserver

###Change startup policy of SSH to Manual
#Get-Datacenter "DC Name" | Get-vmhost -state Connected | get-vmhostservice | where-object {$_.key -eq "TSM-SSH"} | set-vmhostservice -policy "Off"

###Change startup policy of ESXI Shell - TSM to Manual
#Get-Datacenter "DC Name" | Get-vmhost -state Connected | get-vmhostservice | where-object {$_.key -eq "TSM"} | set-vmhostservice -policy "Off"

###Stop of ESXI SHell -TSM service
#Get-Datacenter "DC Name" | Get-vmhost -state Connected | get-vmhostservice | where-object {$_.key -eq "TSM"} | Stop-VMHostService -Confirm:$false

###Stop of SSH service
#Get-Datacenter "DC Name" | Get-vmhost -state Connected | get-vmhostservice | where-object {$_.key -eq "TSM-SSH"} | Stop-VMHostService -Confirm:$false

Disconnect-viserver * -confirm:$false
