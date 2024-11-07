$webClient = New-Object System.Net.WebClient
$url = 'https://raw.githubusercontent.com/vijaidjearam/startupscript/master/registryrunonce.ps1'
$destination = 'C:\Windows\Temp\header.ps1'

# Download the file
$webClient.DownloadFile($url, $destination)

# Execute the downloaded script
powershell.exe -NoExit -ExecutionPolicy Bypass -File $destination
