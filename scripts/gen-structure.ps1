$date = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

Write-Host "Regenerating STRUCTURE.md..." -ForegroundColor Cyan

$header = @"
# C:\DEV Complete Structure

**Generated:** $date
**Purpose:** Definitive map of the entire engineering workspace

---

## 📊 Overview

This is the **source of truth** for C:\DEV structure. Auto-generated and kept current via `scripts\gen-structure.ps1`.

"@

$tree = tree /F /A C:\DEV 2>$null

$content = $header + "`n`n## 🌳 Complete File Tree`n`n``````n" + ($tree -join "`n") + "`n```````n"

Set-Content -Path "STRUCTURE.md" -Value $content -Encoding UTF8

Write-Host "Updated: STRUCTURE.md" -ForegroundColor Green
Write-Host ""
Write-Host "File contains:" -ForegroundColor Cyan
Write-Host "  - Complete directory tree"
Write-Host "  - Timestamp: $date"
Write-Host ""
Write-Host "Commit with:" -ForegroundColor Yellow
Write-Host "  git add STRUCTURE.md"
Write-Host "  git commit -m 'docs: update workspace structure'"
