dism /Export-Image /SourceImageFile:%~dp0sources\install.esd /SourceIndex:4 /DestinationImageFile:%temp%\install.wim /Compress:Max /CheckIntegrity
SET HOUR=%time:~0,2%
SET dtStamp9=%date:~-4%%date:~4,2%%date:~7,2%_0%time:~1,1%%time:~3,2%%time:~6,2% 
SET dtStamp24=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
if "%HOUR:~0,1%" == " " (SET workdir=%dtStamp9%) else (SET workdir=%dtStamp24%)
md %workdir%
DISM /Mount-Wim /WimFile:%temp%\install.wim /index:1 /MountDir:%workdir%
md %workdir%\Windows\Setup\Scripts
echo reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -v test /t REG_SZ -d "cmd /k @powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \" iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))\"" /f > %workdir%\Windows\Setup\Scripts\SetupComplete.cmd
DISM /unmount-wim /MountDir:%workdir% /commit
DEL %~dp0sources\install.esd
Dism /Split-Image /ImageFile:%temp%\install.wim /SWMFile:%~dp0sources\install.swm /FileSize:3500
DEL %temp%\install.wim
DEL %workdir%
pause
