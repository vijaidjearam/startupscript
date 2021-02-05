$WarningPreference = 'SilentlyContinue'
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_settings_essentials.ps1"))
write-host "Entering Windows-settings Configuration Stage" 
$setting = @(
"set-ntpserver_urca",
#Afficher l’extension des noms de fichiers dans l’explorateur. C’est important pour le développement
"Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives",
"Set-WindowsExplorerOptions -EnableShowProtectedOSFiles",
"Set-WindowsExplorerOptions -EnableShowFileExtensions",
"Set-WindowsExplorerOptions -EnableShowFullPathInTitleBar",
"Set-WindowsExplorerOptions -DisableOpenFileExplorerToQuickAccess",
"Set-WindowsExplorerOptions -DisableShowRecentFilesInQuickAccess",
"Set-WindowsExplorerOptions -DisableShowFrequentFoldersInQuickAccess",
"Set-WindowsExplorerOptions -EnableSnapAssist",
#Activer les accès anonymes aux partages samba
"AllowInsecureGuestAuth" 
#Désactiver l’arrêt des disques durs, la mise en veille. Pour la veille prolongée/veille hybride, voici comment la désactiver pour gagner quelques gigas :
"power_config",
#Faire en sorte que la barre des tâches n’affiche que des petites icônes, pas besoin d’avoir des icônes de 48×48 de large : cela occupe l’affichage pour rien
"Set-TaskbarOptions -Lock -NoAutoHide -Size Small",
"set-desktop-icon-small",
"Enable-RemoteDesktop",
"open_ports",
#Désactiver la protection du système (points de restauration) : nous gagnons alors de l’espace disque. Nous avons une image qui fonctionne désormais, et il n’est pas nécessaire de conserver des points de restauration.
'Disable-ComputerRestore -Drive "c:\"',
#Mettre l’@IP du serveur WSUS sur le poste, et DESACTIVER TOUTES LES MISES A JOUR AUTOMATIQUES
"Set-Wsus"
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
#Dans les tâches planifiées, il y a des tâches qui ne servent à rien : HP Support Assistant, par exemple, vu que nous le lancerons manuellement, ainsi que la tâche de défragmentation, mises à jour Google, ou encore l’OfficeTelemetryAgent (mouchard d’Office). Donc effacer/désactiver celles qui ne servent à rien 
Get-ScheduledTask -TaskName \"*google*\" | Disable-ScheduledTask
Get-ScheduledTask -TaskName \"*MicrosoftEdgeupdate*\" | Disable-ScheduledTask
Get-ScheduledTask -TaskName \"*Nvidia*\" | Disable-ScheduledTask
Get-ScheduledTask -TaskName \"*Ccleaner*\" | Disable-ScheduledTask
Get-ScheduledTask -TaskName \"*OfficeTelemetryAgent*\" | Disable-ScheduledTask
Get-ScheduledTask -TaskName consolidator | Disable-ScheduledTask
Get-ScheduledTask -TaskName UsbCeip | Disable-ScheduledTask
Get-ScheduledTask -TaskName "Microsoft Compatibility Appraiser" | Disable-ScheduledTask
Get-ScheduledTask -TaskName "ProgramDataUpdater" | Disable-ScheduledTask
Get-ScheduledTask -TaskName Microsoft-Windows-DiskDiagnosticDataCollector | Disable-ScheduledTask
Get-ScheduledTask -TaskName Microsoft-Windows-DiskDiagnosticResolver | Disable-ScheduledTask
Get-ScheduledTask -TaskName "Scheduled Start"| Disable-ScheduledTask
#A titre d’exemple de simplification de la UI, aller dans les paramètres avancés,sélectionner « Ajuster pour obtenir les meilleures performances pour lesprogrammes » et cochez dans la liste dessous « Afficher des miniatures au lieu d’icônes », ainsi que « Lisser les polices d’écran ».
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects -Name VisualFXSetting -Value 3
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name UserPreferencesMask -Value "90 12 03 80 10 00 00 00"

