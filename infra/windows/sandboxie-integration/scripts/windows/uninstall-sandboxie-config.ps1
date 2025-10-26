# scripts/windows/uninstall-sandboxie-config.ps1
# Restores the most recent Sandboxie.ini backup created by install-sandboxie-config.ps1

$ErrorActionPreference = "Stop"
$iniPath = "$env:ProgramData\Sandboxie-Plus\Sandboxie.ini"
if (!(Test-Path $iniPath)) { throw "Sandboxie.ini not found at $iniPath"; }

# find latest backup
$dir = Split-Path $iniPath
$backups = Get-ChildItem -Path $dir -Filter "Sandboxie.ini.bak.*" | Sort-Object LastWriteTime -Descending
if (-not $backups) { throw "No Sandboxie.ini backups found in $dir"; }

$latest = $backups[0].FullName
Write-Host "Restoring backup: $latest"

Copy-Item -Force $latest $iniPath

Write-Host "Restarting Sandboxie service..."
Start-Process sc.exe -ArgumentList "stop","SbieSvc" -WindowStyle Hidden -Wait | Out-Null
Start-Process sc.exe -ArgumentList "start","SbieSvc" -WindowStyle Hidden -Wait | Out-Null

Write-Host "Done. Current Sandboxie.ini restored from $latest"
