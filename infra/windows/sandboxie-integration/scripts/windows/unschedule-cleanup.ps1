# scripts/windows/unschedule-cleanup.ps1
# Remove scheduled cleanup tasks

$ErrorActionPreference = "Stop"

Write-Host "Removing scheduled cleanup tasks..."

try {
    schtasks /Delete /TN "Sandboxie_Cleanup_Daily" /F 2>$null
    Write-Host "Removed Sandboxie_Cleanup_Daily"
} catch {
    Write-Host "Sandboxie_Cleanup_Daily not found (may not exist)"
}

try {
    schtasks /Delete /TN "Sandboxie_Cleanup_Weekly" /F 2>$null
    Write-Host "Removed Sandboxie_Cleanup_Weekly"
} catch {
    Write-Host "Sandboxie_Cleanup_Weekly not found (may not exist)"
}

Write-Host "Done."

