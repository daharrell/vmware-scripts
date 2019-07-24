#max EVC level,

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
$from = "SendFromEmailAddress"
$sendToErr= "SendToEmailAddressErrors"
$smtp = "YourSmtpServer"
$HostName = $Env:Computername

foreach ($vcenter in $viserver){
    Connect-VIServer $vcenter -credential $cred
        $subject =  "$VCenter Host Max EVC Level Report"
        $PathToExport = "c:\temp\" + $vcenter+ "_Max_EVC_Report.csv"   
      $EVClevel = get-vmhost | Select-Object Name, ProcessorType, MaxEVCMode
      $EVClevel | Export-Csv -Path $PathToExport -NoTypeInformation -UseCulture
      $testPath = Test-Path $PathToExport
        if ($testPath -eq $true){
            if ( $EVClevel -ne $Null){
##############################################################################################################################
#Email Message Building
# Table name
$tabName = “EVC Report”
 
                    # Create Table object
                    $table = New-Object system.Data.DataTable “$tabName”
 
                    # Define Columns
                    $col1 = New-Object system.Data.DataColumn "Name",([string])
                    $col2 = New-Object system.Data.DataColumn "ProcessorType",([string])
                    $col3 = New-Object system.Data.DataColumn "MaxEVCMode",([string])

                    # Add the Columns
                    $table.columns.add($col1)
                    $table.columns.add($col2)
                    $table.columns.add($col3)

                    $tagResult = Import-Csv -Path $PathToExport #| ConvertTo-Html -Fragment#
                        foreach ($line in $tagResult){
                                # Create a row
                                $row = $table.NewRow()
  
                                # Enter data in the row
                                $row."Name" = ($line.name)
                                $row."ProcessorType" = ($line.ProcessorType)
                                $row."MaxEVCMode" = ($line.MaxEVCMode)
 
                                # Add the row to the table
                                $table.Rows.Add($row)
                                }
$Head = 
@"
<style>
body {
font-family: "Arial";
font-size: 8pt;
color: #4C607B;
}
th, td { 
border: 1px solid #000000;
border-collapse: collapse;
padding: 5px;
}
th {
font-size: 1.2em;
text-align: Center;
background-color: #d2d6da;
color: #000000;
}
td {
color: #000000;
}
.even { background-color: #ffffff; }
.odd { background-color: #bfbfbf; }
</style>
"@

 
# Creating body
[string]$body = [PSCustomObject]$table | select -Property "Name","ProcessorType","MaxEVCMode"  | sort -Property "Name"  | ConvertTo-HTML -head $Head -Body "<font color=`"Black`"><h4>Maximum EVC Level for Hosts on $vcenter </h4></font>" 

Send-MailMessage -To $sendTo -Subject $subject -BodyAsHtml $body -SmtpServer $smtp -From $From -Priority $priority
######################################################################################################################################
}
}
Disconnect-VIServer * -Confirm:$false
Remove-Item -Path $PathToExport -Confirm:$false
}
                
