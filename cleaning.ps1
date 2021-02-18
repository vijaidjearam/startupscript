$ErrorActionPreference = Stop
try
{
if (test-path C:\Windows\Setup\Scripts\SetupComplete.cmd){Remove-Item 'C:\Windows\Setup\Scripts\SetupComplete.cmd'}
Write-host "Cleaning Event Log" 
Get-EventLog -LogName * | ForEach { Clear-EventLog $_.Log }
Write-host "Completed Cleaning Event Log" 
write-host "Stage: cleaning completed" -ForegroundColor Green
Remove-Item -Path HKCU:\osinstall_local
Stop-Transcript
}
catch
{
write-host "Stage: cleaning Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value cleaning
Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
Stop-Transcript

}
