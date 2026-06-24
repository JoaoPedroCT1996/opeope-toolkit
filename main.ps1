
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