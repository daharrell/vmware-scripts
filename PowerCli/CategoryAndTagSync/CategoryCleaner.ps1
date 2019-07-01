# Categories
$PathToExportCleanCats = "C:\Path\to\Combined\vCenterCats.csv" 
$getFirstLine = $true
get-childItem "C:\Path\to\Collected\category\*.csv" | foreach {
    $filePath = $_
    $lines = Get-Content $filePath  
    $linesToWrite = switch($getFirstLine) {
           $true  {$lines}
           $false {$lines | Select -Skip 0}
    }
    $getFirstLine = $false
    Add-Content "$PathToExportCleanCats" $linesToWrite
    }
$sortDupTag = Import-Csv -Path $PathToExportCleanCats | sort Name -Unique
$sortDupTag | Export-Csv -Path $PathToExportCleanCats -NoTypeInformation -UseCulture
