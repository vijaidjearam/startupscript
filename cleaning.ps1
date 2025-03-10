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
function dontdisplaylastusername-on-logon{
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name dontdisplaylastusername -Value 1 -Force
}
# Turn On or Off Use sign-in info to auto finish setting up device after update or restart in Windows 10
function disableautosignin-info{
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name DisableAutomaticRestartSignOn -Value 1 -Force
}

function disable-autologon{
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoAdminLogon -Value 0 -Force
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultDomainName -Force
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultUserName -Force
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0 -Force
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonSID -Value 0 -Force
#Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultPassword -Force
}
function dontdisplaylastusername-on-logon{
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name dontdisplaylastusername -Value 1 -Force
}

function clear-eventlogs{
Write-host "Cleaning Event Log" 
Get-EventLog -LogName * | ForEach { Clear-EventLog $_.Log }
Write-host "Completed Cleaning Event Log" 
}

try
{
if (test-path C:\Windows\Setup\Scripts\SetupComplete.cmd){Remove-Item 'C:\Windows\Setup\Scripts\SetupComplete.cmd'}
iex CleanWinSXS
Remove-Item -Path HKCU:\osinstall_local
Remove-Item -Path HKCU:\repopath
#dell command update pops up message in the taskbar if there is new driver updates, inspite of setting it to manual schedule update. 
#so uninstall dell command update , if required it can be installed anytime using chocolatey.
choco uninstall dellcommandupdate -y
#installing kaspersky at the end so that it doesnt block the script at the start up
#choco install f-secure -y
#choco install f-secure-autonome -y
choco source remove -n=chocolatey
# iex dontdisplaylastusername-on-logon
iex disableautosignin-info
iex disable-autologon
# Reset Administrator password to Blank
Set-LocalUser -name Administrateur -Password ([securestring]::new())
iex dontdisplaylastusername-on-logon
Stop-Transcript
Write-host "The Next step is going to clear Temp File and eventlogs, check the log file for any error message and then continue: "
Pause
iex DeleteTempFiles
iex clear-eventlogs
write-host "Stage: cleaning completed" -ForegroundColor Green

}
catch
{
write-host "Stage: cleaning Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value cleaning
$repopath = Get-ItemPropertyValue -Path 'HKCU:\osinstall_local' -Name repopath
$repo = $repopath+'header.ps1'
Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass ; iex ((New-Object System.Net.WebClient).DownloadString($repo))"
Stop-Transcript
Pause
}
