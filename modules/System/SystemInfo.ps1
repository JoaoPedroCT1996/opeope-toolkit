function Get-SystemInformation {
    # Collects basic system information for diagnostics and reporting.

    $ComputerName = $env:COMPUTERNAME
    $CurrentUser = $env:USERNAME

    #
    # Operating System
    #

    try {
        $OperatingSystem = Get-CimInstance `
            -ClassName Win32_OperatingSystem `
            -ErrorAction Stop
    }
    catch {
        $OperatingSystem = $null
    }

    #
    # Computer System
    #

    try {
        $ComputerSystem = Get-CimInstance `
            -ClassName Win32_ComputerSystem `
            -ErrorAction Stop
    }
    catch {
        $ComputerSystem = $null
    }

    #
    # Motherboard
    #

    try {
        $BaseBoard = Get-CimInstance `
            -ClassName Win32_BaseBoard `
            -ErrorAction Stop
    }
    catch {
        $BaseBoard = $null
    }

    #
    # BIOS
    #

    try {
        $BIOS = Get-CimInstance `
            -ClassName Win32_BIOS `
            -ErrorAction Stop
    }
    catch {
        $BIOS = $null
    }

    #
    # Processor
    #

    try {
        $Processor = Get-CimInstance `
            -ClassName Win32_Processor `
            -ErrorAction Stop
    }
    catch {
        $Processor = $null
    }

    #
    # Graphics
    #

    try {
        $VideoControllers = Get-CimInstance `
            -ClassName Win32_VideoController `
            -ErrorAction Stop
    }
    catch {
        $VideoControllers = $null
    }

    #
    # Logical Disks
    #

    try {
        $LogicalDisks = Get-CimInstance `
            -ClassName Win32_LogicalDisk `
            -Filter "DriveType = 3" `
            -ErrorAction Stop |
        Where-Object { $_.Size -gt 50GB }
    }
    catch {
        $LogicalDisks = $null
    }

    #
    # Calculate derived information
    #

    $TotalRAM = $null
    $BIOSReleaseDate = $null
    $Uptime = $null

    if ($null -ne $ComputerSystem) {
        $TotalRAM = [math]::Round(
            $ComputerSystem.TotalPhysicalMemory / 1GB,
            2
        )
    }


    #
    # Format BIOS release date
    #

    if ($null -ne $BIOS) {
        $BIOSReleaseDate = $BIOS.ReleaseDate.ToString("yyyy-MM-dd")
    }

    #
    # Calculate system uptime
    #

    if ($null -ne $OperatingSystem) {
        $Uptime = (Get-Date) - $OperatingSystem.LastBootUpTime
    }

    #
    # Computer
    #

    Write-Log `
        -Message "Computer Name: $ComputerName" `
        -Level INFO

    Write-Log `
        -Message "Current User: $CurrentUser" `
        -Level INFO

    if ($null -ne $ComputerSystem) {

        Write-Log `
            -Message "Manufacturer: $($ComputerSystem.Manufacturer)" `
            -Level INFO
    }
    else {

        Write-Log `
            -Message "Computer system information is unavailable" `
            -Level WARNING
    }

    if ($null -ne $BaseBoard) {

        Write-Log `
            -Message "Motherboard: $($BaseBoard.Product)" `
            -Level INFO
    }
    else {

        Write-Log `
            -Message "Motherboard information is unavailable" `
            -Level WARNING
    }

    #
    # Operating System
    #

    if ($null -ne $OperatingSystem) {

        Write-Log `
            -Message "Operating System: $($OperatingSystem.Caption)" `
            -Level INFO

        Write-Log `
            -Message "OS Version: $($OperatingSystem.Version)" `
            -Level INFO
    }
    else {

        Write-Log `
            -Message "Operating system information is unavailable" `
            -Level WARNING
    }

    #
    # BIOS
    #

    if ($null -ne $BIOS) {

        Write-Log `
            -Message "BIOS Manufacturer: $($BIOS.Manufacturer)" `
            -Level INFO

        Write-Log `
            -Message "BIOS Version: $($BIOS.SMBIOSBIOSVersion)" `
            -Level INFO

        Write-Log `
            -Message "BIOS Release Date: $BIOSReleaseDate" `
            -Level INFO
    }
    else {

        Write-Log `
            -Message "BIOS information is unavailable" `
            -Level WARNING
    }

    #
    # Processor and Memory
    #

    if ($null -ne $Processor) {

        Write-Log `
            -Message "Processor: $($Processor.Name)" `
            -Level INFO

        Write-Log `
            -Message "CPU Cores: $($Processor.NumberOfCores)" `
            -Level INFO

        Write-Log `
            -Message "CPU Threads: $($Processor.NumberOfLogicalProcessors)" `
            -Level INFO
    }
    else {

        Write-Log `
            -Message "Processor information is unavailable" `
            -Level WARNING
    }

    if ($null -ne $ComputerSystem) {

        Write-Log `
            -Message "Installed RAM: $TotalRAM GB" `
            -Level INFO
    }
    else {

        Write-Log `
            -Message "Memory information is unavailable" `
            -Level WARNING
    }

    #
    # Graphics
    #

    if ($null -eq $VideoControllers) {

        Write-Log `
            -Message "Graphics information is unavailable" `
            -Level WARNING
    }
    else {

        foreach ($GPU in $VideoControllers) {

            Write-Log `
                -Message "Graphics Adapter: $($GPU.Name)" `
                -Level INFO
        }
    }

    #
    # Storage
    #

    if ($null -eq $LogicalDisks) {

        Write-Log `
            -Message "Storage information is unavailable" `
            -Level WARNING
    }
    else {

        foreach ($Disk in $LogicalDisks) {

            $Capacity = [math]::Round($Disk.Size / 1GB, 2)
            $FreeSpace = [math]::Round($Disk.FreeSpace / 1GB, 2)
            $UsedSpace = [math]::Round($Capacity - $FreeSpace, 2)

            Write-Log `
                -Message "Drive: $($Disk.DeviceID)" `
                -Level INFO

            if (![string]::IsNullOrWhiteSpace($Disk.VolumeName)) {

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
    }

    #
    # System
    #

    if ($null -ne $Uptime) {

        Write-Log `
            -Message "System Uptime: $($Uptime.Days) days, $($Uptime.Hours) hours, $($Uptime.Minutes) minutes" `
            -Level INFO
    }
    else {

        Write-Log `
            -Message "System uptime information is unavailable" `
            -Level WARNING
    }
}