# new-service.ps1
# Bootstrap a new service from a template with full validation and setup

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("starter-python-api", "starter-node-service")]
    [string]$Template,
    
    [Parameter(Mandatory=$true)]
    [ValidatePattern("^[a-z0-9-]+$")]
    [string]$Name,
    
    [Parameter(Mandatory=$false)]
    [int]$Port = 0
)

$ErrorActionPreference = "Stop"

# Validate name
if ($Name -match "[\[\]\(\)\{\}]") {
    throw "Service name cannot contain brackets or parentheses. Use dashes instead."
}

if ($Name.Length -lt 3) {
    throw "Service name must be at least 3 characters long."
}

# Set default port based on template
if ($Port -eq 0) {
    $Port = if ($Template -eq "starter-python-api") { 8000 } else { 3000 }
}

# Paths
$root = "C:\dev"
$appsDir = Join-Path $root "apps"
$templatesDir = Join-Path $root "templates"
$scriptsDir = Join-Path $root "scripts"
$dest = Join-Path $appsDir $Name
$templateSrc = Join-Path $templatesDir $Template

# Validate template exists
if (!(Test-Path $templateSrc)) {
    throw "Template not found: $templateSrc"
}

# Check if already exists (idempotent)
if (Test-Path $dest) {
    Write-Host "Service already exists: $dest" -ForegroundColor Yellow
    Write-Host "Use 'git pull' to update or delete the directory to recreate." -ForegroundColor Yellow
    exit 0
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Creating New Service" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Template: $Template" -ForegroundColor White
Write-Host "Name:     $Name" -ForegroundColor White
Write-Host "Port:     $Port" -ForegroundColor White
Write-Host "Location: $dest" -ForegroundColor White
Write-Host ""

# Create apps directory if needed
if (!(Test-Path $appsDir)) {
    New-Item -ItemType Directory -Path $appsDir -Force | Out-Null
}

# Step 1: Create base directory
Write-Host "Step 1/6: Creating directory..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $dest -Force | Out-Null

# Step 2: Scaffold standard structure
Write-Host "Step 2/6: Scaffolding repo structure..." -ForegroundColor Cyan
& "$scriptsDir\scaffold-repo.ps1" -Path $dest

# Step 3: Copy template
Write-Host "Step 3/6: Copying template..." -ForegroundColor Cyan
Get-ChildItem -Path $templateSrc -Recurse | ForEach-Object {
    $targetPath = $_.FullName.Replace($templateSrc, $dest)
    
    if ($_.PSIsContainer) {
        if (!(Test-Path $targetPath)) {
            New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
        }
    } else {
        Copy-Item -Path $_.FullName -Destination $targetPath -Force
    }
}

# Step 4: Token replacement
Write-Host "Step 4/6: Customizing configuration..." -ForegroundColor Cyan

$replacements = @{
    "__SERVICE_NAME__" = $Name
    "__PORT__" = $Port.ToString()
    "starter-python-api" = $Name
    "starter-node-service" = $Name
}

Get-ChildItem -Path $dest -Recurse -File | Where-Object {
    $_.Extension -in @(".md", ".json", ".yml", ".yaml", ".py", ".ts", ".js", ".env", ".txt")
} | ForEach-Object {
    $content = Get-Content $_.FullName -Raw -Encoding UTF8
    $modified = $content
    
    foreach ($key in $replacements.Keys) {
        $modified = $modified -replace [regex]::Escape($key), $replacements[$key]
    }
    
    if ($content -ne $modified) {
        Set-Content -Path $_.FullName -Value $modified -Encoding UTF8 -NoNewline
    }
}

# Step 5: Create environment files
Write-Host "Step 5/6: Creating environment files..." -ForegroundColor Cyan

$envExample = if ($Template -eq "starter-python-api") {
@"
# Application
PORT=$Port
APP_NAME=$Name

# Database
DATABASE_URL=postgresql://postgres:postgres@db:5432/postgres

# Data Directories (optional)
# APP_DATA_DIR=./30_DATA
# APP_LOG_DIR=./40_RUNTIME/logs
"@
} else {
@"
# Application
PORT=$Port
APP_NAME=$Name

# Database
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/postgres

# Data Directories (optional)
# APP_DATA_DIR=./30_DATA
# APP_LOG_DIR=./40_RUNTIME/logs
"@
}

Set-Content -Path (Join-Path $dest "50_CONFIG\.env.example") -Value $envExample -Encoding UTF8

# Update main .env.example if it exists
if (Test-Path (Join-Path $dest ".env.example")) {
    Set-Content -Path (Join-Path $dest ".env.example") -Value $envExample -Encoding UTF8
}

# Step 6: Git initialization
Write-Host "Step 6/6: Initializing git repository..." -ForegroundColor Cyan
Push-Location $dest
git init | Out-Null
git add . | Out-Null
git commit -m "feat: initialize $Name from $Template template

- Port: $Port
- Template: $Template
- Structure: Standard numbered directories
- Features: Health endpoint, tests, Docker, DevContainer" | Out-Null
Pop-Location

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Service Created Successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Location: $dest" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  cd `"$dest`"" -ForegroundColor White
Write-Host "  cp 50_CONFIG\.env.example .env" -ForegroundColor White
Write-Host "  # Edit .env with your settings" -ForegroundColor Gray
Write-Host "  docker compose up --build" -ForegroundColor White
Write-Host ""
Write-Host "Then visit:" -ForegroundColor Yellow
Write-Host "  http://localhost:$Port/health" -ForegroundColor White
Write-Host ""
Write-Host "Directory structure:" -ForegroundColor Yellow
Write-Host "  10_DOCS/     - Documentation" -ForegroundColor Gray
Write-Host "  20_SRC/      - Source code" -ForegroundColor Gray
Write-Host "  30_DATA/     - Data files (git-ignored)" -ForegroundColor Gray
Write-Host "  40_RUNTIME/  - Runtime files, logs (git-ignored)" -ForegroundColor Gray
Write-Host "  50_CONFIG/   - Configuration files" -ForegroundColor Gray
Write-Host "  99_ARCHIVE/  - Archived/deprecated code" -ForegroundColor Gray
Write-Host ""
