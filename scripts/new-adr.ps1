param(
	[Parameter(Mandatory=$true)]
	[string]$title
)

$date = Get-Date -Format 'yyyy-MM-dd'
$slug = ($title.ToLower() -replace '[^a-z0-9-]+','-').Trim('-')
$path = "docs\architecture\decisions\$date`_$slug.md"

if (Test-Path $path) {
	Write-Error "File already exists: $path"
	exit 1
}

$template = Get-Content "docs\architecture\decisions\YYYY-MM-DD_template.md" -Raw
$content = $template -replace '<TITLE>', $title -replace '<YYYY-MM-DD>', $date

Set-Content -Path $path -Value $content -Encoding UTF8

Write-Host "Created: $path" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Edit $path"
Write-Host "  2. Fill in Context, Decision, Consequences"
Write-Host "  3. git add $path"
Write-Host "  4. git commit -m 'docs: add ADR for $title'"
