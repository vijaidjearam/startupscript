choco install dellcommandconfigure -y
$FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss") + "_dellcommandupdate_bios_config_transcript.txt"
Start-Transcript -path $FileName -NoClobber
if (test-path "C:\Program Files (x86)\Dell\Command Configure\X86_64\cctk.exe")
{
try
{
& "C:\Program Files (x86)\Dell\Command Configure\X86_64\cctk.exe" --Absolute=Enabled --AcPwrRcvry=Off --AdminSetupLockout=Disabled --Aspm=Auto --AutoOn=Disabled --AutoOSRecoveryThreshold=OFF --BIOSConnect=Disabled --BIOSEnumMode=NativeEnum --BiosLogClear=Keep --BiosRcvrFrmHdd=Enabled --BlockSleep=Disabled --BluetoothDevice=Disabled --CapsuleFirmwareUpdate=Enabled --ChasIntrusion=SilentEnable --CpuCore=CoresAll --CStatesCtrl=Enabled --DeepSleepCtrl=Disabled --DustFilter=Disabled --EmbNic1=EnabledPxe --EmbSataRaid=Ahci --ExtPostTime=0s --FanCtrlOvrd=Disabled --Fastboot=Thorough --ForcePxeOnNextBoot=Disabled --FullScreenLogo=Disabled --IntegratedAudio=Enabled --InternalSpeaker=Enabled --IntlPlatformTrust=Disabled --LogicProc=Enabled --M2PcieSsd2=Enabled --M2PcieSsd3=Enabled --MediaCard=Enabled --Microphone=Enabled --MultiDisplay=Enabled --NumLockLed=Enabled --OromKeyboardAccess=Enabled --OsWatchdogTimer=Disabled --PasswordBypass=Disabled --PasswordLock=Enabled --PowerWarn=Enabled --PrimaryVideoSlot=Auto --RptKeyErr=Enabled --Sata0=Enabled --Sata1=Enabled --Sata3=Enabled --SdCard=Enabled --SdCardBoot=Disabled --SdCardReadOnly=Disabled --SecureBoot=Disabled --SecureBootMode=AuditMode --Serial1=Com1 --Serr=Enabled --ServiceOsClear=Disabled --SfpNic=EnabledPxe --SmartErrors=Disabled --SmmSecurityMitigation=Enabled --SoftGuardEn=SoftControlled --SpeedShift=Enabled --Speedstep=Enabled --StrongPassword=Disabled --SupportAssistOSRecovery=Disabled --SvcOsClear=Disabled --TbtPcieModeAutoSwitch=Enabled --TelemetryAccessLvl=Full --Thunderbolt=Enabled --ThunderboltSecLvl=UserAuth --TpmActivation=Enabled --TpmPpiClearOverride=Disabled --TpmPpiDpo=Disabled --TpmPpiPo=Enabled --TpmSecurity=Enabled --TrustExecution=Disabled --TurboMode=Enabled --UefiBootPathSecurity=AlwaysExceptInternalHddPxe --UefiNwStack=Enabled --UsbEmu=Enabled    --UsbPortsFront=Enabled --UsbPortsFront1=Enabled --UsbPortsFront2=Enabled --UsbPortsFront3=Enabled --UsbPortsFront4=Enabled --UsbPortsRear=Enabled --UsbPortsRear1=Enabled --UsbPortsRear2=Enabled --UsbPortsRear3=Enabled --UsbPortsRear4=Enabled --UsbPortsRear5=Enabled --UsbPortsRear6=Enabled --UsbPortsRear7=Enabled --UsbPowerShare=Disabled --UsbWake=Disabled --Virtualization=Enabled --VtForDirectIo=Enabled --WakeOnLan=LanWithPxeBoot --WarningsAndErr=PromptWrnErr --WdtOsBootProtection=Disabled --WirelessLan=Disabled
Set-Runonce -command "%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/windowsupdate_initiate.ps1'))"
write-host "Bios Configuration Done" -ForegroundColor Green
Stop-Transcript
Restart-Computer
}
catch
{
write-host "Bios Configuration Failed" -ForegroundColor Red
Stop-Transcript
}
}