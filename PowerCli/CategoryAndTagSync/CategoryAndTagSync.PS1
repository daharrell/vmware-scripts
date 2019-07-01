#WIP
#Exports lists of all existing tags and categories on all vcenter servers defined by $viserver. Creates a list for each vCenter,
#calls scripts to combine up each set (One set for categories and one for tags) and then clean up duplicates. Once the clean list
#is complete it will call the next set of scripts to add the Category list to each vCenter and then the same for tags.

#Authored by Dan Harrell
#Created on 6/24/2019

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

foreach ($vc in $viserver){
    Connect-VIServer $vc -credential $cred
    $pathToExportTags = "C:\Path\To\Tags\" + $vc + "_Tag_Info.csv"
    $pathToExportCats = "C:\Path\To\Category\" + $vc + "_Category_Info.csv"
    
        $testPath = Test-Path $pathToExportTags
        if ($testPath -eq $True){
        remove-item $pathToExportTags
        }
    
        $testPath = Test-Path $pathToExportCats
        if ($testPath -eq $True){
        remove-item $pathToExportCats
        }
     
          
    #Get tags
    $tags = get-tag | Select-Object Name, Category, Description 
    $tags | Export-Csv -Path $pathToExportTags -NoTypeInformation -UseCulture
      
    #Get categories
    $cats = Get-TagCategory | Select-Object "Name", "Cardinality", "Description"
    $cats | Export-Csv -Path $pathToExportCats -NoTypeInformation -UseCulture
     
    Disconnect-VIServer * -Confirm:$False
}

C:\Path\To\tagCleanup.ps1
C:\Path\To\catCleanup.ps1

Remove-Item –path C:\Path\To\Category\* -include *.csv
Remove-Item –path C:\Path\To\Category\* -include *.csv

C:\Path\To\CatAdd.ps1
C:\Path\To\TagAdd.ps1
