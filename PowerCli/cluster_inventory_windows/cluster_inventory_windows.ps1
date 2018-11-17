# Will output a basic list of Windows VM's showing power state - number of vCPU's and Ram
# Name                 PowerState Num CPUs MemoryGB
# ----                 ---------- -------- --------
# VM 1                    PoweredOn  4        4.000
# VM 2            PoweredOn  4        16.000

Get-Cluster "ClusterName" | Get-VM | Where{$_.Guest.OSFullName -match 'windows'}
