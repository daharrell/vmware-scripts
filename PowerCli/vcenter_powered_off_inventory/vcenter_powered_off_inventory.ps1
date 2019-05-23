#vcenter name or IP
$vcenter = "NameOrIPofVcenter"
$pathToExport = "c:\users\$env:USERNAME\desktop\" + $vcenter + "_PoweredOffInventory.csv"

Connect-VIServer $vcenter
$Report = @()
$VMs = get-vm |Where-object {$_.powerstate -eq "poweredoff"}
$Datastores = Get-Datastore | select Name, Id
Get-VIEvent -Entity $VMs -MaxSamples ([int]::MaxValue) | where {$_ -is [VMware.Vim.VmPoweredOffEvent]} |Group-Object -Property {$_.Vm.Name} | %{

  $lastPO = $_.Group | Sort-Object -Property CreatedTime -Descending | Select -First 1

  $vm = Get-VM -Name $_.Name

  $row = '' | select VMName,Powerstate,OS,Host,Cluster,Datastore,NumCPU,MemMb,DiskGb,PowerOFF

    $row.VMName = $vm.Name
    $row.Powerstate = $vm.Powerstate
    $row.OS = $_.Guest.OSFullName
    $row.Host = $vm.VMHost.name
    $row.Cluster = $vm.VMHost.Parent.Name
    $row.Datastore = ($Datastores | where {$_.ID -match (($vm.Datastore | Select -First 1) | Select Value).Value} | Select Name).Name
    $row.NumCPU = $vm.NumCPU
    $row.MemMb = $vm.MemoryMB
    $row.DiskGb = ((($vm.HardDisks | Measure-Object -Property CapacityKB -Sum).Sum * 1KB / 1GB),2)
    $row.PowerOFF = $lastPO.CreatedTime
    $row.UserName = $lastPO.UserName

    $report += $row

}

$report | Sort Name | Export-Csv -Path $pathToExport -NoTypeInformation -UseCulture
disconnect-viserver * -confirm:$false
