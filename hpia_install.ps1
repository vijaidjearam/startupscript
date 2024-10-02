choco install hpia -y
if($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq 1 -or $LASTEXITCODE -eq 5 -or $LASTEXITCODE -eq 500)
{
write-host "Stage: dellcommandupdate_driverinstall completed" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'Hpia_driverinstall'
Set-Runonce
Stop-Transcript
Restart-Computer
} 
else 
{
write-host "Stage: dellcommandupdate_driverinstall Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'hpia_install'
Set-Runonce
Stop-Transcript
Pause
}
