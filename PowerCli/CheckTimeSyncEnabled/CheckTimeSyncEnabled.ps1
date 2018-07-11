#script to check all vm's on vcenter and output a list if they have VMtools time sync enabled
Connect-Viserver
get-view -viewtype virtualmachine -Filter @{'Config.Tools.SyncTimeWithHost'='True'} | select name| Export-CSV C:\TimeSyncEnabled.csv
