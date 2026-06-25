function Get-SecurityInformation
{
    # Collects security information for diagnostics and reporting.

    $AntivirusProducts = Get-CimInstance `
        -Namespace ROOT\SecurityCenter2 `
        -ClassName AntiVirusProduct

    #
    # Antivirus
    #

    foreach ($Antivirus in $AntivirusProducts)
    {
        Write-Log `
            -Message "Registered Antivirus: $($Antivirus.displayName)" `
            -Level INFO
    }
}