function Set-RunOnce
  <#
      .SYNOPSIS
      Sets a Runonce-Registry Key
 
      .DESCRIPTION
      Sets a Runonce-Key in the Computer-Registry. Every Program which will be added will run once at system startup.
      This Command can be used to configure a computer at startup.
 
      .EXAMPLE
      Set-Runonce -command '%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -file c:\Scripts\start.ps1'
      Sets a Key to run Powershell at startup and execute C:\Scripts\start.ps1
 
      .NOTES
      Author: Holger Voges
      Version: 1.0
      Date: 2018-08-17
 
      .LINK
      https://www.netz-weise-it.training/
  #>
{
    [CmdletBinding()]
    param
    (
        #The Name of the Registry Key in the Autorun-Key.
        [string]
        $KeyName = 'Run',

        #Command to run
        [string]
        $Command = '%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -file c:\Scripts\run1.ps1'
  
    ) 

    
    if (-not ((Get-Item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce).$KeyName ))
    {
        New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name $KeyName -Value $Command -PropertyType ExpandString
    }
    else
    {
        Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name $KeyName -Value $Command -PropertyType ExpandString
    }
}
$WarningPreference = 'SilentlyContinue'
write-host " Installing Chocolatey"
iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1")) | Out-Null
write-host "Chocolatey Installed Successfully --------------Ok"
write-host "adding chocolatey internal server address to host file --------------Ok"
choco source add -n chocosia -s "http://choco.local.iut-troyes.univ-reims.fr/repository/chocolatey-group/" --priority=1 | Out-Null
write-host "Internal chocolatey configured --------------Ok"
choco install dellcommandupdate -y
$FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss") + "_dellcommandupdate_driverinstall_transcript.txt"
Start-Transcript -path $FileName -NoClobber
if (test-path "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe")
try
{
& "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" /driverInstall
Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/dellcommandupdate_applyupdates.ps1'))"
Stop-Transcript
Restart-Computer

}
catch
{
write-host "Dell command update failed" -ForegroundColor Red
Stop-Transcript
}

