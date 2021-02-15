$WarningPreference = 'SilentlyContinue'
$FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss") + "_transcript.txt"
Start-Transcript -path $FileName -NoClobber
#Stage 1 - Installing chocolatey Apps-------------------------------------------------------------------------------------------------
$stages =@(
"network",
"chocolatey_apps",
"windows_service",
"windows_settings",
"cleaning"
)
function network{
  #Stage 1 - Configuring Network Parameters-------------------------------------------------------------------------------------------------
  write-host "Entering - Stage 1 : Configuring Network Parameters --------------Ok"
  iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/network.ps1")) | Out-Null
  write-host "End Of Stage 1 -Configured Network Parameters --------------Ok"
   write-host "Waiting For 30 seconds for the network card to restart --------------Ok"
  start-sleep -Seconds 30
}
function chocolatey_apps{
  #Stage 1 - Installing chocolatey Apps-------------------------------------------------------------------------------------------------
  write-host "Entering - Stage 2 : Installing chocolatey Package --------------Ok"
  iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/chocolatey_packages.ps1")) | Out-Null
  write-host "End Of Stage 2 -Installed chocolatey Package --------------Ok"
}
function windows_service{
#Stage 2 - Configuring Windows Services------------------------------------------------------------------------------------------------
write-host "Entering - Stage 3 : Configuring Windows Services --------------Ok"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_services.ps1")) | Out-Null
write-host "End Of Stage 3 - Configured Windows Services --------------Ok"
}
function windows_settings{
#Stage 3 - Configuring Windows Settings --------------------------------------------------------------------------------------------------
write-host "Entering - Stage 4 : Configuring Windows Settings --------------Ok"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_settings.ps1")) | Out-Null
write-host "End Of Stage 4 - Configured Windows Settings --------------Ok"
}

function cleaning{
#Stage 3 - Cleaning files --------------------------------------------------------------------------------------------------
write-host "Entering - Stage 5 : Cleaning files created during install --------------Ok"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/cleaning.ps1")) | Out-Null
write-host "End Of Stage 5 - Cleaning files completed --------------Ok"
}
$stages | ForEach { Invoke-Expression $_ }
Stop-Transcript
Pause
