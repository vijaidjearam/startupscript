Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show('Hello')
#Installing Chocolatey
try
{
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
[System.Windows.MessageBox]::Show('Chocolatey Installed Correctly')
}
catch
{
[System.Windows.MessageBox]::Show('Problem Encountered during the installation of Chocolatey')
}
