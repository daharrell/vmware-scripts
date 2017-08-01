Connect-VIserver
get-view -viewtype virtualmachine -Filter @{'Config.Tools.SyncTimeWithHost'='True'} | select name |Export-Csv C:\timesync.csv -NoTypeInformation -
UseCulture
