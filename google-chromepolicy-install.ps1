((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/googlechrome-policy.ps1')) | Out-File $env:TEMP\googlechrome-policy.ps1
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
. $env:TEMP\googlechrome-policy.ps1 
