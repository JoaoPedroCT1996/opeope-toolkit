function Get-NetworkInformation
{
    # Collects basic network information for diagnostics and reporting.

    $NetworkConfiguration = Get-NetIPConfiguration |
        Where-Object {
            $_.NetAdapter.Status -eq "Up" -and
            $null -ne $_.IPv4Address
        } |
        Select-Object -First 1

    if ($null -eq $NetworkConfiguration)
    {
        Write-Log `
            -Message "No active network adapter found" `
            -Level WARNING

        return
    }

    $NetworkAdapter = Get-NetAdapter |
        Where-Object {
            $_.InterfaceAlias -eq $NetworkConfiguration.InterfaceAlias
        }

    $NetworkProfile = Get-NetConnectionProfile |
        Where-Object {
            $_.InterfaceAlias -eq $NetworkConfiguration.InterfaceAlias
        }

    $DHCP = Get-NetIPInterface `
        -InterfaceIndex $NetworkConfiguration.InterfaceIndex `
        -AddressFamily IPv4

    # Determine interface type.

    if ($NetworkAdapter.InterfaceDescription -match "Wireless|Wi-Fi|WLAN|802\.11")
    {
        $InterfaceType = "Wi-Fi"
    }
    else
    {
        $InterfaceType = "Ethernet"
    }

    # Collect IPv4 and IPv6 information.

    $IPv6Addresses = Get-NetIPAddress `
        -InterfaceIndex $NetworkConfiguration.InterfaceIndex `
        -AddressFamily IPv6 |
        Where-Object {
            $_.IPAddress -ne "::1"
        }

    #
    # Adapter
    #

    Write-Log `
        -Message "Network Adapter: $($NetworkConfiguration.InterfaceAlias)" `
        -Level INFO

    Write-Log `
        -Message "Adapter Status: $($NetworkAdapter.Status)" `
        -Level INFO

    Write-Log `
        -Message "Interface Type: $InterfaceType" `
        -Level INFO

    Write-Log `
        -Message "Link Speed: $($NetworkAdapter.LinkSpeed)" `
        -Level INFO

    Write-Log `
        -Message "MAC Address: $($NetworkAdapter.MacAddress)" `
        -Level INFO

    #
    # Network
    #

    if (![string]::IsNullOrWhiteSpace($NetworkProfile.Name))
    {
        Write-Log `
            -Message "Network Name: $($NetworkProfile.Name)" `
            -Level INFO
    }

    if ($null -ne $NetworkProfile.NetworkCategory)
    {
        Write-Log `
            -Message "Network Profile: $($NetworkProfile.NetworkCategory)" `
            -Level INFO
    }

    Write-Log `
        -Message "IPv4 Address: $($NetworkConfiguration.IPv4Address.IPAddress)" `
        -Level INFO

    foreach ($IPv6 in $IPv6Addresses)
    {
        if ($IPv6.IPAddress.StartsWith("fe80:"))
        {
            Write-Log `
                -Message "IPv6 Link-Local: $($IPv6.IPAddress)" `
                -Level INFO
        }
        else
        {
            Write-Log `
                -Message "IPv6 Global: $($IPv6.IPAddress)" `
                -Level INFO
        }
    }

    if ($null -ne $NetworkConfiguration.IPv4DefaultGateway)
    {
        Write-Log `
            -Message "Default Gateway: $($NetworkConfiguration.IPv4DefaultGateway.NextHop)" `
            -Level INFO
    }

    if ($null -ne $NetworkConfiguration.DNSServer.ServerAddresses)
    {
        Write-Log `
            -Message "DNS Servers: $($NetworkConfiguration.DNSServer.ServerAddresses -join ', ')" `
            -Level INFO
    }

    Write-Log `
        -Message "DHCP Enabled: $($DHCP.Dhcp)" `
        -Level INFO

    #
    # Connectivity
    #

    $InternetAvailable = Test-Connection `
        -ComputerName "8.8.8.8" `
        -Count 1 `
        -Quiet `
        -ErrorAction SilentlyContinue

    Write-Log `
        -Message "Internet Connectivity: $(if ($InternetAvailable) { "Available" } else { "Unavailable" })" `
        -Level INFO

    if ($null -ne $NetworkConfiguration.IPv4DefaultGateway)
    {
        $GatewayReachable = Test-Connection `
            -ComputerName $NetworkConfiguration.IPv4DefaultGateway.NextHop `
            -Count 1 `
            -Quiet `
            -ErrorAction SilentlyContinue

        Write-Log `
            -Message "Gateway Reachable: $(if ($GatewayReachable) { "Yes" } else { "No" })" `
            -Level INFO

        if ($GatewayReachable)
        {
            $Latency = Test-Connection `
                -ComputerName $NetworkConfiguration.IPv4DefaultGateway.NextHop `
                -Count 1 `
                -ErrorAction SilentlyContinue

            Write-Log `
                -Message "Gateway Latency: $($Latency.Latency) ms" `
                -Level INFO
        }
    }
}