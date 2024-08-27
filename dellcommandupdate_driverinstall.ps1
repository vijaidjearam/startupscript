choco install dellcommandupdate -y
& "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" /configure -advancedDriverRestore=enable
& "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" /driverInstall
if($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq 1 -or $LASTEXITCODE -eq 5 -or $LASTEXITCODE -eq 500)
{
write-host "Stage: dellcommandupdate_driverinstall completed" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'dellcommandupdate_applyupdates'
Set-Runonce
Stop-Transcript
Restart-Computer
} 
else 
{
write-host "Stage: dellcommandupdate_driverinstall Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value dellcommandupdate_driverinstall
Set-Runonce
Stop-Transcript
Pause
}

