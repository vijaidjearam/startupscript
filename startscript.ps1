Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show('Hello')
#Installing Chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
