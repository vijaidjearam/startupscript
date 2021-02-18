try
{
& "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates
write-host "Stage: dellcommandupdate_applyupdates completed" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'dellcommandconfigure'
Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
Stop-Transcript
Restart-Computer
}
catch
{
write-host "Stage: $stage Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value dellcommandupdate_applyupdates
Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
Stop-Transcript
}

