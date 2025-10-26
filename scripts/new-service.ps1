# new-service.ps1
# Bootstrap a new service from a template

param(
  [Parameter(Mandatory=$true)]
  [ValidateSet("starter-python-api", "starter-node-service")]
  [string]$Template,

  [Parameter(Mandatory=$true)]
  [string]$Name
)

$ErrorActionPreference = "Stop"

$src = "C:\dev\templates\$Template"
$dst = "C:\dev\apps\$Name"

# Validate
if (!(Test-Path $src)) {
    throw "Template not found: $src"
}

if (Test-Path $dst) {
    throw "Target already exists: $dst. Choose a different name."
}

# Copy template
Write-Host "Creating service from template: $Template" -ForegroundColor Cyan
Copy-Item -Recurse -Force $src $dst

# Remove any template git traces
if (Test-Path "$dst\.git") {
    Write-Host "Removing template git history..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "$dst\.git"
}

# Initialize new git repo
Push-Location $dst
git init
git add .
git commit -m "feat: bootstrap $Name from $Template"
Pop-Location

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Service created successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "`nLocation: $dst" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  cd `"$dst`""
Write-Host "  cp .env.example .env"
Write-Host "  # Edit .env with your settings"
Write-Host "  docker compose up --build"
Write-Host ""
Write-Host "Then visit:" -ForegroundColor Yellow
if ($Template -eq "starter-node-service") {
    Write-Host "  http://localhost:3000/health"
} else {
    Write-Host "  http://localhost:8000/health"
}
Write-Host ""
