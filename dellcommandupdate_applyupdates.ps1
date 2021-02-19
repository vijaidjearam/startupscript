& "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates

if($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq 1 -or $LASTEXITCODE -eq 5 -or $LASTEXITCODE -eq 500)
{
write-host "Stage: dellcommandupdate_applyupdates completed" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'dellcommandconfigure'
Set-Runonce
Stop-Transcript
Restart-Computer
} 
else 
{
write-host "Stage: dellcommandupdate_applyupdates Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value dellcommandupdate_applyupdates
Set-Runonce
Stop-Transcript
Pause
}
