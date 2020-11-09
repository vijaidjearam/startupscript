$WarningPreference = 'SilentlyContinue'
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_settings_essentials.ps1"))
write-host "Entering Windows-settings Configuration Stage" 
$setting = @(
"set-ntpserver_urca",
"Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives",
"Set-WindowsExplorerOptions -EnableShowProtectedOSFiles",
"Set-WindowsExplorerOptions -EnableShowFileExtensions",
"Set-WindowsExplorerOptions -EnableShowFullPathInTitleBar",
"Set-WindowsExplorerOptions -DisableOpenFileExplorerToQuickAccess",
"Set-WindowsExplorerOptions -DisableShowRecentFilesInQuickAccess",
"Set-WindowsExplorerOptions -DisableShowFrequentFoldersInQuickAccess",
"Set-WindowsExplorerOptions -EnableSnapAssist",
"AllowInsecureGuestAuth" #Allow guest access to SAMBA share.
"Set-TaskbarOptions -Lock -NoAutoHide -Size Small",
"set-desktop-icon-small",
"Enable-RemoteDesktop",
"open_ports",
'Disable-ComputerRestore -Drive "c:\"',
"Set-Wsus",

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
