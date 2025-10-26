# scripts/windows/schedule-cleanup.ps1
$ErrorActionPreference = "Stop"
$ps = (Get-Command powershell.exe).Source
$root = Split-Path -Parent $PSScriptRoot
$script = Join-Path $PSScriptRoot "clean-all-boxes.ps1"

# Daily at 3:00 AM
schtasks /Create /TN "Sandboxie_Cleanup_Daily" /TR "`"$ps`" -NoProfile -ExecutionPolicy Bypass -File `"$script`"" /SC DAILY /ST 03:00 /RL HIGHEST /F

# Weekly (Sunday) at 3:00 AM
schtasks /Create /TN "Sandboxie_Cleanup_Weekly" /TR "`"$ps`" -NoProfile -ExecutionPolicy Bypass -File `"$script`"" /SC WEEKLY /D SUN /ST 03:00 /RL HIGHEST /F

Write-Host "Scheduled tasks created. Disable one if you only want a single schedule."

