$service_stop = @{
  "AdobeFlashPlayerUpdateSvc",
  "AdobeARMservice",
  "gupdate",
  "Wsearch",
  "WMPNetworkSvc"
}
$service_startup_disabled = @{
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
  "Wlansvc",
  "Wwansvc", 
  "ehSched", 
  "bthserv",
  "ehRecvr", 
  "Mcx2Svc", 
  "SCPolicySvc",
  "Themes" 
}
$service_startup_delayed-auto = @{
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
}
foreach($item in $service_stop){
    $counter++
    Write-Progress -Activity 'Stopping Srevices' -CurrentOperation $item -PercentComplete (($counter / $service_stop.count) * 100)
    Start-Sleep -Milliseconds 200
    try{
    $detail = get-service -Name $item
    stop-service -Name $item
    write-Host "Stopped service-"$detail.displayname"-"$item"----------ok" -ForeGroundColor Green
    }
    catch{
    write-Host "Error stopping service-"$item"----------Nok" -ForeGroundColor RED
    }
}
$counter =0
foreach($item in $service_startup_disabled){
    $counter++
    Write-Progress -Activity 'Stopping Srevices' -CurrentOperation $item -PercentComplete (($counter / $service_startup_disabled.count) * 100)
    Start-Sleep -Milliseconds 200
    try{
    $detail = get-service -Name $item
    set-service -Name $item -startuptype disabled
    write-Host $detail.displayname"-"$item"-Service starup set to Disabled" -ForeGroundColor Green
    }
    catch{
    write-Host $item"-Service unable to set startup Disabled" -ForeGroundColor Red
    }
}
$counter =0
foreach($item in $service_startup_delayed-auto){
    $counter++
    Write-Progress -Activity 'Stopping Srevices' -CurrentOperation $item -PercentComplete (($counter / $service_startup_delayed-auto.count) * 100)
    Start-Sleep -Milliseconds 200
    try{
    $detail = get-service -Name $item
    set-service -Name $item -startuptype disabled
    write-Host $detail.displayname"-"$item"-Service starup set to Delayed-auto" -ForeGroundColor Green
    }
    catch{
    write-Host $item"-Service unable to set startup Delayed-auto" -ForeGroundColor Red
    }
}
  
