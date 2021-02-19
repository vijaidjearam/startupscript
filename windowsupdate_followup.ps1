Try
{

Import-Module -Name PSWindowsUpdate
Install-WindowsUpdate -AcceptAll -IgnoreReboot
write-host "Stage: windowsupdate_followup completed" -ForegroundColor Green
if (Get-WURebootStatus -silent){
write-host "Stage: windowsupdate_followup completed but requires a reboot , the system will reboot and check if there is any further windows update" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windowsupdate_followup'
 }
else {Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'network_config'}
Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
Stop-Transcript
Restart-Computer
}

catch
{
write-host "Stage: windowsupdate_followup Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value windowsupdate_followup
Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
Stop-Transcript
}

