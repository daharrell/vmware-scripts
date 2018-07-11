#This will allow you to change an advanced setting on all hosts in a cluster
Get-Cluster -name "ClusterName"| Get-VMHOST | Get-AdvancedSetting -Name "SomeAdvancedSettingName" | Set-AdvancedSetting -Val
ue "SomeValue"
