$ipaddr = ((Test-NetConnection).SourceAddress).IPAddress
$interfaceindex = (get-NetIPAddress -IPAddress $ipaddr).ifIndex
Set-DnsClientServerAddress -InterfaceIndex $interfaceindex -ResetServerAddresses
