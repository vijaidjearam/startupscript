Try
{
Import-Module -Name PSWindowsUpdate
$temp = Get-WindowsUpdate
if ($temp.Count -gt 0)
{
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windowsupdate_followup'
Set-Runonce
Install-WindowsUpdate -AcceptAll -AutoReboot
write-host "Stage: windowsupdate_followup completed" -ForegroundColor Green
Stop-Transcript
Restart-Computer
}
else {
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windows_services'
Set-Runonce
Stop-Transcript
Restart-Computer
}
}

catch
{
write-host "Stage: windowsupdate_followup Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value windowsupdate_followup
Set-Runonce
Stop-Transcript
Pause
}

