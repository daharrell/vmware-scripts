#Create a list of VM's, #of CPU's, amount of mem, and average cpu usage for X days
#Authored by Dan Harrell
#Created 5/23/2019

$vcenter = "NameorIpofVcenterServer"
$pathToExport = "c:\users\$env:USERNAME\desktop\" + $vcenter + "_vm_stats.csv"
connect-viserver $vcenter
Get-VM | Where {$_.PowerState -eq "PoweredOn"} | Select Name, NumCpu, MemoryMB,@{N="Cpu.UsageMhz.Average";E={[Math]::Round((($_ |Get-Stat -Stat cpu.usagemhz.average -Start (Get-Date).AddHours(-24)-IntervalMins 5 -MaxSamples (12) |Measure-Object Value -Average).Average),2)}},
 @{N="Mem.Usage.Average";E={[Math]::Round((($_ |Get-Stat -Stat mem.usage.average -Start (Get-Date).AddHours(-24)-IntervalMins 5 -MaxSamples (12) | Measure-Object Value -Average).Average),2)}} | Export-Csv -path $pathToExport -NoTypeInformation -UseCulture
