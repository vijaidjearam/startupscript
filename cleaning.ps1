if (test-path C:\Windows\Setup\Scripts\SetupComplete.cmd){Remove-Item 'C:\Windows\Setup\Scripts\SetupComplete.cmd'}
Write-host "Cleaning Event Log" 
Try {Get-EventLog -LogName * | ForEach { Clear-EventLog $_.Log }}
catch {write-host "Error while cleaning log files" -ForegroundColor Red}
Write-host "Completed Cleaning Event Log" 
