[CmdletBinding()]

param(
    [string] $StorageAccountName,
    [string] $AzureShare,
    [string] $Source,
    [string] $StorageAccountKey
)

Write-Output "Storage name - $StorageAccountName"
Write-Output "Azure share - $AzureShare"
Write-Output "Source - $Source"

#installing Azure module
Install-PackageProvider -Name Nuget -Force -Scope CurrentUser
Install-Module AzureRM -AllowClobber -Scope CurrentUser -Force

#define varibales
#$StorageAccountName = "StorageName"
#$StorageAccountKey = "Key"
#$AzureShare = "FileShare"

#Here I am using the name of the folder as LatestPublish for publishing the output. You can choose different name if you want.
$AzureDirectory = "Directory"

#record your artifact name instead of _SampleCoreApp-ASP.NET Core-CI is your artifact name is different. Make sure to add "/" before the artifact name as shonw below. 
#Also I am assuming you have the folder name as drop only. IF not change it.
#$Source = "\\Share"

#create primary region storage context
$ctx = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

#Check for Share Existence
$S = Get-AzureStorageShare -Context $ctx -ErrorAction Stop | Where-Object {$_.Name -eq $AzureShare}

if (!$S.Name)
{
    # create a new share
    $s = New-AzureStorageShare $AzureShare -Context $ctx
}

# Check for directory
$d = Get-AzureStorageFile -Share $s -ErrorAction Stop | Select-Object Name

if ($d.Name -notcontains $AzureDirectory)
{
    # create a directory in the share
    $d = New-AzureStorageDirectory -Share $s -Path $AzureDirectory
}

# get all the folders in the source directory
$Folders = Get-ChildItem -Path $Source -Directory -Recurse

$S = Get-AzureStorageShare -Name $AzureShare -Context $ctx

foreach($Folder in $Folders)
{
    $f = ($Folder.FullName).Substring(($source.Length))
    
    $Path = $AzureDirectory + $f
    
    # create a directory in the share for each folder
    New-AzureStorageDirectory -Share $s -Path $Path -ErrorAction Stop
}

#Get all the files in the source directory
$files = Get-ChildItem -Path $Source -Recurse -File

foreach($File in $Files)
{
    $f = ($file.FullName).Substring(($Source.Length))
    $Path = $AzureDirectory + $f
    
    #upload the files to the storage
    if($Confirm)
    {
        Set-AzureStorageFileContent -Share $s -Source $File.FullName -Path $Path -Confirm
    }
    else
    {
        Set-AzureStorageFileContent -Share $s -Source $File.FullName -Path $Path -Force
    }
}