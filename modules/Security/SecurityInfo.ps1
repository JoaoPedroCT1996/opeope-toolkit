function Get-SecurityInformation {
    # Collects security information for diagnostics and reporting.

    #
    # Antivirus
    #

    try {
        $AntivirusProducts = Get-CimInstance `
            -Namespace ROOT\SecurityCenter2 `
            -ClassName AntiVirusProduct `
            -ErrorAction Stop
    }
    catch {
        $AntivirusProducts = $null
    }

    #
    # Firewall
    #

    try {
        $FirewallProfiles = Get-NetFirewallProfile `
            -ErrorAction Stop
    }
    catch {
        $FirewallProfiles = $null
    }

    #
    # BitLocker
    #

    try {
        $BitLockerVolumes = Get-BitLockerVolume `
            -ErrorAction Stop
    }
    catch {
        $BitLockerVolumes = $null
    }

    #
    # TPM
    #

    try {
        $Tpm = Get-Tpm `
            -ErrorAction Stop
    }
    catch {
        $Tpm = $null
    }

    #
    # Secure Boot
    #

    try {
        $SecureBoot = Confirm-SecureBootUEFI `
            -ErrorAction Stop
    }
    catch {
        $SecureBoot = $null
    }

    #
    # Microsoft Defender
    #

    try {
        $MpComputerStatus = Get-MpComputerStatus `
            -ErrorAction Stop
    }
    catch {
        $MpComputerStatus = $null
    }

    #
    # Device Guard
    #

    try {
        $DeviceGuard = Get-CimInstance `
            -Namespace root\Microsoft\Windows\DeviceGuard `
            -ClassName Win32_DeviceGuard `
            -ErrorAction Stop
    }
    catch {
        $DeviceGuard = $null
    }


    #
    # Antivirus
    #

    if ($null -eq $AntivirusProducts) {
        Write-Log `
            -Message "No registered antivirus products found" `
            -Level WARNING
    }
    else {
        foreach ($Antivirus in $AntivirusProducts) {
            Write-Log `
                -Message "Registered Antivirus: $($Antivirus.displayName)" `
                -Level INFO
        }
    }

    #
    # Firewall
    #

    if ($null -eq $FirewallProfiles) {
        Write-Log `
            -Message "No firewall profiles found" `
            -Level WARNING
    }
    else {
        foreach ($FirewallProfile in $FirewallProfiles) {
            Write-Log `
                -Message "Firewall Profile: $($FirewallProfile.Name)" `
                -Level INFO

            Write-Log `
                -Message "Firewall Status: $(if ($FirewallProfile.Enabled) { "Enabled" } else { "Disabled" })" `
                -Level INFO
        }
    }

    #
    # BitLocker
    #

    if ($null -eq $BitLockerVolumes) {
        Write-Log `
            -Message "BitLocker information is unavailable" `
            -Level WARNING
    }
    else {
        foreach ($BitLockerVolume in $BitLockerVolumes) {
            Write-Log `
                -Message "Drive: $($BitLockerVolume.MountPoint)" `
                -Level INFO

            Write-Log `
                -Message "Volume Type: $($BitLockerVolume.VolumeType)" `
                -Level INFO

            Write-Log `
                -Message "Protection Status: $($BitLockerVolume.ProtectionStatus)" `
                -Level INFO

            Write-Log `
                -Message "Volume Status: $($BitLockerVolume.VolumeStatus)" `
                -Level INFO

            Write-Log `
                -Message "Encryption: $($BitLockerVolume.EncryptionPercentage)%" `
                -Level INFO
        }
    }

    #
    # TPM
    #

    if ($null -eq $Tpm) {
        Write-Log `
            -Message "TPM information is unavailable" `
            -Level WARNING
    }
    elseif (-not $Tpm.TpmPresent) {
        Write-Log `
            -Message "TPM is not present" `
            -Level INFO
    }
    else {
        Write-Log `
            -Message "TPM Present: $($Tpm.TpmPresent)" `
            -Level INFO

        Write-Log `
            -Message "TPM Ready: $($Tpm.TpmReady)" `
            -Level INFO

        Write-Log `
            -Message "TPM Enabled: $($Tpm.TpmEnabled)" `
            -Level INFO

        Write-Log `
            -Message "TPM Activated: $($Tpm.TpmActivated)" `
            -Level INFO

        Write-Log `
            -Message "Manufacturer: $($Tpm.ManufacturerIdTxt)" `
            -Level INFO

        Write-Log `
            -Message "Manufacturer Version: $($Tpm.ManufacturerVersion)" `
            -Level INFO
    }

    #
    # Secure Boot
    #

    if ($null -eq $SecureBoot) {
        Write-Log `
            -Message "Secure Boot information is unavailable" `
            -Level WARNING
    }
    else {
        Write-Log `
            -Message "Secure Boot: $(if ($SecureBoot) { "Enabled" } else { "Disabled" })" `
            -Level INFO
    }

    #
    # Microsoft Defender
    #

    if ($null -eq $MpComputerStatus) {
        Write-Log `
            -Message "Microsoft Defender information is unavailable" `
            -Level WARNING
    }
    else {
        Write-Log `
            -Message "Running Mode: $($MpComputerStatus.AMRunningMode)" `
            -Level INFO

        Write-Log `
            -Message "Service Enabled: $($MpComputerStatus.AMServiceEnabled)" `
            -Level INFO

        Write-Log `
            -Message "Antivirus Enabled: $($MpComputerStatus.AntivirusEnabled)" `
            -Level INFO

        Write-Log `
            -Message "Real-Time Protection: $($MpComputerStatus.RealTimeProtectionEnabled)" `
            -Level INFO

        Write-Log `
            -Message "Behavior Monitoring: $($MpComputerStatus.BehaviorMonitorEnabled)" `
            -Level INFO

        Write-Log `
            -Message "IOAV Protection: $($MpComputerStatus.IoavProtectionEnabled)" `
            -Level INFO

        Write-Log `
            -Message "Tamper Protection: $($MpComputerStatus.IsTamperProtected)" `
            -Level INFO

        Write-Log `
            -Message "Engine Version: $($MpComputerStatus.AMEngineVersion)" `
            -Level INFO

        Write-Log `
            -Message "Product Version: $($MpComputerStatus.AMProductVersion)" `
            -Level INFO

        Write-Log `
            -Message "Signature Version: $($MpComputerStatus.AntivirusSignatureVersion)" `
            -Level INFO

        Write-Log `
            -Message "Signatures Out Of Date: $($MpComputerStatus.DefenderSignaturesOutOfDate)" `
            -Level INFO

        Write-Log `
            -Message "Reboot Required: $($MpComputerStatus.RebootRequired)" `
            -Level INFO
    }

    #
    # Device Guard
    #

    if ($null -eq $DeviceGuard) {

        Write-Log `
            -Message "Device Guard information is unavailable" `
            -Level WARNING
    }
    else {

        #
        # Virtualization-Based Security
        #

        switch ($DeviceGuard.VirtualizationBasedSecurityStatus) {

            0 { $VbsStatus = "Disabled" }
            1 { $VbsStatus = "Enabled (Not Running)" }
            2 { $VbsStatus = "Running" }

            default { $VbsStatus = "Unknown" }
        }

        Write-Log `
            -Message "Virtualization-Based Security: $VbsStatus" `
            -Level INFO

        #
        # Code Integrity
        #

        switch ($DeviceGuard.CodeIntegrityPolicyEnforcementStatus) {

            0 { $CodeIntegrity = "Disabled" }
            1 { $CodeIntegrity = "Audit Mode" }
            2 { $CodeIntegrity = "Enabled" }

            default { $CodeIntegrity = "Unknown" }
        }

        Write-Log `
            -Message "Code Integrity Policy: $CodeIntegrity" `
            -Level INFO

        #
        # Virtual Machine Isolation
        #

        Write-Log `
            -Message "Virtual Machine Isolation: $(if ($DeviceGuard.VirtualMachineIsolation) { "Enabled" } else { "Disabled" })" `
            -Level INFO
    }


}