try{
$ipaddr = ((Test-NetConnection).SourceAddress).IPAddress
$interfaceindex = (get-NetIPAddress -IPAddress $ipaddr).ifIndex
$DNS1 = "10.57.8.88"
$DNS2 = "10.5.12.204"
$DNS3 = "10.5.13.204"
Set-DnsClient -InterfaceIndex $interfaceindex -UseSuffixWhenRegistering 0
Set-DnsClient -InterfaceIndex $interfaceindex -RegisterThisConnectionsAddress 1
Set-DnsClientServerAddress -InterfaceIndex $interfaceindex -ServerAddresses ($DNS1,$DNS2,$DNS3)
Set-DnsClientGlobalSetting -SuffixSearchList @("ad-urca.univ-reims.fr", "univ-reims.fr")
Set-DnsClient -InterfaceIndex $interfaceindex -ConnectionSpecificSuffix "ad-urca.univ-reims.fr"
write-host "Restarting Network Adapter" -ForegroundColor DarkGreen
$adapter = Get-CimInstance -ClassName Win32_NetworkAdapter | where {$_.InterfaceIndex -eq $interfaceindex}
Disable-NetAdapter -Name $adapter.NetConnectionID -Confirm:$false
Enable-NetAdapter -Name $adapter.NetConnectionID -Confirm:$false
}
catch{
Write-Error "Unable to connect to the internet- please check internet connection and try again"
}
