function Get-SystemInformation
{
    # Collects basic system information for diagnostics and reporting.

    $ComputerName = $env:COMPUTERNAME
    $CurrentUser = $env:USERNAME

    $OperatingSystem = Get-CimInstance Win32_OperatingSystem
    $ComputerSystem = Get-CimInstance Win32_ComputerSystem
    $BaseBoard = Get-CimInstance Win32_BaseBoard
    $BIOS = Get-CimInstance Win32_BIOS
    $Processor = Get-CimInstance Win32_Processor
    $VideoControllers = Get-CimInstance Win32_VideoController

    $LogicalDisks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType = 3" |
        Where-Object { $_.Size -gt 50GB }

    # Calculate hardware information.

    $TotalRAM = [math]::Round(
        $ComputerSystem.TotalPhysicalMemory / 1GB,
        2
    )

    # Format BIOS release date.

    $BIOSReleaseDate = $BIOS.ReleaseDate.ToString("yyyy-MM-dd")

    # Calculate system uptime.

    $Uptime = (Get-Date) - $OperatingSystem.LastBootUpTime

    #
    # Computer
    #

    Write-Log `
        -Message "Computer Name: $ComputerName" `
        -Level INFO

    Write-Log `
        -Message "Current User: $CurrentUser" `
        -Level INFO

    Write-Log `
        -Message "Manufacturer: $($ComputerSystem.Manufacturer)" `
        -Level INFO

    Write-Log `
        -Message "Motherboard: $($BaseBoard.Product)" `
        -Level INFO

    #
    # Operating System
    #

    Write-Log `
        -Message "Operating System: $($OperatingSystem.Caption)" `
        -Level INFO

    Write-Log `
        -Message "OS Version: $($OperatingSystem.Version)" `
        -Level INFO

    #
    # BIOS
    #

    Write-Log `
        -Message "BIOS Manufacturer: $($BIOS.Manufacturer)" `
        -Level INFO

    Write-Log `
        -Message "BIOS Version: $($BIOS.SMBIOSBIOSVersion)" `
        -Level INFO

    Write-Log `
        -Message "BIOS Release Date: $BIOSReleaseDate" `
        -Level INFO

    #
    # Processor and Memory
    #

    Write-Log `
        -Message "Processor: $($Processor.Name)" `
        -Level INFO

    Write-Log `
        -Message "CPU Cores: $($Processor.NumberOfCores)" `
        -Level INFO

    Write-Log `
        -Message "CPU Threads: $($Processor.NumberOfLogicalProcessors)" `
        -Level INFO

    Write-Log `
        -Message "Installed RAM: $TotalRAM GB" `
        -Level INFO

    #
    # Graphics
    #

    foreach ($GPU in $VideoControllers)
    {
        Write-Log `
            -Message "Graphics Adapter: $($GPU.Name)" `
            -Level INFO
    }

    #
    # Storage
    #

    foreach ($Disk in $LogicalDisks)
    {
        $Capacity = [math]::Round($Disk.Size / 1GB, 2)
        $FreeSpace = [math]::Round($Disk.FreeSpace / 1GB, 2)
        $UsedSpace = [math]::Round($Capacity - $FreeSpace, 2)

        Write-Log `
            -Message "Drive: $($Disk.DeviceID)" `
            -Level INFO

        if (![string]::IsNullOrWhiteSpace($Disk.VolumeName))   
        {
            Write-Log `
                -Message "Volume: $($Disk.VolumeName)" `
                -Level INFO
        }
        
        Write-Log `
            -Message "Capacity: $Capacity GB" `
            -Level INFO

        Write-Log `
            -Message "Free Space: $FreeSpace GB" `
            -Level INFO

        Write-Log `
            -Message "Used Space: $UsedSpace GB" `
            -Level INFO
    }

    #
    # System
    #

    Write-Log `
        -Message "System Uptime: $($Uptime.Days) days, $($Uptime.Hours) hours, $($Uptime.Minutes) minutes" `
        -Level INFO
}