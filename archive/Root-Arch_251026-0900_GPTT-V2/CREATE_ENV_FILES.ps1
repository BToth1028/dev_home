# PowerShell script to create .env.example files
# Run this from the Root-Arch_[251026-0900_GPTT]_V2 directory

Write-Host "Creating .env.example files..." -ForegroundColor Green

# Node template
$nodeEnv = @"
# App Configuration
APP_PORT=3000

# Database
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/postgres

# Data Directories (optional - will use OS defaults if not set)
# APP_DATA_DIR=
# APP_LOG_DIR=
# APP_CACHE_DIR=
"@

# Python template
$pythonEnv = @"
# App Configuration
APP_PORT=8000

# Database
DATABASE_URL=postgresql://postgres:postgres@db:5432/postgres

# Data Directories (optional - will use OS defaults if not set)
# APP_DATA_DIR=
# APP_LOG_DIR=
# APP_CACHE_DIR=
"@

# Write files
$nodeEnv | Out-File -FilePath "templates\starter-node-service\.env.example" -Encoding UTF8 -NoNewline
$pythonEnv | Out-File -FilePath "templates\starter-python-api\.env.example" -Encoding UTF8 -NoNewline

Write-Host "✓ Created templates\starter-node-service\.env.example" -ForegroundColor Cyan
Write-Host "✓ Created templates\starter-python-api\.env.example" -ForegroundColor Cyan
Write-Host "`nDone! You can now use the templates." -ForegroundColor Green
