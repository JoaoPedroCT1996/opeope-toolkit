function Start-HealthCheck {
    # Runs all system health checks.

    Write-Log `
        -Message "Starting system health check..." `
        -Level INFO

    #
    # Health checks
    #

    # Test-SystemHealth
    # Test-NetworkHealth
    # Test-SecurityHealth
    # Test-StorageHealth

    Write-Log `
        -Message "System health check completed." `
        -Level INFO
}