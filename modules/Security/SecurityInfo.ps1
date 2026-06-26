function Get-SecurityInformation {
    # Collects security information for diagnostics and reporting.

    try {
        $AntivirusProducts = Get-CimInstance `
            -Namespace ROOT\SecurityCenter2 `
            -ClassName AntiVirusProduct `
            -ErrorAction Stop
    }
    catch {
        $AntivirusProducts = $null
    }

    try {
        $FirewallProfiles = Get-NetFirewallProfile `
            -ErrorAction Stop
    }
    catch {
        $FirewallProfiles = $null
    }

    try {
        $BitLockerVolumes = Get-BitLockerVolume `
            -ErrorAction Stop
    }
    catch {
        $BitLockerVolumes = $null
    }

    try {
        $Tpm = Get-Tpm `
            -ErrorAction Stop
    }
    catch {
        $Tpm = $null
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
}