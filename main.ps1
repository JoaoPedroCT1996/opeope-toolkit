# Load core modules

. "$PSScriptRoot\modules\Core\AdminCheck.ps1"
. "$PSScriptRoot\modules\Core\Logger.ps1"
. "$PSScriptRoot\modules\Core\Menu.ps1"
. "$PSScriptRoot\modules\System\SystemInfo.ps1"
. "$PSScriptRoot\modules\Network\NetworkInfo.ps1"

# Creates a unique log file for the current execution.
# The log path is stored globally and shared across all modules.

$TimeStamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$Global:LogFilePath = Join-Path `
    -Path $PSScriptRoot `
    -ChildPath "logs\OOT_$TimeStamp.log"

New-Item `
    -Path $Global:LogFilePath `
    -ItemType File `
    -Force | Out-Null

# Log toolkit startup

Write-Log `
    -Message "OpeOpe Toolkit started" `
    -Level INFO

# Verify administrator privileges

if (Test-IsAdministrator)
{
    Write-Log `
        -Message "Administrator privileges confirmed" `
        -Level SUCCESS
}
else
{
    Write-Log `
        -Message "Toolkit running without administrator privileges" `
        -Level WARNING
}

# Display the main toolkit menu.

Show-MainMenu