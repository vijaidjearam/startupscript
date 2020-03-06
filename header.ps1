$FullUnicode = 'U+274C' # Unicode for whatever emoji you want to use.  274C is a cross mark button
$StrippedUnicode = $FullUnicode -replace 'U\+',''
$UnicodeInt = [System.Convert]::toInt32($StrippedUnicode,16)
$cross = [System.Char]::ConvertFromUtf32($UnicodeInt)
$FullUnicode = 'U+2714' # Unicode for whatever emoji you want to use.  2714 is a check mark button
$StrippedUnicode = $FullUnicode -replace 'U\+',''
$UnicodeInt = [System.Convert]::toInt32($StrippedUnicode,16)
$check = [System.Char]::ConvertFromUtf32($UnicodeInt)


write-host " Installing Chocolatey"
iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1")) | Out-Null
write-host "Chocolatey Installed Successfully --------------OK"
choco source add -n chocosia -s "http://choco.iut-troyes.univ-reims.fr/chocolatey" --priority=1 | Out-Null
write-host "Internal chocolatey configured --------------Ok"
choco source add -n chocolatey -s "https://chocolatey.org/api/v2" --priority=2 | Out-Null
write-host "chocolatey by default has been configured to priority 2 --------------Ok"
$chocoapps = @(
    	"7zip.install",
        "dotnetfx"
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
cinst -s chocosia -y Powershell | Out-Null 
#dependency for dell command update
cinst -s chocolatey -y dotnet4.6.1 | Out-Null 
cinst -s chocolatey -y dotnetfx | Out-Null
$counter = 0
foreach($item in $chocoapps){
    $counter++
    Write-Progress -Activity 'Install Apps' -CurrentOperation $item -PercentComplete (($counter / $chocoapps.count) * 100)
    Start-Sleep -Milliseconds 200
    cinst -s chocosia -y --ignore-checksums $item | Out-Null
    if($LASTEXITCODE -eq 0){write-host $item'--------Ok}
    else{write-host $item'-----------Nok' -foregroundcolor Red}
}

Pause

