$errors = @()

function Check($name, $url) {
	Write-Host "Checking $name..." -NoNewline
	try {
		$r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
		if ($r.StatusCode -eq 200) {
			Write-Host " OK" -ForegroundColor Green
		} else {
			Write-Host " FAIL ($($r.StatusCode))" -ForegroundColor Red
			$script:errors += "$name returned $($r.StatusCode)"
		}
	} catch {
		Write-Host " FAIL" -ForegroundColor Red
		$script:errors += "$name`: $($_.Exception.Message)"
	}
}

Write-Host "Running smoke tests..." -ForegroundColor Cyan
Write-Host ""

Check "MkDocs" "http://localhost:8000"
Check "Structurizr" "http://localhost:8081"
Check "Backstage" "http://localhost:7007"
Check "Sourcegraph" "http://localhost:7080"
Check "Status API" "http://localhost:5050/health"
Check "Status Node" "http://localhost:5051/health"

Write-Host ""

if ($errors.Count -gt 0) {
	Write-Host "Errors found:" -ForegroundColor Red
	$errors | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
	Write-Host ""
	Write-Host "Start systems with: .\scripts\up.ps1 -all" -ForegroundColor Yellow
	exit 1
} else {
	Write-Host "All systems operational!" -ForegroundColor Green
	exit 0
}
