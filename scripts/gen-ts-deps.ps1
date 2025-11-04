param(
	[string]$src = "src",
	[string]$out = "docs\architecture\ts-deps.dot"
)

if (-not (Test-Path "node_modules")) {
	Write-Error "node_modules not found. Run: npm install"
	exit 1
}

if (-not (Test-Path $src)) {
	Write-Warning "Source directory not found: $src"
	Write-Host "Run this from a project with TypeScript source code." -ForegroundColor Yellow
	exit 1
}

Write-Host "Generating TypeScript dependency graph..." -ForegroundColor Cyan

npx depcruise --include-only "$src" --output-type dot $src | Out-File -Encoding utf8 $out

if ($LASTEXITCODE -eq 0) {
	Write-Host "Generated: $out" -ForegroundColor Green
	Write-Host ""
	Write-Host "To view:" -ForegroundColor Cyan
	Write-Host "  1. Install Graphviz: winget install graphviz"
	Write-Host "  2. dot -Tsvg $out -o docs\architecture\ts-deps.svg"
	Write-Host "  3. Open docs\architecture\ts-deps.svg in browser"
} else {
	Write-Error "Failed to generate dependency graph"
	exit 1
}
