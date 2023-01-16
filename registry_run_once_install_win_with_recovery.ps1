while (!(test-connection 8.8.8.8 -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor Red  "Internet Connection down..."
    sleep 5
}
write-host "internet connection is up! -> proceeding with the script" -ForegroundColor Green
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/vijaidjearam/startupscript/master/install_windows_with_recovery_partition.ps1'))
