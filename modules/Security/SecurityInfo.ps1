function Get-SecurityInformation
{
    # Collects security information for diagnostics and reporting.

    $AntivirusProducts = Get-CimInstance `
        -Namespace ROOT\SecurityCenter2 `
        -ClassName AntiVirusProduct

    $FirewallProfiles = Get-NetFirewallProfile

    #
    # Validate collected information.
    #

    if ($null -eq $AntivirusProducts)
    {
        Write-Log `
            -Message "No registered antivirus products found" `
            -Level WARNING

        return
    }

    if ($null -eq $FirewallProfiles)
    {
        Write-Log `
            -Message "No firewall profiles found" `
            -Level WARNING

        return
    }

    #
    # Antivirus
    #

    foreach ($Antivirus in $AntivirusProducts)
    {
        Write-Log `
            -Message "Registered Antivirus: $($Antivirus.displayName)" `
            -Level INFO
    }

    #
    # Firewall
    #

    foreach ($FirewallProfile in $FirewallProfiles)
    {
        Write-Log `
            -Message "Firewall Profile: $($FirewallProfile.Name)" `
            -Level INFO

        Write-Log `
            -Message "Firewall Status: $(if ($FirewallProfile.Enabled) { "Enabled" } else { "Disabled" })" `
            -Level INFO
    }
}