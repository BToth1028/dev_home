param(
	[switch]$docs,
	[switch]$structurizr,
	[switch]$backstage,
	[switch]$sourcegraph,
	[switch]$all
)

if ($all) {
	$docs = $true
	$structurizr = $true
	$backstage = $true
	$sourcegraph = $true
}

if (-not ($docs -or $structurizr -or $backstage -or $sourcegraph)) {
	Write-Host "Usage: .\scripts\up.ps1 [-docs] [-structurizr] [-backstage] [-sourcegraph] [-all]" -ForegroundColor Yellow
	Write-Host ""
	Write-Host "Start Context OS components:" -ForegroundColor Cyan
	Write-Host "  -docs         Start MkDocs on :8000"
	Write-Host "  -structurizr  Start Structurizr on :8081"
	Write-Host "  -backstage    Start Backstage on :7007"
	Write-Host "  -sourcegraph  Start Sourcegraph on :7080"
	Write-Host "  -all          Start everything"
	exit 0
}

if ($docs) {
	Write-Host "Starting MkDocs..." -ForegroundColor Cyan
	if (Test-Path ".venv\Scripts\mkdocs.exe") {
		Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd C:\DEV; .\.venv\Scripts\mkdocs serve"
		Write-Host "  MkDocs: http://localhost:8000" -ForegroundColor Green
	} else {
		Write-Warning "MkDocs not installed. Run: .\.venv\Scripts\pip install mkdocs-material mkdocs-mermaid2"
	}
}

if ($structurizr) {
	Write-Host "Starting Structurizr..." -ForegroundColor Cyan
	$port = if ($env:STRUCTURIZR_PORT) { $env:STRUCTURIZR_PORT } else { "8081" }
	docker run -d --name structurizr `
		-p ${port}:8080 `
		-v C:\DEV\docs\architecture\c4:/usr/local/structurizr `
		structurizr/lite 2>$null

	if ($LASTEXITCODE -eq 0) {
		Write-Host "  Structurizr: http://localhost:$port" -ForegroundColor Green
	} else {
		Write-Warning "Failed to start Structurizr (may already be running)"
	}
}

if ($backstage) {
	Write-Host "Starting Backstage..." -ForegroundColor Cyan
	if (Test-Path "backstage\package.json") {
		Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd C:\DEV\backstage; yarn install; yarn dev"
		Write-Host "  Backstage: http://localhost:7007" -ForegroundColor Green
	} else {
		Write-Warning "Backstage not installed. Run: npx @backstage/create-app@latest"
		Write-Warning "  Choose folder: C:\DEV\backstage"
	}
}

if ($sourcegraph) {
	Write-Host "Starting Sourcegraph..." -ForegroundColor Cyan
	if (Test-Path "sourcegraph\docker-compose.yaml") {
		Push-Location sourcegraph
		docker compose up -d
		Pop-Location
		Write-Host "  Sourcegraph: http://localhost:7080" -ForegroundColor Green
	} else {
		Write-Warning "Sourcegraph config not found at sourcegraph\docker-compose.yaml"
	}
}

Write-Host ""
Write-Host "Context OS started!" -ForegroundColor Green
Write-Host ""
Write-Host "Check status:" -ForegroundColor Cyan
Write-Host "  .\scripts\smoke.ps1"
