dism /Export-Image /SourceImageFile:%~dp0sources\install.wim /SourceIndex:6 /DestinationImageFile:%temp%\install.wim /Compress:Max /CheckIntegrity
set workdir=%date: =_%_%time: =0%
set workdir=%workdir:/=_%
set workdir=%workdir::=_%
set workdir=%workdir:.=_%
set workdir=%workdir:,=_%
set workdir=c:\temp\%workdir%
md %workdir%
DISM /Mount-Wim /WimFile:%temp%\install.wim /index:1 /MountDir:%workdir%
md %workdir%\Windows\Setup\Scripts
echo reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -v test /t REG_SZ -d "cmd /k @powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \" iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/header.ps1'))\"" /f > %workdir%\Windows\Setup\Scripts\SetupComplete.cmd
DISM /Image:%workdir% /Add-Driver /Driver:C:\deploydriver /recurse
DISM /unmount-wim /MountDir:%workdir% /commit
DEL %~dp0sources\install.wim
Dism /Split-Image /ImageFile:%temp%\install.wim /SWMFile:%~dp0sources\install.swm /FileSize:3500
DEL %temp%\install.wim
rmdir %workdir% /s /q
pause
