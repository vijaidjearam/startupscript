while (!(test-connection 8.8.8.8 -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor Red  "Internet Connection down..."
    sleep 5
}
write-host "internet connection is up! -> proceeding with the script" -ForegroundColor Green
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
        #$Command = "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass ; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
        $Command = "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass ; $env:Temp\header.ps1"
  
    ) 
function Test-RegistryValue {

param (

 [parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Path,

[parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Value
)

try {

Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
 return $true
 }

catch {

return $false

}

}

    
    if (Test-RegistryValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Value $keyname)
    {
         Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name $KeyName -Value $Command -Type ExpandString -Force
        
    }
    else
    {
       New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name $KeyName -PropertyType ExpandString -Value $Command
       write-host "$Command set to registry runonce" -ForegroundColor Green
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
((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/registryrunonce.ps1')) | Out-File $env:TEMP\header.ps1
Stop-Transcript
}

Switch ($stage)
{
    'dellcommandupdate_driverinstall'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/dellcommandupdate_driverinstall.ps1'))
    }
    'dellcommandupdate_applyupdates'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/dellcommandupdate_applyupdates.ps1'))
 
    }
    'dellcommandconfigure'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/dellcommandconfigure.ps1'))
    }
    'windowsupdate_initiate'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windowsupdate_initiate.ps1'))
     }
    'windowsupdate_followup'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windowsupdate_followup.ps1'))
    }
    'network_config'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/network_config.ps1'))
    }
    'chocolatey_apps'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/chocolatey_apps.ps1'))
    }
    'windows_services'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_services.ps1'))
    }
    'windows_settings'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_settings.ps1'))
   
    }
    'cleaning'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/cleaning.ps1'))
    }
}
