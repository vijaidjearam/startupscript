$WarningPreference = 'SilentlyContinue'
write-host " Installing Chocolatey"
iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1")) | Out-Null
write-host "Chocolatey Installed Successfully --------------Ok"
choco source add -n chocosia -s "http://choco.iut-troyes.univ-reims.fr/chocolatey" --priority=1 | Out-Null
write-host "Internal chocolatey configured --------------Ok"
choco source add -n chocolatey -s "https://chocolatey.org/api/v2" --priority=2 | Out-Null
write-host "chocolatey by default has been configured to priority 2 --------------Ok"
#Stage 1 - Installing chocolatey Apps-------------------------------------------------------------------------------------------------
#chocolatey_apps
windows_service
windows_settings
function chocolatey_apps{
try{
  #Stage 1 - Installing chocolatey Apps-------------------------------------------------------------------------------------------------
  write-host "Entering - Stage 1 : Installing chocolatey Package --------------Ok"
  iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/chocolatey_packages.ps1")) | Out-Null
  write-host "End Of Stage 1 -Installed chocolatey Package --------------Ok"
}
catch{write-host "Error Occured in Stage 1 Installing chocolatey Package--------------NOK"-ForeGroundColor Red}
}
function windows_service{
#Stage 2 - Configuring Windows Services------------------------------------------------------------------------------------------------
write-host "Entering - Stage 2 : Configuring Windows Services --------------Ok"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_services.ps1")) | Out-Null
write-host "End Of Stage 2 - Configured Windows Services --------------Ok"
}
function windows_settings{
#Stage 3 - Configuring Windows Settings --------------------------------------------------------------------------------------------------
write-host "Entering - Stage 3 : Configuring Windows Settings --------------Ok"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_settings.ps1")) | Out-Null
write-host "End Of Stage 3 - Configured Windows Settings --------------Ok"
}

