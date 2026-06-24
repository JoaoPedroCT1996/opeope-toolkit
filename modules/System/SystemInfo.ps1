function Get-SystemInformation
{
    # Collects basic system information for diagnostics and reporting.

    $ComputerName = $env:COMPUTERNAME
    $CurrentUser = $env:USERNAME

    $OperatingSystem = Get-CimInstance Win32_OperatingSystem
    $ComputerSystem = Get-CimInstance Win32_ComputerSystem
    $Processor = Get-CimInstance Win32_Processor

    Write-Log `
        -Message "Computer Name: $ComputerName" `
        -Level INFO

    Write-Log `
        -Message "Current User: $CurrentUser" `
        -Level INFO

    Write-Log `
        -Message "Operating System: $($OperatingSystem.Caption)" `
        -Level INFO

    Write-Log `
        -Message "OS Version: $($OperatingSystem.Version)" `
        -Level INFO

    # Convert installed physical memory from bytes to gigabytes.

    $TotalRAM = [math]::Round(
        $ComputerSystem.TotalPhysicalMemory / 1GB,
        2
    )

    Write-Log `
        -Message "Installed RAM: $TotalRAM GB" `
        -Level INFO

    Write-Log `
        -Message "Processor: $($Processor.Name)" `
        -Level INFO
}