$ts = Get-Date -Format 'yyyyMMdd_HHmmss'
$dest = "backups\sourcegraph_$ts.tar.gz"

if (-not (Test-Path "backups")) {
	New-Item -Type Directory -Force backups | Out-Null
}

Write-Host "Backing up Sourcegraph data..." -ForegroundColor Cyan

try {
	docker exec sourcegraph-frontend sh -c "src backup" | Set-Content $dest
	Write-Host "Backup saved: $dest" -ForegroundColor Green
	Write-Host ""
	Write-Host "Backup size: $((Get-Item $dest).Length / 1MB) MB" -ForegroundColor Cyan
} catch {
	Write-Error "Backup failed: $($_.Exception.Message)"
	Write-Host ""
	Write-Host "Is Sourcegraph running?" -ForegroundColor Yellow
	Write-Host "  .\scripts\up.ps1 -sourcegraph"
	exit 1
}
