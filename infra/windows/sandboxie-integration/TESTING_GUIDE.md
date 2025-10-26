# Testing Guide - Sandboxie Integration v1.0

Complete testing procedure to validate the package.

---

## Quick Test (5 minutes)

### 1. Run Automated Test Suite

```powershell
cd C:\dev\docs\gpt-summaries\devops\251026_sandboxie-env
.\TEST_SUITE.ps1
```

**Expected:** All 14 tests pass

---

## Manual Testing (15 minutes)

### Prerequisites Check

```powershell
# 1. Check Sandboxie-Plus installed
Test-Path "C:\Program Files\Sandboxie-Plus\Start.exe"
# Should return: True

# 2. Check configuration exists
Test-Path "C:\ProgramData\Sandboxie-Plus\Sandboxie.ini"
# Should return: True

# 3. Check package files
cd C:\dev\docs\gpt-summaries\devops\251026_sandboxie-env
(Get-ChildItem -Recurse -File).Count
# Should be: 24 or more
```

---

### Test 1: Installation Script

```powershell
# Run as Administrator
.\scripts\windows\install-sandboxie-config.ps1
```

**Expected Output:**
```
Imported boxes and restarted service.
```

**Verify:**
```powershell
# Check backup created
Get-ChildItem "C:\ProgramData\Sandboxie-Plus\Sandboxie.ini.bak.*"
# Should show timestamped backup

# Check boxes imported
Get-Content "C:\ProgramData\Sandboxie-Plus\Sandboxie.ini" | Select-String "ImportBox"
# Should show 5 ImportBox lines
```

**Result:** ✅ Pass / ❌ Fail

---

### Test 2: Launch Interactive Dialog

```powershell
.\scripts\windows\launch-dialog.ps1
```

**Steps:**
1. When prompted, enter: `unknown-exe`
2. When prompted for command, enter: `notepad.exe`
3. When prompted for args, press Enter (skip)

**Expected:** Notepad opens in Sandboxie (yellow border around window)

**Result:** ✅ Pass / ❌ Fail

---

### Test 3: Quick Browser Launch

```powershell
.\scripts\windows\Open-Browser-Isolated.cmd
```

**Expected:** Chrome opens in Sandboxie (yellow border, `#` in title bar)

**Result:** ✅ Pass / ❌ Fail

---

### Test 4: Clean All Boxes

```powershell
.\scripts\windows\clean-all-boxes.ps1
```

**Expected Output:**
```
Cleaned downloads-isolated
Cleaned unknown-exe
Cleaned browser-isolated
Cleaned repo-tooling
Cleaned git-tools
```

**Result:** ✅ Pass / ❌ Fail

---

### Test 5: Schedule Cleanup (Admin Required)

```powershell
# Run as Administrator
.\scripts\windows\schedule-cleanup.ps1
```

**Expected Output:**
```
SUCCESS: The scheduled task "Sandboxie_Cleanup_Daily" has successfully been created.
SUCCESS: The scheduled task "Sandboxie_Cleanup_Weekly" has successfully been created.
Scheduled tasks created. Disable one if you only want a single schedule.
```

**Verify:**
```powershell
schtasks /Query /TN "Sandboxie_Cleanup_Daily"
schtasks /Query /TN "Sandboxie_Cleanup_Weekly"
# Both should show task details
```

**Result:** ✅ Pass / ❌ Fail

---

### Test 6: Unschedule Cleanup

```powershell
# Run as Administrator
.\scripts\windows\unschedule-cleanup.ps1
```

**Expected Output:**
```
Removing scheduled cleanup tasks...
SUCCESS: The scheduled task "Sandboxie_Cleanup_Daily" was successfully deleted.
SUCCESS: The scheduled task "Sandboxie_Cleanup_Weekly" was successfully deleted.
Done.
```

**Result:** ✅ Pass / ❌ Fail

---

### Test 7: Run in Box (PowerShell)

```powershell
.\scripts\windows\run-in-box.ps1 -Box "repo-tooling" -Command "cmd.exe" -Args @("/c", "echo Test successful")
```

**Expected Output:**
```
Test successful
```

**Result:** ✅ Pass / ❌ Fail

---

### Test 8: Uninstall/Restore

```powershell
# Run as Administrator
.\scripts\windows\uninstall-sandboxie-config.ps1
```

**Expected Output:**
```
Restoring backup: C:\ProgramData\Sandboxie-Plus\Sandboxie.ini.bak.20251026-HHMMSS
Restarting Sandboxie service...
Done. Current Sandboxie.ini restored from C:\...
```

