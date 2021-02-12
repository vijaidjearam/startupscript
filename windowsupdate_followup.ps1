Import-Module -Name PSWindowsUpdate
Install-WindowsUpdate -AcceptAll

if (Get-WURebootStatus -silent){
	Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windowsupdate_followup.ps1'))"
	Restart-Computer
}
else{
}
