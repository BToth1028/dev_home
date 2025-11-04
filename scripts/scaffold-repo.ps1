# scaffold-repo.ps1
# Sets up standard directory structure inside a new app/lib repo

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

$ErrorActionPreference = "Stop"

Write-Host "Scaffolding repo structure at: $Path" -ForegroundColor Cyan

# Standard directories
$dirs = @(
    "docs",
    "src",
    "tests",
    "config",
    "data",
    "runtime",
    "docs/decisions",
    ".cursor/rules"
)

foreach ($dir in $dirs) {
    $fullPath = Join-Path $Path $dir
    if (!(Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "  ✓ Created $dir" -ForegroundColor Green
    }
}

# .editorconfig (consistent formatting)
$editorConfig = @"
# EditorConfig
root = true

[*]
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
charset = utf-8

[*.{js,ts,jsx,tsx,json,yml,yaml}]
indent_style = space
indent_size = 2

[*.{py,rs,go}]
indent_style = space
indent_size = 4

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
"@

Set-Content -Path (Join-Path $Path ".editorconfig") -Value $editorConfig -Encoding UTF8

# Enhanced .gitignore
$gitignore = @"
# Secrets & Environment
.env
.env.*
!.env.example

# Dependencies
node_modules/
.venv/
venv/
env/

# Build outputs
dist/
build/
*.egg-info/
__pycache__/
*.pyc
*.pyo

# Runtime
runtime/*
!runtime/.gitkeep
data/*
!data/.gitkeep

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Testing
.coverage
htmlcov/
.pytest_cache/
"@

Set-Content -Path (Join-Path $Path ".gitignore") -Value $gitignore -Encoding UTF8

# Initial decision log
$initDecision = @"
# Initial Repo Setup

**Date:** $(Get-Date -Format yyyy-MM-dd)
**Source:** Internal template
**Context:** New service created via new-service.ps1

---

## Original Prompt

Created via: ``new-service.ps1 -Template <template> -Name <name>``

---

## Key Takeaways

- Standardized directory structure: docs/src/tests/config/data/runtime
- Health endpoint included
- Tests included
- DevContainer support
- Docker Compose configuration
- CI/CD pipeline

---

## Implementation Guide

See README.md for usage instructions.

---

## Related

- C:\dev\docs\standards\
- Template source: C:\dev\templates\
"@

Set-Content -Path (Join-Path $Path "docs/decisions/$(Get-Date -Format yyyy-MM-dd)_init.md") -Value $initDecision -Encoding UTF8

# Create .gitkeep files for empty directories
@("data", "runtime") | ForEach-Object {
    $keepPath = Join-Path $Path "$_\.gitkeep"
    New-Item -ItemType File -Path $keepPath -Force | Out-Null
}

Write-Host "✓ Scaffolding complete!" -ForegroundColor Green
