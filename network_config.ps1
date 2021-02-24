Try
{

$ipaddr = ((Test-NetConnection).SourceAddress).IPAddress
$interfaceindex = (get-NetIPAddress -IPAddress $ipaddr).ifIndex
$DNS1 = ""
$DNS2 = ""
$DNS3 = ""
Set-DnsClient -InterfaceIndex $interfaceindex -UseSuffixWhenRegistering 0
Set-DnsClient -InterfaceIndex $interfaceindex -RegisterThisConnectionsAddress 1
Set-DnsClientServerAddress -InterfaceIndex $interfaceindex -ServerAddresses ($DNS1,$DNS2,$DNS3)
Set-DnsClientGlobalSetting -SuffixSearchList @("", "")
Set-DnsClient -InterfaceIndex $interfaceindex -ConnectionSpecificSuffix ""
write-host "Restarting Network Adapter" -ForegroundColor DarkGreen
$adapter = Get-CimInstance -ClassName Win32_NetworkAdapter | where {$_.InterfaceIndex -eq $interfaceindex}
Disable-NetAdapter -Name $adapter.NetConnectionID -Confirm:$false
Enable-NetAdapter -Name $adapter.NetConnectionID -Confirm:$false
write-host "Stage: network_config completed" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'chocolatey_apps'
Set-Runonce
Stop-Transcript
Restart-Computer
}
catch
{
write-host "Stage: network_config Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'network_config'
Set-Runonce
Stop-Transcript
Pause
}
