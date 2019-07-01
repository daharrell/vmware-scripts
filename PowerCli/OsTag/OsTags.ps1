#The tags have to exist on the vcenter server(s) that you want to run this script against
#Authored by Dan Harrell
#Updated 6/29/2019

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
$sendTo = "SendToEmailAddress"
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, (Get-Content $password | ConvertTo-SecureString)

foreach ($vc in $viserver){
Connect-VIServer $vc -credential $cred
    
#Tags based on OS pulled from powercli
$osInstalled = get-vm |  Select Name,@{N="ConfiguredOS";E={$_.ExtensionData.Config.GuestFullname}}
    foreach ($vm in $osInstalled){
        $configuredOs = $vm.ConfiguredOs
        $name = $vm.Name
            if ($configuredOs.Contains("2000")){
            Write-Output "Windows 2000 Server: $name"
              get-vm $name | new-TagAssignment -tag "windows2000" 
               }
            if ($configuredOs.Contains("2003")){
            Write-Output "Windows 2003 Server: $name "
              get-vm $name | new-TagAssignment -tag "windows2003" 
               }
            if ($configuredOs.Contains("2008")){
            Write-Output "Windows 2008 Server: $name"
              get-vm $name | new-TagAssignment -tag "windows2008" 
               }
            if ($configuredOs.Contains("2012")){
            Write-Output "Windows 2012 Server: $name"
              get-vm $name | new-TagAssignment -tag "windows2012" 
               }
            if ($configuredOs.Contains("2016")){
            Write-Output "Windows 2016 Server: $name"
              get-vm $name | new-TagAssignment -tag "windows2016" 
               }
            if ($configuredOs.Contains("Enterprise 11")){
            Write-Output "Suse Enterprise 11: $name"
              get-vm $name | new-TagAssignment -tag "suse11" 
               }
            if ($configuredOs.Contains("Enterprise 12")){
               Write-Output "Suse Enterprise 11: $name"
              get-vm $name | new-TagAssignment -tag "suse12" 
               }
            if ($configuredOs.Contains("Linux 5")){
               Write-Output "Redhat Enterprise 5: $name"
              get-vm $name | new-TagAssignment -tag "rhel5" 
               }
            if ($configuredOs.Contains("Linux 6")){
               Write-Output "Redhat Enterprise 6: $name"
              get-vm $name | new-TagAssignment -tag "rhel6" 
               }
            if ($configuredOs.Contains("Linux 7")){
               Write-Output "Redhat Enterprise 6: $name"
              get-vm $name | new-TagAssignment -tag "rhel7" 
               }
           if ($configuredOs.Contains("Windows 7")){
               Write-Output "Windows 7: $name"
              get-vm $name | new-TagAssignment -tag "windows7" 
               }
           if ($configuredOs.Contains("Windows 8.x")){
               Write-Output "Windows 8: $name"
              get-vm $name | new-TagAssignment -tag "windows8" 
               }
           if ($configuredOs.Contains("Windows 10")){
               Write-Output "Windows 10: $name"
              get-vm $name | new-TagAssignment -tag "windows10" 
               }
           if ($configuredOs.Contains("Debian")){
               Write-Output "Debian: $name"
              get-vm $name | new-TagAssignment -tag "debian" 
               }
           if ($configuredOs.Contains("CentOS")){
               Write-Output "Centos: $name"
              get-vm $name | new-TagAssignment -tag "centos" 
               }
           if ($configuredOs.Contains("Oracle")){
               Write-Output "Oracle: $name"
              get-vm $name | new-TagAssignment -tag "oracle" 
               }
           if ($configuredOs.Contains("Ubuntu")){
               Write-Output "Ubuntu: $name"
              get-vm $name | new-TagAssignment -tag "ubuntu" 
               }
           if ($configuredOs.Contains("Other")){
               Write-Output "Other: $name"
              get-vm $name | new-TagAssignment -tag "other" 
               }

 }  
 Disconnect-VIServer $vc -Confirm:$false
 }        
