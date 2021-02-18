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

    
    if ((Get-Item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce).$KeyName)
    {
        New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name $KeyName -Value $Command -PropertyType ExpandString
    }
    else
    {
        Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name $KeyName -Value $Command 
    }
}
$WarningPreference = 'SilentlyContinue'

if (test-path 'HKCU:\osinstall_local'){
$stage = Get-ItemPropertyValue -Path 'HKCU:\osinstall_local' -Name stage
}
else{
$FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss") + "_initial-stage_transcript.txt"
Start-Transcript -path $FileName -NoClobber
write-host " Installing Chocolatey" 
iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1")) | Out-Null
write-host "Chocolatey Installed Successfully --------------Ok"
write-host "adding chocolatey internal server address to host file --------------Ok"
choco source add -n chocosia -s "http://choco.local.iut-troyes.univ-reims.fr/repository/chocolatey-group/" --priority=1 | Out-Null
write-host "Internal chocolatey configured --------------Ok"
New-Item -Path "HKCU:\" -Name osinstall_local
New-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'dellcommandupdate_driverinstall'
$stage = Get-ItemPropertyValue -Path 'HKCU:\osinstall_local' -Name stage
Stop-Transcript
}

Switch ($stage)
{
    'dellcommandupdate_driverinstall'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        try
            {
            iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/dellcommandupdate_driverinstall.ps1'))
            write-host "Stage: $stage completed" -ForegroundColor Green
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'dellcommandupdate_applyupdates'
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            Restart-Computer
            }
        catch
            {
            write-host "Stage: $stage Failed" -ForegroundColor Red
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value $stage
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            }
        
    }
    'dellcommandupdate_applyupdates'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        try
            {
            iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/dellcommandupdate_applyupdates.ps1'))
            write-host "Stage: $stage completed" -ForegroundColor Green
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'dellcommandconfigure'
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            Restart-Computer
            }
        catch
            {
            write-host "Stage: $stage Failed" -ForegroundColor Red
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value $stage
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            }
        
    }
    'dellcommandconfigure'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        try
            {
            iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/dellcommandconfigure.ps1'))
            write-host "Stage: $stage completed" -ForegroundColor Green
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windowsupdate_initiate'
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            Restart-Computer
            }
        catch
            {
            write-host "Stage: $stage Failed" -ForegroundColor Red
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value $stage
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            }
        
    }
    'windowsupdate_initiate'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        try
            {
            iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windowsupdate_initiate.ps1'))
            write-host "Stage: $stage completed" -ForegroundColor Green
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windowsupdate_followup'
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            Restart-Computer
            }
        catch
            {
            write-host "Stage: $stage Failed" -ForegroundColor Red
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value $stage
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            }
        
    }
    'windowsupdate_followup'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        try
            {
            iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windowsupdate_followup.ps1'))
            write-host "Stage: $stage completed" -ForegroundColor Green
            if (Get-WURebootStatus -silent){
                write-host "Stage: $stage completed but requires a reboot , the system will reboot and check if there is any further windows update" -ForegroundColor Green
                Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windowsupdate_followup'
                }
            else {Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'network_config'}
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            Restart-Computer
            }
        catch
            {
            write-host "Stage: $stage Failed" -ForegroundColor Red
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value $stage
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            }
        
    }
    'network_config'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        try
            {
            iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/network_config.ps1'))
            write-host "Stage: $stage completed" -ForegroundColor Green
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'chocolatey_apps'
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            Restart-Computer
            }
        catch
            {
            write-host "Stage: $stage Failed" -ForegroundColor Red
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value $stage
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            }
        
    }
    'chocolatey_apps'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        try
            {
            iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/chocolatey_apps.ps1'))
            write-host "Stage: $stage completed" -ForegroundColor Green
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windows_services'
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            Restart-Computer
            }
        catch
            {
            write-host "Stage: $stage Failed" -ForegroundColor Red
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value $stage
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            }
        
    }
    'windows_services'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        try
            {
            iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_services.ps1'))
            write-host "Stage: $stage completed" -ForegroundColor Green
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windows_settings'
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            Restart-Computer
            }
        catch
            {
            write-host "Stage: $stage Failed" -ForegroundColor Red
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value $stage
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            }
        
    }
    'windows_settings'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        try
            {
            iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_settings.ps1'))
            write-host "Stage: $stage completed" -ForegroundColor Green
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'cleaning'
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            Restart-Computer
            }
        catch
            {
            write-host "Stage: $stage Failed" -ForegroundColor Red
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value $stage
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            }
        
    }
    'cleaning'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        try
            {
            iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/cleaning.ps1'))
            write-host "Stage: $stage completed" -ForegroundColor Green
            Stop-Transcript

            }
        catch
            {
            write-host "Stage: $stage Failed" -ForegroundColor Red
            Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value $stage
            Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
            Stop-Transcript
            }
        
    }
}
