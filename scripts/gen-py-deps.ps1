param(
	[string]$root = ".",
	[string]$out = "docs\architecture\py-deps.svg"
)

if (-not (Test-Path ".venv\Scripts\pydeps.exe")) {
	Write-Error "pydeps not found. Install: .\.venv\Scripts\pip install pydeps"
	exit 1
}

Write-Host "Generating Python dependency graph..." -ForegroundColor Cyan

.\.venv\Scripts\pydeps --max-bacon 2 --noshow --output $out $root

if ($LASTEXITCODE -eq 0) {
	Write-Host "Generated: $out" -ForegroundColor Green
	Write-Host ""
	Write-Host "To view:" -ForegroundColor Cyan
	Write-Host "  Open $out in browser"
} else {
	Write-Error "Failed to generate dependency graph"
	exit 1
}
