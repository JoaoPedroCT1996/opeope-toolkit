function Show-MainMenu
{
    # Displays the main toolkit menu and handles user selection.

    do
    {
        Write-Host ""
        Write-Host "================================"
        Write-Host "         OpeOpe Toolkit"
        Write-Host "================================"
        Write-Host ""
        Write-Host "1. System Information"
        Write-Host "0. Exit"
        Write-Host ""

        $Option = Read-Host "Select an option"

        switch ($Option)
        {
            "1"
            {
                Get-SystemInformation

                Write-Host ""
                Read-Host "Press Enter to return to the menu"
            }

            "0"
            {
                return
            }

            default
            {
                Write-Host "Invalid option"

                Write-Host ""
                Read-Host "Press Enter to continue"
            }
        }

    } while ($Option -ne "0")
}