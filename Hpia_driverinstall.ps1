$proc = (start-process -FilePath c:\hp\hpia\Hpimageassistant.exe -ArgumentList "/auto /Noninteractive /AutoCleanup" -wait -PassThru)
# https://ftp.hp.com/pub/caps-softpaq/cmit/whitepapers/HPIAUserGuide.pdf
if($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 256 -or $proc.ExitCode -eq 257 -or $proc.ExitCode -eq 3010)
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
