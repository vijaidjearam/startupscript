Try
{
$service_stop = @(
  "AdobeFlashPlayerUpdateSvc",
  "AdobeARMs,ervice",
  "gupdate"
  "Wsearch",
  "WMPNetworkSvc"
)
$service_startup_disabled = @(
  "AdobeFlashPlayerUpdateSvc",
  "AdobeARMservice",
  "gupdate",
  "Wsearch",
  "WMPNetworkSvc",
  "SCardSvr",
  "DiagTrack",
  "SharedAccess", 
  "WbioSrvc", 
  "BDESVC",
  "Wlansvc,"
  "Wwansvc", 
  "ehSched", 
  "ehRecvr",
  "Mcx2Svc", 
  "SCPolicySvc",
  "gupdate",
  "gupdatem",
  "edgeupdate",
  "edgeupdatem",
  "MicrosoftEdgeElevationService",
  "MessagingService_ab44f",
  "GoogleChromeElevationService",
  "AMD Crash Defender Service",
  "AMD External Events Utility",
  "Themes"
)
$service_startup_delayed_auto = @(
  "nlasvc", #Connaissance des emplacements réseau
  "RasAuto", #Gestionnaire de connexion automatique d’accès distant
  "RasMan", #Gestionnaire de connexions d’accès distant 
  "Winmgmt", #Infrastructure de gestion Windows
  "ose", #Office  Source Engine
  "osppsvc", #Office Software Protection Platform
  "MMCSS", #Planificateur de classes multimédias
  "sppsvc", #Protection logicielle
  "LanmanServer", #Serveur 
  "PcaSvc" #Service de l’Assistant Compatibilité des programmes
)
$counter = 1
foreach($item in $service_stop){
    Write-Progress -Activity 'Stopping Srevices' -CurrentOperation $item -PercentComplete (($counter / $service_stop.count) * 100)
    Start-Sleep -Milliseconds 200
    if(Get-Service $item -ErrorAction SilentlyContinue){
    $detail = get-service -Name $item 
    stop-service -Name $item
    write-Host "Stopped service-"$detail.displayname"-"$item"----------ok" -ForeGroundColor Green
    }
    else{
    write-Host "Error stopping service-"$item"----------Nok" -ForeGroundColor Yellow
    }
    $counter++
}
$counter =1
foreach($item in $service_startup_disabled){
    Write-Progress -Activity 'Setting service startup disabled ' -CurrentOperation $item -PercentComplete (($counter / $service_startup_disabled.count) * 100)
    Start-Sleep -Milliseconds 200
    if(Get-Service $item -ErrorAction SilentlyContinue){
    $detail = get-service -Name $item
    set-service -Name $item -startuptype disabled 
    write-Host $detail.displayname"-"$item"-Service starup set to Disabled----------ok" -ForeGroundColor Green
    }
    Else{
    write-Host $item"-Service unable to set startup Disabled----------Nok" -ForeGroundColor Yellow
    }
    $counter++
}
$counter =1
foreach($item in $service_startup_delayed_auto){
    Write-Progress -Activity 'Setting service startup delayed auto' -CurrentOperation $item -PercentComplete (($counter / $service_startup_delayed_auto.count) * 100)
    Start-Sleep -Milliseconds 200
    if(Get-Service $item -ErrorAction SilentlyContinue){
      $service = $item
      $command = "sc.exe config $Service start= delayed-auto"
      $Output = Invoke-Expression -Command $Command
      if($LASTEXITCODE -ne 0){
          Write-Host "$Computer : Failed to set $Service to delayed start. 
          More details: $Output" -foregroundcolor red
      } 
      else {
        Write-Host "Successfully changed $Service service to delayed start" -foregroundcolor green
   }
   }
    $counter++
}
write-host "Stage: windows_services completed" -ForegroundColor Green
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value 'windows_settings'
Set-Runonce
Stop-Transcript
Restart-Computer
}
catch
{
write-host "Stage: windows_services Failed" -ForegroundColor Red
Set-ItemProperty -Path 'HKCU:\osinstall_local' -Name stage -value windows_services
Set-Runonce
Stop-Transcript
Pause
}
