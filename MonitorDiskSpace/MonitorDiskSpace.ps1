$baseDir = (Resolve-Path .\).Path
$logFile = $baseDir + "\diskspace.log"
$configurationFile = $baseDir + "\configuration.xml"
[xml]$configuration = Get-Content $configurationFile
Write-Output "$(Get-Date) : INFO starting the script execution" | Out-File $logFile -Append -Force
$diskSpaceError = [int32]$configuration.DailyReport.Threshold.DiskSpaceError
$diskSpaceWarning = [int32]$configuration.DailyReport.Threshold.DiskSpaceWarning

try {
    foreach($entity in $configuration.DailyReport.Servers){
        $server = $entity.Server
        Get-WmiObject -Query "select * from win32_logicaldisk where drivetype=3" -ComputerName $server | Select-Object SystemName, DeviceId, @{Name="Size"; Expression={[math]::Round($_.Size/1GB,2)}}, @{Name="FreeSpace";Expression={[math]::Round($_.FreeSpace/1GB,2)}}, @{Name="Occupied";Expression={[math]::Round(100 - ([double]$_.FreeSpace / [double]$_.Size) * 100)}} | Export-Csv ($baseDir + "\diskspace.csv") -NoTypeInformation
    }

    $csvContent = Import-Csv "diskspace.csv"
    $csvContent | Where-Object{$_.Occupied -lt $diskSpaceError -and $_.Occupied -gt $diskSpaceWarning} | Format-Table | Out-File $logFile -Append -Force
}
catch {
    $errorMessage = $_.Exception.Message
    Write-Output $errorMessage | Out-File $logFile -Append -Force
}