$biossetting=@(
"AcPwrRcvry=Off",
"AdminSetupLockout=Disabled",
#"Aspm=Auto",
"AutoOn=Disabled",
"AutoOSRecoveryThreshold=OFF",
"BIOSConnect=Disabled",
#"BIOSEnumMode=NativeEnum",
"BiosLogClear=Keep",
"BiosRcvrFrmHdd=Enabled",
"BlockSleep=Disabled",
"BluetoothDevice=Enabled",
#"CapsuleFirmwareUpdate=Enabled",
#"ChasIntrusion=SilentEnable",
"CpuCore=CoresAll",
"CStatesCtrl=Enabled",
"DeepSleepCtrl=Disabled",
#"DustFilter=Disabled",
"EmbNic1=EnabledPxe",
"EmbSataRaid=Ahci",
"ExtPostTime=0s",
#"FanCtrlOvrd=Disabled",
#"Fastboot=Thorough",
"ForcePxeOnNextBoot=Disabled",
"FullScreenLogo=Disabled",
"IntegratedAudio=Enabled",
"InternalSpeaker=Enabled",
#"IntlPlatformTrust=Disabled",
#"LogicProc=Enabled",
#"M2PcieSsd2=Enabled",
#"M2PcieSsd3=Enabled",
"MediaCard=Enabled",
"Microphone=Enabled",
#"MultiDisplay=Enabled",
"NumLockLed=Enabled",
"OromKeyboardAccess=Enabled",
#"OsWatchdogTimer=Disabled",
"PasswordBypass=Disabled",
"PasswordLock=Enabled",
"PowerWarn=Enabled",
#"PrimaryVideoSlot=Auto",
#"RptKeyErr=Enabled",
#"Sata0=Enabled",
#"Sata1=Enabled",
#"Sata3=Enabled",
"SdCard=Enabled",
"SdCardBoot=Disabled",
"SdCardReadOnly=Disabled",
"SecureBoot=Disabled",
#"SecureBootMode=AuditMode",
#"Serial1=Com1",
#"Serr=Enabled",
"ServiceOsClear=Disabled",
#"SfpNic=EnabledPxe",
"SmartErrors=Disabled",
"SmmSecurityMitigation=Enabled",
"SoftGuardEn=SoftControlled",
"SpeedShift=Enabled",
"Speedstep=Enabled",
"StrongPassword=Disabled",
"SupportAssistOSRecovery=Disabled",
"SvcOsClear=Disabled",
#"TbtPcieModeAutoSwitch=Enabled",
"TelemetryAccessLvl=Full",
#"Thunderbolt=Enabled",
#"ThunderboltSecLvl=UserAuth",
#"TpmActivation=Enabled",
#"TpmPpiClearOverride=Disabled",
#"TpmPpiDpo=Disabled",
#"TpmPpiPo=Enabled",
#"TpmSecurity=Enabled",
"TrustExecution=Disabled",
"TurboMode=Enabled",
"UefiBootPathSecurity=AlwaysExceptInternalHddPxe",
"UefiNwStack=Enabled",
"UsbEmu=Enabled",
#"UsbPortsFront=Enabled",
#"UsbPortsFront1=Enabled",
#"UsbPortsFront2=Enabled",
#"UsbPortsFront3=Enabled",
#"UsbPortsFront4=Enabled",
#"UsbPortsRear=Enabled",
#"UsbPortsRear1=Enabled",
#"UsbPortsRear2=Enabled",
#"UsbPortsRear3=Enabled",
#"UsbPortsRear4=Enabled",
#"UsbPortsRear5=Enabled",
#"UsbPortsRear6=Enabled",
#"UsbPortsRear7=Enabled",
"UsbPowerShare=Disabled",
"UsbWake=Disabled",
"Virtualization=Enabled",
"VtForDirectIo=Enabled",
"WakeOnLan=LanWithPxeBoot",
"WarningsAndErr=PromptWrnErr",
"WdtOsBootProtection=Disabled",
"WirelessLan=Enabled"
)
choco install dellcommandconfigure -y
foreach($item in $biossetting){
& "C:\Program Files (x86)\Dell\Command Configure\X86_64\cctk.exe" --$item | Out-Null
if($LASTEXITCODE -eq 0)
{
write-host "setting $item was successfull" -ForegroundColor Green

}
elseif($LASTEXITCODE -eq 42){

write-host "$item is not available or cannot be configured " -ForegroundColor Red

}
elseif($LASTEXITCODE -eq 43){

write-host "There was an error setting the option: $item " -ForegroundColor Red

}
elseif($LASTEXITCODE -eq 72){

write-host "TpmActivation cannot be modified when TPM is OFF" -ForegroundColor Red

}
elseif($LASTEXITCODE -eq 58 -or $LASTEXITCODE -eq 65 -or $LASTEXITCODE -eq 66 -or $LASTEXITCODE -eq 67 -or $LASTEXITCODE -eq 109)
{
write-host "Password is set in the BIOS, please clear the BIOS password during restart and continue" -ForegroundColor Red
$biospassword = Read-Host -Prompt 'Enter bios Password to clear it in bios'
& "C:\Program Files (x86)\Dell\Command Configure\X86_64\cctk.exe" --syspwd=   --valsyspwd=$biospassword
& "C:\Program Files (x86)\Dell\Command Configure\X86_64\cctk.exe" --$item | Out-Null
write-host "setting $item was successfull" -ForegroundColor Green
}
else{
write-host "There was an error setting the option: $item " -ForegroundColor Red
#Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'dellcommandconfigure'
#Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass ; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))"
#Stop-Transcript
#Pause
#Exit
}
}
write-host "Stage: dellcommandconfigure completed" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'chocolatey_apps'
Set-Runonce
Stop-Transcript
Restart-Computer
