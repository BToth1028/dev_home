# Nightly context refresh script
# Run via Task Scheduler at 3 AM

$ErrorActionPreference = "Stop"

cd $PSScriptRoot

Write-Host "🔄 Starting context refresh..." -ForegroundColor Cyan
Write-Host "   Time: $(Get-Date)" -ForegroundColor Gray

try {
	python build_context.py refresh
	Write-Host "`n✅ Context refresh complete" -ForegroundColor Green
	exit 0
}
catch {
	Write-Host "`n❌ Context refresh failed: $_" -ForegroundColor Red
	exit 1
}
