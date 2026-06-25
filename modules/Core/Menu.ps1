
function Wait-Toolkit
{
    # Waits for user confirmation before returning to the menu.

    Write-Host ""
    Read-Host "Press Enter to return to the menu"
}

function Show-MainMenu
{
    # Displays the main toolkit menu and handles user selection.

    do
    {
        Clear-Host

        Write-Host ""
        Write-Host "================================"
        Write-Host "         OpeOpe Toolkit"
        Write-Host "================================"
        Write-Host ""
        Write-Host "1. System Information"
        Write-Host "2. Network Information"
        Write-Host "3. Security Information"
        Write-Host "0. Exit"
        Write-Host ""

        $Option = Read-Host "Select an option"

        switch ($Option)
        {
            "1"
            {
                Get-SystemInformation
                Wait-Toolkit
            }

            "2"
            {
                Get-NetworkInformation
                Wait-Toolkit
            }

            "3"
            {
                Get-SecurityInformation
                Wait-Toolkit
            }

            "0"
            {
                return
            }

            default
            {
                Write-Host "Invalid option"
                Wait-Toolkit
            }
        }

    } while ($Option -ne "0")
}