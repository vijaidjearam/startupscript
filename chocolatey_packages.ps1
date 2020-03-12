$chocoapps = @(
    	"7zip.install",
        "dotnetfx",
    	"adobeshockwaveplayer",
    	"ccleaner",
    	"dellcommandupdate", 
    	"filezilla", 
    	"firefox", 
        "ublockorigin-firefox"
    	"flashplayeractivex",
    	"flashplayerplugin", 
    	"foxitreader", 
    	"gimp", 
    	"git", 
    	"googlechrome",
        "ublockorigin-chrome",
    	"libreoffice-fresh", 
    	"pdfcreator", 
    	"quicktime",
    	"sublimetext3",
    	"totalcommander",
    	"vlc",
    	"vscode" 
    	# "aimp",
)
cinst -s chocosia -y Powershell | Out-Null 
#dependency for dell command update
cinst -s chocolatey -y dotnet4.6.1 | Out-Null 
$counter = 0
foreach($item in $chocoapps){
    $counter++
    Write-Progress -Activity 'Install Apps' -CurrentOperation $item -PercentComplete (($counter / $chocoapps.count) * 100)
    Start-Sleep -Milliseconds 200
    cinst -s chocosia -y --ignore-checksums $item | Out-Null
    if($LASTEXITCODE -eq 0){write-host $item"--------"Ok}
    else{write-host $item"--failed installing with internal server----------Nok" -ForegroundColor Red
    write-host "Trying to install with Chocolatey sever" -ForeGroundColor Yellow
    cinst -s chocolatey -y --ignore-checksums $item | Out-Null
    if($LASTEXITCODE -eq 0){write-host $item"--------"Ok}
    else{write-host $item"-failed installing even with chocolatey server-----------Nok" -ForegroundColor Red}
    }
}
