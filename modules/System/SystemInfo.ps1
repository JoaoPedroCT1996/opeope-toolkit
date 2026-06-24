
function Get-SystemInformation
{
    # Collects basic system information for diagnostics and reporting.

    $ComputerName = $env:COMPUTERNAME
    $CurrentUser = $env:USERNAME

    Write-Log `
        -Message "Computer Name: $ComputerName" `
        -Level INFO

    Write-Log `
        -Message "Current User: $CurrentUser" `
        -Level INFO
}