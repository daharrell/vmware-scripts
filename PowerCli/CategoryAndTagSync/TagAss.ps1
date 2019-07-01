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

$PathToExportCleanTags = "C:\Path\to\Combined\vCenterTags.csv"
        
foreach ($vc in $viserver){
    Connect-VIServer $vc -credential $cred 
    $tag1 = Import-Csv -Path $PathToExportCleanTags
    $x=0
        foreach ($tag in $tag1){
            $Name = $tag1.Name[$x]
            $Category  = $tag1.Category[$x]
            $Description = $tag1.Description[$x]
            $x++;
            Write-Output "Name = $Name"
            write-output "Category = $Category"
            Write-output "Description = $Description"
            New-Tag -Name $Name -Category $Category -Description $Description 
            }      
            Disconnect-VIServer * -Confirm:$false
            }   
