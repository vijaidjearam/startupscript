$WarningPreference = 'SilentlyContinue'
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_settings_essentials.ps1"))
write-host "Entering Windows-settings Configuration Stage" 
$setting = @(
"Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives",
"Set-WindowsExplorerOptions -EnableShowProtectedOSFiles",
"Set-WindowsExplorerOptions -EnableShowFileExtensions",
"Set-WindowsExplorerOptions -EnableShowFullPathInTitleBar",
"Set-WindowsExplorerOptions -DisableOpenFileExplorerToQuickAccess",
"Set-WindowsExplorerOptions -DisableShowRecentFilesInQuickAccess",
"Set-WindowsExplorerOptions -DisableShowFrequentFoldersInQuickAccess",
"Set-WindowsExplorerOptions -EnableSnapAssist",
"Set-TaskbarOptions -Lock -NoAutoHide -Size Small",
"set-desktop-icon-small",
"Enable-RemoteDesktop",
"set-ntpserver_urca",
"open_ports",

'Disable-ComputerRestore -Drive "c:\"',
"Set-Wsus",
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
