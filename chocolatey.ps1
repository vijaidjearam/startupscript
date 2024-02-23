# Relaunch the script with administrator privileges
Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -Verb RunAs
		Exit
	}
}
$FileName = $env:TEMP+"\"+(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")+"_chocolatey_transcript.txt"
Start-Transcript -path $FileName -NoClobber
$repopath = Get-ItemPropertyValue -Path 'HKCU:\repopath' -Name path
iex ((New-Object System.Net.WebClient).DownloadString($repopath+'windows_settings_essentials.ps1'))
$apps = @()
$PSCommandArgs = @()

Function AddOrRemoveApps($app) {
	If ($app[0] -eq "!") {
		# If the name starts with exclamation mark (!), exclude the app from selection
		$script:apps = $script:apps | Where-Object { $_ -ne $app.Substring(1) }
	} ElseIf ($app -ne "") {
		# Otherwise add the app
		$script:apps += $app
	}
}
try
{
# Parse and resolve paths in passed arguments
$i = 0
While ($i -lt $args.Length) {
	If ($args[$i].ToLower() -eq "-include") {
		# Resolve full path to the included file
		$include = Resolve-Path $args[++$i] -ErrorAction Stop
		$PSCommandArgs += "-include `"$include`""
		# Import the included file as a module
		Import-Module -Name $include -ErrorAction Stop
	} ElseIf ($args[$i].ToLower() -eq "-preset") {
		# Resolve full path to the preset file
		$preset = Resolve-Path $args[++$i] -ErrorAction Stop
		$PSCommandArgs += "-preset `"$preset`""
		# Load app names from the preset file
		Get-Content $preset -ErrorAction Stop | ForEach-Object { AddOrRemoveApps($_.Split("#")[0].Trim()) }
	} ElseIf ($args[$i].ToLower() -eq "-log") {
		# Resolve full path to the output file
		$log = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($args[++$i])
		$PSCommandArgs += "-log `"$log`""
		# Record session to the output file
		Start-Transcript $log
	} Else {
		$PSCommandArgs += $args[$i]
		# Load app names from command line
		AddOrRemoveApps($args[$i])
	}
	$i++
}

# Call the desired app functions
$apps | ForEach-Object { 
    $counter++
    Write-Progress -Activity 'Install Apps' -CurrentOperation $_ -PercentComplete (($counter / $apps.count) * 100)
    Start-Sleep -Milliseconds 200
    if ($_.contains('-params')){
    $ts = $_ -split " "
    $app = $ts[0]
    $param = $ts[2..$ts.Length] -join " "
    choco install -y --ignore-checksums --params $param $app | Out-Null
    if($LASTEXITCODE -eq 0){write-host $_"--------Ok" -ForegroundColor Green}
    else{write-host $_"--failed ----------Nok" -ForegroundColor Red}
    }
    else{
    choco install -y --ignore-checksums $_ | Out-Null
    if($LASTEXITCODE -eq 0){write-host $_"--------Ok" -ForegroundColor Green}
    else{write-host $_"--failed ----------Nok" -ForegroundColor Red}
    }
    }
write-host "Stage: chocolatey_apps completed" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windowsupdate_initiate'
Set-Runonce
Stop-Transcript
Restart-Computer
}
catch
{
write-host "Stage: chocolatey_apps Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value chocolatey_apps
Set-Runonce
Stop-Transcript
Pause
}
