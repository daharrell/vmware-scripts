#Authored by Dan Harrell
#Created on 6/27/2019

#vcenter name or IP
#vCenter Servers
$vc1 = "SomeVcenterServer1"
$vc2 = "SomeVcenterServer2"
$vc3 = "SomeVcenterServer3"
$vc4 = "SomeVcenterServer4"
$vc5 = "SomeVcenterServer5"
$viserver = $vc1, $vc2, $vc3, $vc4, $vc5

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false

#Define your variables
$username = "YourUserName"
$password = "C:\Path\to\Password.txt"
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, (Get-Content $password | ConvertTo-SecureString)

$PathToExportCleanTags = "C:\Path\To\Combined\vCenterTags.csv"
$PathToExportCleanCats = "C:\Path\To\Combined\vCenterCats.csv"

foreach ($vc in $viserver){
    Connect-VIServer $vc -credential $cred
    $cat1= Import-Csv -Path $PathToExportCleanCats
    $x=0
        foreach ($cat in $cat1){
            $Name = $cat1.Name[$x]
            $Cardinality  = $cat1.Cardinality[$x]
            $Description = $cat1.Description[$x]
            $x++;
            Write-Output "Name = $Name"
            write-output "Cardinality = $Cardinality"
            Write-output "Description = $Description"
            New-TagCategory -Name $Name -Cardinality $Cardinality -Description $Description 
            }
            Disconnect-VIServer * -Confirm:$false
            }
