Try
{
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name PSWindowsUpdate -Force
Import-Module -Name PSWindowsUpdate
Install-WindowsUpdate -AcceptAll -IgnoreReboot
write-host "Stage: windowsupdate_initiate completed" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windowsupdate_followup'
Set-Runonce
Stop-Transcript
Restart-Computer
}
catch
{
write-host "Stage: windowsupdate_initiate Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value windowsupdate_initiate
Set-Runonce
Stop-Transcript
Pause
}
