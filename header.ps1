$repopath = Get-ItemPropertyValue -Path 'HKCU:\repopath' -Name path
iex ((New-Object System.Net.WebClient).DownloadString($repopath+"windows_settings_essentials.ps1"))
$WarningPreference = 'SilentlyContinue'

# Change the name of the pc to IUT-serialnumber
Invoke-Expression renamepcwithserialnumber

if (test-path 'HKCU:\osinstall_local'){
$stage = Get-ItemPropertyValue -Path 'HKCU:\osinstall_local' -Name stage
}
else{
$FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss") + "_initial-stage_transcript.txt"
Start-Transcript -path $FileName -NoClobber
# need to load power config settings for long process like windows update, so that the system doesnt goes to sleep mode during windows update.
Invoke-Expression power_config |Out-Null 
write-host " Installing Chocolatey" 
#iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1")) | Out-Null
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
write-host "Chocolatey Installed Successfully --------------Ok"
write-host "adding chocolatey internal server address to host file --------------Ok"
choco source add -n chocosia -s "http://choco.local.iut-troyes.univ-reims.fr/repository/chocolatey-group/" --priority=1 | Out-Null
write-host "Internal chocolatey configured --------------Ok"
#Enabling insecure guest logons for accessing network shares anonymously
try{
Invoke-Expression AllowInsecureGuestAuth
if (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation)
{
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation -Name AllowInsecureGuestAuth -Value 1 -Force
}
else
{
New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name LanmanWorkstation -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation -Name AllowInsecureGuestAuth -Value 1 -Force
}
write-host "AllowInsecureGuestAuth-----OK" -ForegroundColor Green
}
catch{
write-host  ""
write-host  "AllowInsecureGuestAuth-----Nok" -ForegroundColor Red
}

New-Item -Path "HKCU:\" -Name osinstall_local
$manufacturer = (Get-CimInstance -ClassName win32_computersystem | Select-Object Manufacturer).Manufacturer
if ($manufacturer -like '*dell*')
{
write-host "System manufacturer has been detected as Dell - so proceeding with Dell driver update" -ForegroundColor Green
New-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'dellcommandupdate_driverinstall'
}
elseif ($manufacturer -like '*hp*')
{
write-host "System manufacturer has been detected as HP - so proceeding with Dell driver update" -ForegroundColor Green
New-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'hpia_install'
}
else
{
write-host "System manufacturer is not Dell or HP - so proceeding with installing Chocolatey Apps" -ForegroundColor Green
New-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'chocolatey_apps'
}

$stage = Get-ItemPropertyValue -Path 'HKCU:\osinstall_local' -Name stage
((New-Object System.Net.WebClient).DownloadString($repopath+'registryrunonce.ps1')) | Out-File $env:TEMP\header.ps1
Stop-Transcript
}

Switch ($stage)
{
    'dellcommandupdate_driverinstall'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString($repopath+'dellcommandupdate_driverinstall.ps1'))
    }
    'dellcommandupdate_applyupdates'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString($repopath+'dellcommandupdate_applyupdates.ps1'))
 
    }
    'dellcommandconfigure'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString($repopath+'dellcommandconfigure.ps1'))
    }
    'hpia_install'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString($repopath+'hpia_install.ps1'))
    }
    'Hpia_driverinstall'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString($repopath+'Hpia_driverinstall.ps1'))
    }
    'chocolatey_apps'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        #$FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        #Start-Transcript -path $FileName -NoClobber
        ((New-Object System.Net.WebClient).DownloadString($repopath+"chocolatey.ps1")) | Out-File $env:TEMP\chocolatey.ps1
        ((New-Object System.Net.WebClient).DownloadString($repopath+"chocolatey-apps.txt"))| Out-File $env:TEMP\chocolatey-apps.txt
        powershell.exe -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\chocolatey.ps1 -preset $env:TEMP\chocolatey-apps.txt
    }
    'windowsupdate_initiate'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString($repopath+'windowsupdate_initiate.ps1'))
     }
    'windowsupdate_followup'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString($repopath+'windowsupdate_followup.ps1'))
    }
    'windows_services'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString($repopath+'windows_services.ps1'))
    }
    'windows_settings'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString($repopath+'windows_settings.ps1'))
   
    }
    'windows_debloat'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        ((New-Object System.Net.WebClient).DownloadString($repopath+"win10_debloat.ps1")) | Out-File $env:TEMP\win10_debloat.ps1
        ((New-Object System.Net.WebClient).DownloadString($repopath+"win10_debloat.psm1"))| Out-File $env:TEMP\win10_debloat.psm1
        ((New-Object System.Net.WebClient).DownloadString($repopath+"debloat_preset.txt"))| Out-File $env:TEMP\debloat_preset.txt
        powershell.exe -NoProfile -ExecutionPolicy Bypass -File $env:TEMP\win10_debloat.ps1 -include $env:TEMP\win10_debloat.psm1 -preset $env:TEMP\debloat_preset.txt
        write-host "Stage: windows_debloat completed" -ForegroundColor Green
        Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'cleaning'
        Set-Runonce
        Stop-Transcript
        Restart-Computer
    }
    'cleaning'
    {
        write-host "Entering Stage: $stage" -ForegroundColor Green
        $FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_"+ $stage+"_transcript.txt"
        Start-Transcript -path $FileName -NoClobber
        iex ((New-Object System.Net.WebClient).DownloadString($repopath+'cleaning.ps1'))
    }
}
