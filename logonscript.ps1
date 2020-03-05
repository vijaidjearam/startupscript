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

#Configuring internal chocolatey server
choco source add -n chocosia -s "http://choco.iut-troyes.univ-reims.fr/chocolatey" --priority=1
choco source add -n chocolatey -s "https://chocolatey.org/api/v2" --priority=2

#The packages that are not necessary can be commented with #
$chocoapps = @(
    	".7zip.install",
    	"adobeshockwaveplayer",
    	"ccleaner",
    	"dellcommandupdate", 
    	"filezilla", 
    	"firefox", 
    	"flashplayeractivex",
    	"flashplayerplugin", 
    	"foxitreader", 
    	"gimp", 
    	"git", 
    	"googlechrome",
    	"libreoffice", 
    	"pdfcreator", 
    	"quicktime",
    	"sublimetext3",
    	"totalcommander",
    	"vlc",
    	"vscode" 
    	# "aimp",
)
cinst -s chocosia -y Powershell 
cinst -s chocolatey -y dotnetfx
cinst -s chocosia -y --ignore-checksums $chocoapps
#pause the script at the end to see the status.
Pause

