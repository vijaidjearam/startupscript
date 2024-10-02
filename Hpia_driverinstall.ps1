start-process -FilePath c:\hp\hpia\Hpimageassistant.exe -ArgumentList "/auto /Noninteractive /AutoCleanup" -wait

if($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq 1 -or $LASTEXITCODE -eq 5 -or $LASTEXITCODE -eq 500)
{
write-host "Stage: HP Image Assist -Driver Install completed" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'chocolatey_apps'
Set-Runonce
Stop-Transcript
Restart-Computer
} 
else 
{
write-host "Stage: HP Image Assist -Driver Install Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'Hpia_driverinstall'
Set-Runonce
Stop-Transcript
Pause
}
