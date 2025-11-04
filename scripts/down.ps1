Write-Host "Stopping Context OS components..." -ForegroundColor Cyan

Write-Host "Stopping Structurizr..." -ForegroundColor Yellow
docker rm -f structurizr 2>$null
if ($LASTEXITCODE -eq 0) {
	Write-Host "  Structurizr stopped" -ForegroundColor Green
}

Write-Host "Stopping Sourcegraph..." -ForegroundColor Yellow
if (Test-Path "sourcegraph") {
	Push-Location sourcegraph
	docker compose down 2>$null
	Pop-Location
	if ($LASTEXITCODE -eq 0) {
		Write-Host "  Sourcegraph stopped" -ForegroundColor Green
	}
}

Write-Host ""
Write-Host "Stopped!" -ForegroundColor Green
Write-Host ""
Write-Host "Note: MkDocs and Backstage run in separate PowerShell windows." -ForegroundColor Cyan
Write-Host "Close those windows manually or press Ctrl+C in them."
