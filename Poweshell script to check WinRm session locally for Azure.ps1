$netbios = "xyz"
$username = "DevAdmin"
$password = password
$fqdn = "xyz.westeurope.cloudapp.azure.com"$machineuser = $netbios + '\' + $username
$secpasswd = ConvertTo-SecureString "$password" -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("$machineuser", $secpasswd)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck
$s = New-PSSession -ComputerName $fqdn -Credential $creds -UseSSL -SessionOption $so
$s = Get-PSSession
 
if ($s)
{
    Remove-PSSession -Session $s
}
 
Get-PSSession$netbios = "xyz"
$username = "DevAdmin"
$password = password
$fqdn = "xyz.westeurope.cloudapp.azure.com"$machineuser = $netbios + '\' + $username
$secpasswd = ConvertTo-SecureString "$password" -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("$machineuser", $secpasswd)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck
$s = New-PSSession -ComputerName $fqdn -Credential $creds -UseSSL -SessionOption $so
$s = Get-PSSession
 
if ($s)
{
    Remove-PSSession -Session $s
}
 
Get-PSSession