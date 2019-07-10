#vCenter Servers
$vc1 = ""
$vc2 = ""
$viserver = $vc1, $vc2

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false

$username = ""
$password = ""
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, (Get-Content $password | ConvertTo-SecureString)

foreach ($vc in $viserver){
    Connect-VIServer $vc -credential $cred
    $PathToExport = "c:\users\$env:USERNAME\desktop\" + $vc+ "_WWNReport.csv"
    $Datacenter = Get-Datacenter
    $hosti = $Datacenter| Get-VMHost
         $WWNreport = foreach ($esxi in $hosti) {
                Get-VMHosthba -VMHost $esxi -type FibreChannel |
                Select  @{N="Host";E={$esxi.Name}},
                @{N='HBA Node WWN';E={$wwn = "{0:X}" -f $_.NodeWorldWideName; (0..7 | %{$wwn.Substring($_*2,2)}) -join ':'}},
                @{N='HBA Node WWP';E={$wwp = "{0:X}" -f $_.PortWorldWideName; (0..7 | %{$wwp.Substring($_*2,2)}) -join ':'}}
                }
    Disconnect-VIServer * -Confirm:$false
    $WWNreport | Export-csv  -Path $PathToExport –NoTypeInformation
}

 