**Verify:**
```powershell
# Boxes should be removed
Get-Content "C:\ProgramData\Sandboxie-Plus\Sandboxie.ini" | Select-String "ImportBox"
# Should show no ImportBox lines (or original ones)
```

**Result:** ✅ Pass / ❌ Fail

---

### Test 9: Re-install After Uninstall

```powershell
# Run as Administrator
.\scripts\windows\install-sandboxie-config.ps1
```

**Expected:** Boxes re-imported successfully

**Result:** ✅ Pass / ❌ Fail

---

### Test 10: Documentation Accessibility

```powershell
# Open main guide
notepad README.md

# Open comprehensive docs
notepad docs\SANDBOXIE_INTEGRATION.md

# Open usage examples
notepad USAGE_EXAMPLES.md

# Open v1.0 notes
notepad V1.0_RELEASE_NOTES.md
```

**Expected:** All files open and are readable

**Result:** ✅ Pass / ❌ Fail

---

## Advanced Testing (Optional)

### Test 11: Network Isolation (Requires Manual Setup)

**Setup:**
1. Edit `C:\ProgramData\Sandboxie-Plus\Sandboxie.ini`
2. Add under `[GlobalSettings]`:
   ```ini
   ImportBox=C:\dev\docs\gpt-summaries\devops\251026_sandboxie-env\sandboxie\boxes\overlays\unknown-exe_network-strict.ini
   ```
3. Restart Sandboxie service:
   ```powershell
   sc.exe stop SbieSvc; sc.exe start SbieSvc
   ```

**Test:**
```powershell
.\scripts\windows\run-in-box.ps1 -Box "unknown-exe" -Command "ping.exe" -Args @("8.8.8.8")
```

**Expected:** Ping should fail (network blocked)

**Cleanup:**
Remove the ImportBox line and restart service.

**Result:** ✅ Pass / ❌ Fail

---

### Test 12: Force Folder (Auto-sandbox Downloads)

```powershell
# Run as Administrator
.\scripts\windows\force-folders.ps1 -Box "downloads-isolated" -Paths @("$env:USERPROFILE\Downloads")
```

**Expected Output:**
```
Added Forced Folders for [downloads-isolated].
```

**Test:**
1. Download a file
2. Try to open it
3. Should open in Sandboxie automatically

**Result:** ✅ Pass / ❌ Fail

---

## Test Results Summary

| Test | Status | Notes |
|------|--------|-------|
| 1. Installation | ⬜ | |
| 2. Interactive Dialog | ⬜ | |
| 3. Browser Launch | ⬜ | |
| 4. Clean All Boxes | ⬜ | |
| 5. Schedule Cleanup | ⬜ | |
| 6. Unschedule | ⬜ | |
| 7. Run in Box | ⬜ | |
| 8. Uninstall | ⬜ | |
| 9. Re-install | ⬜ | |
| 10. Documentation | ⬜ | |
| 11. Network Isolation | ⬜ | Optional |
| 12. Force Folder | ⬜ | Optional |

**Overall Status:** ⬜ Pass / ⬜ Fail

---

## Troubleshooting

### Sandboxie Not Installed
**Error:** `Start.exe not found`
**Fix:** Install from https://sandboxie-plus.com/downloads/

### Permission Denied
**Error:** `Access denied`
**Fix:** Run PowerShell as Administrator

### Boxes Not Showing Up
**Error:** Boxes not visible in Sandboxie-Plus UI
**Fix:**
1. Check ImportBox lines in Sandboxie.ini
2. Restart Sandboxie service
3. Re-run install script

### Script Execution Error
**Error:** `cannot be loaded because running scripts is disabled`
**Fix:**
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

---

## CI/CD Integration (Future)

### GitHub Actions Example

```yaml
name: Test Sandboxie Package
on: [push, pull_request]

jobs:
  test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Test Suite
        shell: pwsh
        run: |
          cd docs/gpt-summaries/devops/251026_sandboxie-env
          ./TEST_SUITE.ps1
```

---

## Reporting Issues

If tests fail, document:
1. Test number and name
2. Error message
3. PowerShell version: `$PSVersionTable.PSVersion`
4. Windows version: `[System.Environment]::OSVersion.Version`
5. Sandboxie-Plus version

**Report to:** See main README or create issue in repo

---

**Testing Guide Version:** 1.0
**Last Updated:** 2025-10-26
**Corresponds to:** Sandboxie Integration v1.0

