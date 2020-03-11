$WarningPreference = 'SilentlyContinue'
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_settings_essentials.ps1"))
write-host "Entering Windows-settings Configuration Stage" 
Set-TaskbarOptions -Size Small
Enable-RemoteDesktop
set-ntpserver_urca
open_ports
Set-ExplorerOptions -showHiddenFilesFoldersDrives
Set-ExplorerOptions -showProtectedOSFiles
Set-ExplorerOptions -showFileExtensions
AllowInsecureGuestAuth #Allow guest access to SAMBA share.

