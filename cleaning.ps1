Remove-Item 'C:\Windows\Setup\Scripts\SetupComplete.cmd'
Write-host "Cleaning Event Log" 
Get-EventLog -LogName * | ForEach { Clear-EventLog $_.Log }
Write-host "Completed Cleaning Event Log" 
