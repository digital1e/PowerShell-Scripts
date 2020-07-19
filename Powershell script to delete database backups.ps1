$artifactPath = "C:\Production Backup"
$currentDate = Get-Date -Format "yyyyMMdd"
$days = 7
$beforeDate = $currentDate - $days

Write-Output "Current date - $currentDate"
Write-Output "Before date - $beforeDate"

$firstFilename = gci -Path $artifactPath  | ?{$_.Name -ne 'LastRelease'} | Sort-Object -Descending | select -First 1

dir -Path $artifactPath -exclude 'LastRelease' | Sort-Object -Descending | `
%{
    $fileName = $_.Name.Split(".")

    if(($fileName[0] -lt $beforeDate) -and ($fileName[0] -ne (($firstFilename.Name.Split("."))[0])))
    {
        Write-Output "Deleting File $($_.FullName) with $($_.LastWriteTime)"
        Remove-Item $_.FullName -Recurse -Force | Out-Null
    }
}