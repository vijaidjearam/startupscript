$WarningPreference = 'SilentlyContinue'
try
{
$repopath = Get-ItemPropertyValue -Path 'HKCU:\repopath' -Name path
iex ((New-Object System.Net.WebClient).DownloadString($repopath+'windows_settings_essentials.ps1'))
write-host "Entering Windows-settings Configuration Stage" 
$setting = @(
"set-ntpserver_urca",
#Afficher l’extension des noms de fichiers dans l’explorateur. C’est important pour le développement
"Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives",
#"Set-WindowsExplorerOptions -EnableShowProtectedOSFiles",
"Set-WindowsExplorerOptions -EnableShowFileExtensions",
"Set-WindowsExplorerOptions -EnableShowFullPathInTitleBar",
"Set-WindowsExplorerOptions -DisableOpenFileExplorerToQuickAccess",
"Set-WindowsExplorerOptions -DisableShowRecentFilesInQuickAccess",
"Set-WindowsExplorerOptions -DisableShowFrequentFoldersInQuickAccess",
"Set-WindowsExplorerOptions -EnableSnapAssist",
#Activer les accès anonymes aux partages samba
"AllowInsecureGuestAuth",
#Désactiver l’arrêt des disques durs, la mise en veille. Pour la veille prolongée/veille hybride, voici comment la désactiver pour gagner quelques gigas :
"power_config",
#Faire en sorte que la barre des tâches n’affiche que des petites icônes, pas besoin d’avoir des icônes de 48×48 de large : cela occupe l’affichage pour rien
"Set-TaskbarOptions -Lock -NoAutoHide -Size Small",
"set-desktop-icon-small",
"Enable-RemoteDesktop",
"open_ports",
"Disable_automatic_updates_of_Microsoft_Store_apps",
"Disable_Startup_Boost_Microsoft_Edge_for_All_Users",
"active_setup_components",
"enable_ntfx3",
#Désactiver la protection du système (points de restauration) : nous gagnons alors de l’espace disque. Nous avons une image qui fonctionne désormais, et il n’est pas nécessaire de conserver des points de restauration.
'Disable-ComputerRestore -Drive "c:\"',
#point windows wsus server to 10.1.1.1( its a dummy address so windows will get updates anymore)
"Set-Wsus",
#Dans les tâches planifiées, il y a des tâches qui ne servent à rien : HP Support Assistant, par exemple, vu que nous le lancerons manuellement, ainsi que la tâche de défragmentation, mises à jour Google, ou encore l’OfficeTelemetryAgent (mouchard d’Office). Donc effacer/désactiver celles qui ne servent à rien 
"disable-scheduledtasks",
#A titre d’exemple de simplification de la UI, aller dans les paramètres avancés,sélectionner « Ajuster pour obtenir les meilleures performances pour lesprogrammes » et cochez dans la liste dessous « Afficher des miniatures au lieu d’icônes », ainsi que « Lisser les polices d’écran ».
"performance_options_visual_effects",
#disable news and interests in taskbar
"dontdisplaynewsaninterestsintaskbar",
#pin office apps shortcut to taskbar
"pin-to-taskbar",
#Apply google chrome policy settings
"googlechrome-policy",
# Disable Google Chrome Turn on ad privacy feature, source: https://github.com/letsdoautomation/powershell
"DisableGoogleChromeTurnOnAdPrivacyFeature",
#Disable Microsoft Edge first run wizard
"DisableMicrosoftEdgeFirstRunWizard",
# Change default Google Chrome search provider
"ChangeDefaultGoogleChromeSearchProviderandskipbrowsersignin",
# Set-default file associations
"set-file_associations"
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
write-host "Stage: windows_settings completed" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windows_debloat'
Set-Runonce
Stop-Transcript
Restart-Computer
}
catch
{
write-host "Stage: windows_settings Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value windows_settings
Set-Runonce
Stop-Transcript
Pause

}

