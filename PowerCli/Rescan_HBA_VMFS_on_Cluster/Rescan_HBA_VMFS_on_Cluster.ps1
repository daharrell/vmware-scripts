#Rescan HBA and VMFS on all hosts within a vCenter cluster
#Authored by Dan Harrell
#Updated 5/22/2019

#Variables need to be changed to work for your environment
$vcenter = "NameOrIPofVcenter"
$cluster = "ClusterNameGoesHere"

Connect-Viserver $vcenter
Get-Cluster $cluster get-vmhost | Get-vmhoststorage -rescanallhba -rescanvmfs
Disconnect-viserver * -confirm:$false 
