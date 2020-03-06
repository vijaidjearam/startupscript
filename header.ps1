$WarningPreference = 'SilentlyContinue'
write-host " Installing Chocolatey"
iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1")) | Out-Null
write-host "Chocolatey Installed Successfully --------------Ok"
choco source add -n chocosia -s "http://choco.iut-troyes.univ-reims.fr/chocolatey" --priority=1 | Out-Null
write-host "Internal chocolatey configured --------------Ok"
choco source add -n chocolatey -s "https://chocolatey.org/api/v2" --priority=2 | Out-Null
write-host "chocolatey by default has been configured to priority 2 --------------Ok"
#Stage 1 - Installing chocolatey Apps
try{
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/chocolatey_packages.ps1")) | Out-Null
write-host "Stage 1 Installing chocolatey Package --------------Ok"
}
catch{write-host "Error Occured in Stage 1 Installing chocolatey Package--------------NOK"-ForeGroundColor Red}
Pause

