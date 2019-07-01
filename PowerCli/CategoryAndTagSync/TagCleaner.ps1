#TAGs
$getFirstLine = $true
$PathToExportCleanTags = "C:\Path\to\Combined\vCenterTags.csv"
get-childItem "C:\Path\to\Pulled\tags\*.csv" | foreach {
    $filePath = $_
    $lines = Get-Content $filePath  
    $linesToWrite = switch($getFirstLine) {
           $true  {$lines}
           $false {$lines | Select -Skip 0}
    }
    $getFirstLine = $false
    Add-Content "$PathToExportCleanTags" $linesToWrite
    }
$sortDupTag = Import-Csv -Path $PathToExportCleanTags | sort Name -Unique
$sortDupTag | Export-Csv -Path $PathToExportCleanTags -NoTypeInformation -UseCulture
