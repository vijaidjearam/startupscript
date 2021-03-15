dism /Export-Image /SourceImageFile:%~dp0sources\install.esd /SourceIndex:4 /DestinationImageFile:%temp%\install.wim /Compress:Max /CheckIntegrity
set workdir=c:\temp\%date:~7,2%-%date:~-10,2%-%date:~-2,2%_%time:~0,2%.%time:~3,2%.%time:~6,2%
md %workdir%
DISM /Mount-Wim /WimFile:%temp%\install.wim /index:1 /MountDir:%workdir%
md %workdir%\Windows\Setup\Scripts
echo reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -v !test /t REG_SZ -d "cmd /k @powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \" iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))\"" /f > %workdir%\Windows\Setup\Scripts\SetupComplete.cmd
DISM /unmount-wim /MountDir:%workdir% /commit
DEL %~dp0sources\install.esd
Dism /Split-Image /ImageFile:%temp%\install.wim /SWMFile:%~dp0sources\install.wim /FileSize:3500
DEL %temp%\install.wim
DEL %workdir%
pause
