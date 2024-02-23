while (!(test-connection 8.8.8.8 -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor Red  "Internet Connection down..."
    sleep 5
}
write-host "internet connection is up! -> proceeding with the script" -ForegroundColor Green
$repopath ="https://raw.githubusercontent.com/vijaidjearam/startupscript/master/"
if (test-path 'HKCU:\repopath'){
$repopath = Get-ItemPropertyValue -Path 'HKCU:\repopath' -Name path
}
else{
New-Item -Path "HKCU:\" -Name "repopath"
New-ItemProperty -Path 'HKCU:\repopath' -Name path -value $repopath
}
iex ((New-Object System.Net.WebClient).DownloadString($repopath+'install_windows_with_recovery_partition.ps1'))


