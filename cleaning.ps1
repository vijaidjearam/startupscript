# Delete Temp Files
Function DeleteTempFiles {
    Write-Host "Cleaning up temporary files..."
    $tempfolders = @("C:\Windows\Temp\*", "C:\Windows\Prefetch\*", "C:\Documents and Settings\*\Local Settings\temp\*", "C:\Users\*\Appdata\Local\Temp\*")
    Remove-Item $tempfolders -force -recurse 2>&1 | Out-Null
}

# Clean WinSXS folder (WARNING: this takes a while!)
Function CleanWinSXS {
    Write-Host "Cleaning WinSXS folder, this may take a while, please wait..."
    Dism.exe /online /Cleanup-Image /StartComponentCleanup
}

try
{
if (test-path C:\Windows\Setup\Scripts\SetupComplete.cmd){Remove-Item 'C:\Windows\Setup\Scripts\SetupComplete.cmd'}
Write-host "Cleaning Event Log" 
Get-EventLog -LogName * | ForEach { Clear-EventLog $_.Log }
Write-host "Completed Cleaning Event Log" 
iex CleanWinSXS
Write-host "The Next step is going to clear Temp File, check the log file for any error message and then continue: "
Pause
iex DeleteTempFiles
write-host "Stage: cleaning completed" -ForegroundColor Green
Remove-Item -Path HKCU:\osinstall_local
Stop-Transcript
}
catch
{
write-host "Stage: cleaning Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value cleaning
Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass ; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
Stop-Transcript
Pause
}
