function Start-HealthCheck {
    # Runs all system health checks.

    Write-Log `
        -Message "Starting system health check..." `
        -Level INFO

    Test-SystemHealth

    Test-StorageHealth

    Test-NetworkHealth

    Test-SecurityHealth

    Write-Log `
        -Message "System health check completed." `
        -Level INFO
}

function Test-SystemHealth {
    # Performs system health checks.

    try {
        $OperatingSystem = Get-CimInstance `
            -ClassName Win32_OperatingSystem `
            -ErrorAction Stop
    }
    catch {
        Write-Log `
            -Message "Unable to retrieve operating system information." `
            -Level WARNING

        return
    }

    $Uptime = (Get-Date) - $OperatingSystem.LastBootUpTime

    Write-Log `
        -Message "System Uptime: $($Uptime.Days) days, $($Uptime.Hours) hours, $($Uptime.Minutes) minutes" `
        -Level INFO

    if ($Uptime.Days -gt 30) {

        Write-Log `
            -Message "Health Status: WARNING" `
            -Level WARNING

        Write-Log `
            -Message "Recommendation: Restart the computer to ensure pending updates and services are properly refreshed." `
            -Level INFO
    }
    else {

        Write-Log `
            -Message "Health Status: HEALTHY" `
            -Level INFO
    }
}

function Test-StorageHealth {
    # Performs storage health checks.

    try {
        $LogicalDisks = Get-CimInstance `
            -ClassName Win32_LogicalDisk `
            -Filter "DriveType = 3" `
            -ErrorAction Stop
    }
    catch {

        Write-Log `
            -Message "Unable to retrieve storage information." `
            -Level WARNING

        return
    }

    foreach ($Disk in $LogicalDisks) {

        if ($Disk.Size -le 0) {

            Write-Log `
                -Message "Unable to determine storage capacity for drive $($Disk.DeviceID)." `
                -Level WARNING

            continue
        }

        $FreeSpaceGB = [math]::Round(
            $Disk.FreeSpace / 1GB,
            2
        )

        $FreePercentage = [math]::Round(
            ($Disk.FreeSpace / $Disk.Size) * 100,
            2
        )

        Write-Log `
            -Message "Drive $($Disk.DeviceID) - Free Space: $FreeSpaceGB GB ($FreePercentage%)" `
            -Level INFO

        if ($FreePercentage -lt 10) {

            Write-Log `
                -Message "Health Status: CRITICAL" `
                -Level WARNING

            Write-Log `
                -Message "Recommendation: Free disk space immediately." `
                -Level INFO
        }
        elseif ($FreePercentage -lt 20) {

            Write-Log `
                -Message "Health Status: WARNING" `
                -Level WARNING

            Write-Log `
                -Message "Recommendation: Consider cleaning unnecessary files." `
                -Level INFO
        }
        else {

            Write-Log `
                -Message "Health Status: HEALTHY" `
                -Level INFO
        }
    }
}

function Test-NetworkHealth {
    # Performs network health checks.
}

function Test-SecurityHealth {
    # Performs security health checks.
}