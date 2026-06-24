function Get-NetworkInformation
{
    # Collects basic network information for diagnostics and reporting.

    $NetworkConfiguration = Get-NetIPConfiguration |
        Where-Object {
            $null -ne $_.IPv4Address -and
            $null -ne $_.IPv4DefaultGateway
        } |
        Select-Object -First 1

    $NetworkAdapter = Get-NetAdapter |
        Where-Object {
            $_.InterfaceAlias -eq $NetworkConfiguration.InterfaceAlias
        }

    Write-Log `
        -Message "Network Adapter: $($NetworkConfiguration.InterfaceAlias)" `
        -Level INFO

    Write-Log `
        -Message "Adapter Status: $($NetworkAdapter.Status)" `
        -Level INFO

    Write-Log `
        -Message "Link Speed: $($NetworkAdapter.LinkSpeed)" `
        -Level INFO

    Write-Log `
        -Message "MAC Address: $($NetworkAdapter.MacAddress)" `
        -Level INFO

    Write-Log `
        -Message "IPv4 Address: $($NetworkConfiguration.IPv4Address.IPAddress)" `
        -Level INFO

    Write-Log `
        -Message "Default Gateway: $($NetworkConfiguration.IPv4DefaultGateway.NextHop)" `
        -Level INFO

    Write-Log `
        -Message "DNS Servers: $($NetworkConfiguration.DNSServer.ServerAddresses -join ', ')" `
        -Level INFO
}