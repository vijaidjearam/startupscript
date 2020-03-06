iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))
choco source add -n chocosia -s "http://choco.iut-troyes.univ-reims.fr/chocolatey" --priority=1
write-host " Internal chocolatey configured --------------✔"
choco source add -n chocolatey -s "https://chocolatey.org/api/v2" --priority=2
write-host " chocolatey by default has been configured to priority 2 --------------✔"
$chocoapps = @(
    	"7zip.install",
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
    	"libreoffice-fresh", 
    	"pdfcreator", 
    	"quicktime",
    	"sublimetext3",
    	"totalcommander",
    	"vlc",
    	"vscode" 
    	# "aimp",
)
cinst -s chocosia -y Powershell 
cinst -s chocolatey -y dotnet4.6.1 
cinst -s chocolatey -y dotnetfx
cisnt -s chocosia -y --ignore-checksums $chocoapps
Pause

