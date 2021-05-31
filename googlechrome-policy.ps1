function googlechrome-policy{
New-Item -ItemType Directory -Force -Path $env:TEMP\Scripts\GPO\
wget https://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip -OutFile $env:TEMP\Scripts\GPO\Browserpolicy_templates.zip
Expand-Archive $env:TEMP\Scripts\GPO\Browserpolicy_templates.zip -DestinationPath $env:TEMP\Scripts\GPO -Force
cp $env:TEMP\Scripts\GPO\windows\admx\*.admx C:\Windows\PolicyDefinitions\ -Force
$path =" C:\Windows\PolicyDefinitions\fr-FR\"
if (!(test-path $path))
{
New-Item -ItemType Directory -Force -Path C:\Windows\PolicyDefinitions\fr-FR\
}
cp $env:TEMP\Scripts\GPO\windows\admx\fr-FR\*.adml C:\Windows\PolicyDefinitions\fr-FR\ -Force
if (!(test-path -Path HKLM:\SOFTWARE\Policies\Google))
{
New-Item -Path HKLM:\SOFTWARE\Policies\ -Name Google
}
if (!(test-path -Path HKLM:\SOFTWARE\Policies\Google\Chrome))
{
New-Item -Path HKLM:\SOFTWARE\Policies\Google\ -Name Chrome
}
if (!(test-path -Path HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist))
{
New-Item -Path HKLM:\SOFTWARE\Policies\Google\Chrome\ -Name ExtensionInstallForcelist
}
if (!(test-path -Path HKLM:\SOFTWARE\Policies\Google\Chrome\RestoreOnStartupURLs))
{
New-Item -Path HKLM:\SOFTWARE\Policies\Google\Chrome\ -Name RestoreOnStartupURLs
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist -Name "2" -Value ”cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx” -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Google\Chrome\ -Name "HomepageLocation" -Value ”https://www.iut-troyes.univ-reims.fr/” -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Google\Chrome\ -Name "RestoreOnStartup" -Value 4 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Google\Chrome\RestoreOnStartupURLs -Name "1" -Value ”https://www.iut-troyes.univ-reims.fr/” -Force
}
googlechrome-policy
