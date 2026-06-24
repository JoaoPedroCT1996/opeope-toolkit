function Write-Log
{
    # Writes formatted log entries to the OpeOpe Toolkit log file.
    # Supports INFO, SUCCESS, WARNING and ERROR severity levels.
    param(
        [string]$Message,

        [ValidateSet("INFO","SUCCESS","WARNING","ERROR")]
        [string]$Level
    )
}