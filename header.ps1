iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windows_settings_essentials.ps1"))
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
