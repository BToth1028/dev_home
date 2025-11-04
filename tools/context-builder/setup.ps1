# Setup script for Cursor Hot Context system

$ErrorActionPreference = "Stop"

Write-Host "🚀 Setting up Cursor Hot Context system..." -ForegroundColor Cyan
Write-Host ""

# Check Docker
Write-Host "1️⃣  Checking Docker..." -ForegroundColor Yellow
try {
	docker --version | Out-Null
	Write-Host "   ✅ Docker installed" -ForegroundColor Green
}
catch {
	Write-Host "   ❌ Docker not found. Install Docker Desktop first." -ForegroundColor Red
	exit 1
}

# Start services
Write-Host "`n2️⃣  Starting Qdrant and Ollama..." -ForegroundColor Yellow
docker-compose up -d
Start-Sleep -Seconds 5

# Check Qdrant
Write-Host "`n3️⃣  Checking Qdrant..." -ForegroundColor Yellow
try {
	$response = Invoke-RestMethod -Uri "http://localhost:6333" -TimeoutSec 5
	Write-Host "   ✅ Qdrant running" -ForegroundColor Green
}
catch {
	Write-Host "   ❌ Qdrant not responding" -ForegroundColor Red
	exit 1
}

# Pull embedding model
Write-Host "`n4️⃣  Pulling embedding model..." -ForegroundColor Yellow
$ollamaContainer = docker ps --filter "name=cursor_ollama" --format "{{.ID}}"
if ($ollamaContainer) {
	docker exec $ollamaContainer ollama pull nomic-embed-text
	Write-Host "   ✅ Model downloaded" -ForegroundColor Green
}
else {
	Write-Host "   ❌ Ollama container not running" -ForegroundColor Red
	exit 1
}

# Install Python dependencies
Write-Host "`n5️⃣  Installing Python dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt
Write-Host "   ✅ Dependencies installed" -ForegroundColor Green

# Initial index
Write-Host "`n6️⃣  Creating initial index..." -ForegroundColor Yellow
python build_context.py refresh
Write-Host "   ✅ Initial context generated" -ForegroundColor Green

# Set up Task Scheduler
Write-Host "`n7️⃣  Setting up nightly refresh..." -ForegroundColor Yellow
$scriptPath = Join-Path $PSScriptRoot "refresh.ps1"
$action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -Daily -At 3am

# Remove existing task if present
Unregister-ScheduledTask -TaskName "CursorContextRefresh" -Confirm:$false -ErrorAction SilentlyContinue

Register-ScheduledTask -TaskName "CursorContextRefresh" `
	-Action $action `
	-Trigger $trigger `
	-Description "Refresh Cursor hot context nightly" `
	-RunLevel Highest | Out-Null

Write-Host "   ✅ Scheduled task created (runs daily at 3 AM)" -ForegroundColor Green

# Set up pre-commit hook
Write-Host "`n8️⃣  Setting up pre-commit hook..." -ForegroundColor Yellow
$hookPath = "..\..\..\.git\hooks\pre-commit"
$hookContent = @"
#!/bin/bash
# Regenerate hot context if docs changed

if git diff --cached --name-only | grep -qE '^docs/|README.md'; then
    echo "📝 Docs changed, regenerating hot context..."
    cd tools/context-builder
    python build_context.py refresh
    git add ../../.cursor/rules/context-hot.mdc
    echo "✅ Hot context updated"
fi
"@

Set-Content -Path $hookPath -Value $hookContent -Encoding UTF8
# Make executable (Git Bash will handle this)
Write-Host "   ✅ Pre-commit hook created" -ForegroundColor Green

# Summary
Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host "="*60 -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  • Open Cursor - it will automatically read .cursor/rules/context-hot.mdc"
Write-Host "  • Context refreshes nightly at 3 AM"
Write-Host "  • Context regenerates on commit when docs change"
Write-Host ""
Write-Host "Manual commands:" -ForegroundColor Yellow
Write-Host "  python build_context.py health    # Check services"
Write-Host "  python build_context.py refresh   # Manual refresh"
Write-Host ""
Write-Host "Generated file:" -ForegroundColor Yellow
Write-Host "  .cursor\rules\context-hot.mdc"
Write-Host ""
