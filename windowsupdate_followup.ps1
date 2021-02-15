function Set-Wsus{
if(!(Test-Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate)){
New-Item -Path HKLM:\Software\Policies\Microsoft\Windows -Name WindowsUpdate
}
New-Item -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name AU
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name AcceptTrustedPublisherCerts -Value 1 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name DisableWindowsUpdateAccess -Value 1 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name ElevateNonAdmins -Value 0 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name TargetGroup -Value "workgroup" -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name TargetGroupEnabled -Value 0 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name WUServer -Value "http:\\10.1.1.1" -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name WUStatusServer -Value "http:\\10.1.1.1" -Force
#New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name NoWindowsUpdate -Value 1 -Force
#New-ItemProperty -Path "HKLM:\SYSTEM\Internet Communication Management\Internet Communication" -Name DisableWindowsUpdateAccess -Value 1 -Force
#New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate -Name DisableWindowsUpdateAccess -Value 1 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name AUOptions -Value 5 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name AutoInstallMinorUpdates -Value 0 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name DetectionFrequencyEnabled -Value 0 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name NoAutoRebootWithLoggedOnUsers -Value 1 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name NoAutoUpdate -Value 1 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name RebootRelaunchTimeout -Value 1440 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name RebootWarningTimeout -Value 30 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name RescheduleWaitTimeEnabled -Value 0 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU -Name UseWUServer -Value 1 -Force
}

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

$FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss") + "_windowsupdate_transcript.txt"
Start-Transcript -path $FileName -NoClobber

Import-Module -Name PSWindowsUpdate
Install-WindowsUpdate -AcceptAll

if (Get-WURebootStatus -silent){
	Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windowsupdate_followup.ps1'))"
	Stop-Transcript
	Restart-Computer
}
else{
#Mettre l’@IP du serveur WSUS sur le poste, et DESACTIVER TOUTES LES MISES A JOUR AUTOMATIQUES
write-host "Windows update initiate process -Completed - no Reboot required - so proceeding with further configuration" -ForegroundColor Green
Set-Wsus
Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
Stop-Transcript
}
