# Sandboxie Integration v1.0 - Test Suite
# Run this script to validate the complete package

$ErrorActionPreference = "Continue"
$testResults = @()

function Run-Test {
    param([string]$Name, [scriptblock]$TestBlock)
    Write-Host "`nTesting: $Name" -ForegroundColor Cyan
    try {
        $result = & $TestBlock
        if ($result) {
            Write-Host "  PASS" -ForegroundColor Green
            $script:testResults += [PSCustomObject]@{Test=$Name; Result="PASS"}
        } else {
            Write-Host "  FAIL" -ForegroundColor Red
            $script:testResults += [PSCustomObject]@{Test=$Name; Result="FAIL"}
        }
    } catch {
        Write-Host "  FAIL: $_" -ForegroundColor Red
        $script:testResults += [PSCustomObject]@{Test=$Name; Result="FAIL"}
    }
}

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Sandboxie Integration v1.0 - Test Suite" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow

# Test 1: Sandboxie-Plus Installation
Run-Test "Sandboxie-Plus Installed" { Test-Path "C:\Program Files\Sandboxie-Plus\Start.exe" }

# Test 2: Sandboxie Configuration Exists
Run-Test "Sandboxie Config Exists" { Test-Path "C:\ProgramData\Sandboxie-Plus\Sandboxie.ini" }

# Test 3: All Box Configs Exist
Run-Test "Box Configs Present" {
    $boxes = @("browser-isolated.ini", "downloads-isolated.ini", "git-tools.ini", "repo-tooling.ini", "unknown-exe.ini")
    $allExist = $true
    foreach ($box in $boxes) {
        if (!(Test-Path "sandboxie\boxes\$box")) { $allExist = $false }
    }
    $allExist
}

# Test 4: Network Overlay Exists
Run-Test "Network Overlay Present" { Test-Path "sandboxie\boxes\overlays\unknown-exe_network-strict.ini" }

# Test 5: All PowerShell Scripts Exist
Run-Test "PowerShell Scripts Present" {
    $scripts = @("install-sandboxie-config.ps1", "uninstall-sandboxie-config.ps1", "force-folders.ps1",
                 "run-in-box.ps1", "clean-all-boxes.ps1", "schedule-cleanup.ps1",
                 "unschedule-cleanup.ps1", "launch-dialog.ps1", "make-shortcuts.ps1")
    $allExist = $true
    foreach ($script in $scripts) {
        if (!(Test-Path "scripts\windows\$script")) { $allExist = $false }
    }
    $allExist
}

# Test 6: All Batch Scripts Exist
Run-Test "Batch Scripts Present" {
    $scripts = @("Open-Browser-Isolated.cmd", "Run-In-Box.cmd", "Clean-Downloads-Box.cmd")
    $allExist = $true
    foreach ($script in $scripts) {
        if (!(Test-Path "scripts\windows\$script")) { $allExist = $false }
    }
    $allExist
}

# Test 7: Documentation Files Exist
Run-Test "Documentation Complete" {
    $docs = @("README.md", "CHANGELOG.md", "USAGE_EXAMPLES.md", "V1.0_RELEASE_NOTES.md",
              "_REVIEW_SUMMARY.md", "_V1.0_IMPLEMENTATION_COMPLETE.md",
              "docs\SANDBOXIE_INTEGRATION.md", "docs\decisions\2025-10-26_sandboxie-followups.md")
    $allExist = $true
    foreach ($doc in $docs) {
        if (!(Test-Path $doc)) { $allExist = $false }
    }
    $allExist
}

# Test 8: Cursor Integration Exists
Run-Test "Cursor Rules Present" { Test-Path ".cursor\rules\sandboxie-usage.mdc" }

# Test 9: .gitignore Exists
Run-Test ".gitignore Present" { Test-Path ".gitignore" }

# Test 10: Count Total Files
Run-Test "File Count Verification" {
    $fileCount = (Get-ChildItem -Recurse -File).Count
    Write-Host "    Total files: $fileCount" -ForegroundColor Cyan
    $fileCount -ge 24
}

# Test 11: README References v1.0
Run-Test "README Updated for v1.0" {
    $readme = Get-Content "README.md" -Raw
    $readme -match "v1\.0" -or $readme -match "Version.*1\.0"
}

# Test 12: Changelog Exists and Contains v1.0
Run-Test "Changelog Contains v1.0" {
    if (Test-Path "CHANGELOG.md") {
        $changelog = Get-Content "CHANGELOG.md" -Raw
        $changelog -match "\[1\.0\.0\]"
    } else {
        $false
    }
}

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "Test Summary" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow

$passed = ($testResults | Where-Object {$_.Result -eq "PASS"}).Count
$failed = ($testResults | Where-Object {$_.Result -eq "FAIL"}).Count
$total = $testResults.Count

Write-Host "`nResults:" -ForegroundColor Cyan
Write-Host "  PASSED: $passed / $total" -ForegroundColor Green
Write-Host "  FAILED: $failed / $total" -ForegroundColor $(if ($failed -eq 0) {"Green"} else {"Red"})

if ($failed -gt 0) {
    Write-Host "`nFailed Tests:" -ForegroundColor Red
    $testResults | Where-Object {$_.Result -eq "FAIL"} | ForEach-Object {
        Write-Host "  - $($_.Test)" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Yellow

if ($failed -eq 0) {
    Write-Host "ALL TESTS PASSED - Package is ready!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "SOME TESTS FAILED - Review errors above" -ForegroundColor Red
    exit 1
}
