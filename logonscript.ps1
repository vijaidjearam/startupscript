#Add-Type -AssemblyName PresentationFramework
#[System.Windows.MessageBox]::Show('Hello')
#Installing Chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) |Out-Null
#catch{write-host "Problem encountered while installing chocolatey"}

#Configuring internal chocolatey server
choco source add -n chocosia -s "http://choco.iut-troyes.univ-reims.fr/chocolatey" --priority=1 |Out-Null
write-host " Internal chocolatey configured --------------✔"
choco source add -n chocolatey -s "https://chocolatey.org/api/v2" --priority=2 |Out-Null

#The packages that are not necessary can be commented with #
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
cinst -s chocosia -y Powershell |Out-Null
cinst -s chocolatey -y dotnet4.6.1 |Out-Null # dependency needed for dell command update
cinst -s chocolatey -y dotnetfx |Out-Null
$counter = 0
foreach($item in $chocoapps){
    $counter++
    Write-Progress -Activity 'Install Apps' -CurrentOperation $item -PercentComplete (($counter / $chocoapps.count) * 100)
    Start-Sleep -Milliseconds 200
    cinst -s chocosia -y --ignore-checksums $item | Out-Null
    if($LASTEXITCODE -eq 0){write-host "$item --------------✔"} 
    else{write-host "$item --------------❌"}
}

#pause the script at the end to see the status.
Pause

