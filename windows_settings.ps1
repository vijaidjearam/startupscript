$WarningPreference = 'SilentlyContinue'
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_settings_essentials.ps1"))
write-host "Entering Windows-settings Configuration Stage" 
$setting = @(
"Set-TaskbarOptions -Size Small",
"Enable-RemoteDesktop",
"set-ntpserver_urca",
"open_ports",
"Show-HiddenFile",
"Show-FileExtensions",
"AllowInsecureGuestAuth" #Allow guest access to SAMBA share.
)

$setting | foreach {
try{
Invoke-Expression $_ |Out-Null
write-host $_ "---------------------OK" -ForegroundColor Green
}
catch{
write-host  ""
write-host $_ "--------------Nok" -ForegroundColor Red
}
}
