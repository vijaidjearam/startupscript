$WarningPreference = 'SilentlyContinue'
write-host "Entering Windows-settings Configuration Stage" 
Set-TaskbarOptions -Size Small
Enable-RemoteDesktop
set-ntpserver-urca




function Enable-RemoteDesktop {
<#
.SYNOPSIS
Allows Remote Desktop access to machine and enables Remote Desktop firewall rule
.PARAMETER DoNotRequireUserLevelAuthentication
Allows connections from computers running remote desktop
without Network Level Authentication (not recommended)
.LINK
https://boxstarter.org
#>

    param(
        [switch]$DoNotRequireUserLevelAuthentication
    )

    Write-host "Enabling Remote Desktop..."
    $obj = Get-WmiObject -Class "Win32_TerminalServiceSetting" -Namespace root\cimv2\terminalservices
    if($obj -eq $null) {
        Write-host "Unable to locate terminalservices namespace. Remote Desktop is not enabled"
        return
    }
    try {
        $obj.SetAllowTsConnections(1,1) | Out-Null
    }
    catch {
        throw "There was a problem enabling remote desktop. Make sure your operating system supports remote desktop and there is no group policy preventing you from enabling it."
    }

    $obj2 = Get-WmiObject -class Win32_TSGeneralSetting -Namespace root\cimv2\terminalservices -ComputerName . -Filter "TerminalName='RDP-tcp'"

    if($obj2.UserAuthenticationRequired -eq $null) {
        Write-host "Unable to locate Remote Desktop NLA namespace. Remote Desktop NLA is not enabled"
        return
    }
    try {
        if($DoNotRequireUserLevelAuthentication) {
            $obj2.SetUserAuthenticationRequired(0) | Out-Null
            Write-host "Disabling Remote Desktop NLA ..."
        }
        else {
			$obj2.SetUserAuthenticationRequired(1) | Out-Null
            Write-host "Enabling Remote Desktop NLA ..."
        }
    }
    catch {
        throw "There was a problem enabling Remote Desktop NLA. Make sure your operating system supports Remote Desktop NLA and there is no group policy preventing you from enabling it."
    }
}
function Set-TaskbarOptions {
<#
.SYNOPSIS
Sets options for the Windows Task Bar.
.PARAMETER Lock
Locks the taskbar.
.PARAMETER UnLock
Unlocks the taskbar.
.PARAMETER AutoHide
Autohides the taskbar.
.PARAMETER NoAutoHide
No autohiding on the taskbar.
.PARAMETER Size
Changes the size of the taskbar icons.  Valid inputs are Small and Large.
.PARAMETER Dock
Changes the location in which the taskbar is docked. Valid inputs are Top, Left, Bottom and Right.
.PARAMETER Combine
Changes the taskbar icon combination style. Valid inputs are Always, Full, and Never.
.PARAMETER AlwaysShowIconsOn
Turn on always show all icons in the notification area.
.PARAMETER AlwaysShowIconsOff
Turn off always show all icons in the notification area.
.PARAMETER MultiMonitorOn
Turn on Show tasbkar on all displays.
.PARAMETER MultiMonitorOff
Turn off Show taskbar on all displays.
.PARAMETER MultiMonitorMode
Changes the behavior of the taskbar when using multiple displays. Valid inputs are All, MainAndOpen, and Open.
.PARAMETER MultiMonitorCombine
Changes the taskbar icon combination style for non-primary displays. Valid inputs are Always, Full, and Never.
.EXAMPLE
Set-BoxstarterTaskbarOptions -Lock -AutoHide -AlwaysShowIconsOff -MultiMonitorOff
Locks the taskbar, enabled auto-hiding of the taskbar, turns off showing icons
in the notification area and turns off showing the taskbar on multiple monitors.
.EXAMPLE
Set-BoxstarterTaskbarOptions -Unlock -AlwaysShowIconsOn -Size Large -MultiMonitorOn -MultiMonitorCombine Always
Unlocks the taskbar and always shows large notification icons. Sets
multi-monitor support and always combine icons on non-primary monitors.
#>
    [CmdletBinding(DefaultParameterSetName='unlock')]
    param(
        [Parameter(ParameterSetName='lockhide')]
        [Parameter(ParameterSetName='locknohide')]
        [switch]
        $Lock,

        [Parameter(ParameterSetName='unlock')]
        [Parameter(ParameterSetName='unlockhide')]
        [Parameter(ParameterSetName='unlocknohide')]
        [switch]
        $UnLock,

        [Parameter(ParameterSetName='lockhide')]
        [Parameter(ParameterSetName='unlockhide')]
        [switch]
        $AutoHide,

        [Parameter(ParameterSetName='locknohide')]
        [Parameter(ParameterSetName='unlocknohide')]
        [switch]
        $NoAutoHide,

        [Parameter(ParameterSetName='AlwaysShowIconsOn')]
        [switch]
        $AlwaysShowIconsOn,

        [Parameter(ParameterSetName='AlwaysShowIconsOff')]
        [switch]
        $AlwaysShowIconsOff,

        [ValidateSet('Small','Large')]
        [String]
        $Size,

        [ValidateSet('Top','Left','Bottom','Right')]
        [String]
        $Dock,

        [ValidateSet('Always','Full','Never')]
        [String]
        $Combine,

        [Parameter(ParameterSetName='MultiMonitorOff')]
        [switch]
        $MultiMonitorOff,

        [Parameter(ParameterSetName='MultiMonitorOn')]
        [switch]
        $MultiMonitorOn,

        [Parameter(ParameterSetName='MultiMonitorOn')]
        [ValidateSet('All', 'MainAndOpen', 'Open')]
        [String]
        $MultiMonitorMode,

        [Parameter(ParameterSetName='MultiMonitorOn')]
        [ValidateSet('Always','Full','Never')]
        [String]
        $MultiMonitorCombine
    )

    $explorerKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    $settingKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects2'

    if (-not (Test-Path -Path $settingKey)) {
        $settingKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
    }

    if (Test-Path -Path $key) {
        if ($Lock) {
            Set-ItemProperty -Path $key -Name TaskbarSizeMove -Value 0
        }

        if ($UnLock) {
            Set-ItemProperty -Path $key -Name TaskbarSizeMove -Value 1
        }

        switch ($Size) {
            "Small" {
                Set-ItemProperty -Path $key -Name TaskbarSmallIcons -Value 1
            }

            "Large" {
                Set-ItemProperty -Path $key -Name TaskbarSmallIcons -Value 0
            }
        }

        switch ($Combine) {
            "Always" {
                Set-ItemProperty -Path $key -Name TaskbarGlomLevel -Value 0
            }

            "Full" {
                Set-ItemProperty -Path $key -Name TaskbarGlomLevel -Value 1
            }

            "Never" {
                Set-ItemProperty -Path $key -Name TaskbarGlomLevel -Value 2
            }
        }

        if ($MultiMonitorOn) {
            Set-ItemProperty -Path $key -Name MMTaskbarEnabled -Value 1

            switch ($MultiMonitorMode) {
                "All" {
                    Set-ItemProperty -Path $key -Name MMTaskbarMode -Value 0
                }

                "MainAndOpen" {
                    Set-ItemProperty -Path $key -Name MMTaskbarMode -Value 1
                }

                "Open" {
                    Set-ItemProperty -Path $key -Name MMTaskbarMode -Value 2
                }
            }

            switch ($MultiMonitorCombine) {
                "Always" {
                    Set-ItemProperty -Path $key -Name MMTaskbarGlomLevel -Value 0
                }

                "Full" {
                    Set-ItemProperty -Path $key -Name MMTaskbarGlomLevel -Value 1
                }

                "Never" {
                    Set-ItemProperty -Path $key -Name MMTaskbarGlomLevel -Value 2
                }
            }
        }

        if ($MultiMonitorOff) {
            Set-ItemProperty -Path $key -Name MMTaskbarEnabled -Value 0
        }
    }

    if (Test-Path -Path $settingKey) {
        $settings = (Get-ItemProperty -Path $settingKey -Name Settings).Settings

        switch ($Dock) {
            "Top" {
                $settings[12] = 0x01
            }

            "Left" {
                $settings[12] = 0x00
            }

            "Bottom" {
                $settings[12] = 0x03
            }

            "Right" {
                $settings[12] = 0x02
            }
        }

        if ($AutoHide) {
            $settings[8] = $settings[8] -bor 1
        }

        if ($NoAutoHide) {
            $settings[8] = $settings[8] -band 0
            Set-ItemProperty -Path $settingKey -Name Settings -Value $settings
        }

        Set-ItemProperty -Path $settingKey -Name Settings -Value $settings
    }

    if (Test-Path -Path $explorerKey) {
        if ($AlwaysShowIconsOn) {
            Set-ItemProperty -Path $explorerKey -Name 'EnableAutoTray' -Value 0
        }

        if ($alwaysShowIconsOff) {
            Set-ItemProperty -Path $explorerKey -Name 'EnableAutoTray' -Value 1
        }
    }

    Restart-Explorer
}


function Restart-Explorer {

    try{
        Write-host "Restarting the Windows Explorer process..."
        $user = Get-CurrentUser
        try { $explorer = Get-Process -Name explorer -ErrorAction stop -IncludeUserName }
        catch {$global:error.RemoveAt(0)}

        if($explorer -ne $null) {
            $explorer | ? { $_.UserName -eq "$($user.Domain)\$($user.Name)"} | Stop-Process -Force -ErrorAction Stop | Out-Null
        }

        Start-Sleep 1

        if(!(Get-Process -Name explorer -ErrorAction SilentlyContinue)) {
            $global:error.RemoveAt(0)
            start-Process -FilePath explorer
        }
    } catch {$global:error.RemoveAt(0)}
}
function set-ntpserver-urca {
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers" -Name "25" -Value "ntp-ts.univ-reims.fr" -PropertyType "string"
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers" -Name "(Default)" -Value "25" -PropertyType "string"

}




