# Sandboxie-Plus Integration (Gold Standard)

**Date:** 2025-10-26
**Purpose:** Secure sandbox environment for untrusted code, downloads, and browsing
**Platform:** Windows
**Source:** ChatGPT

---

## TL;DR

1. Install Sandboxie-Plus
2. Run `scripts\windows\install-sandboxie-config.ps1` (as admin)
3. (Optional) `scripts\windows\force-folders.ps1` to auto-sandbox Downloads
4. Launch via `Open-Browser-Isolated.cmd` or `run-in-box.ps1`

---

## What is Sandboxie?

Sandboxie-Plus is a Windows sandbox utility that isolates programs from the rest of your system.

**Benefits:**
- Run untrusted executables safely
- Isolate browser sessions
- Auto-sandbox Downloads folder
- Test software without system changes
- Protect against malware

**How it works:** Creates isolated "boxes" where programs run. Changes made inside are contained and can be deleted.

---

## Box Configurations

### 1. `downloads-isolated`
**Purpose:** Auto-sandbox everything in Downloads folder

**Config:**
```ini
ForceFolder=C:\Users\%USER%\Downloads
ConfigLevel=7
DropRights=y
```

**Use case:** Any file you download runs isolated automatically

---

### 2. `unknown-exe`
**Purpose:** Run untrusted executables

**Config:**
```ini
ConfigLevel=7
DropRights=y
```

**Use case:** Downloaded tool from internet, sketchy installer, etc.

**How to use:**
```cmd
.\scripts\windows\Run-In-Box.cmd unknown-exe "path\to\suspicious.exe"
```

---

### 3. `browser-isolated`
**Purpose:** Isolated web browsing

**Config:**
```ini
ConfigLevel=7
DropRights=y
```

**Use case:** Visiting untrusted sites, logging into sketchy accounts

**How to use:**
```cmd
.\scripts\windows\Open-Browser-Isolated.cmd
```

---

### 4. `repo-tooling`
**Purpose:** Repository/project tooling that needs filesystem access

**Config:**
```ini
ConfigLevel=7
DropRights=y
```

**Use case:** Testing build tools, package managers, CI scripts

---

### 5. `git-tools`
**Purpose:** Git operations (needs broader file access)

**Config:**
```ini
ConfigLevel=7
DropRights=n  # Needs file system access
```

**Use case:** Testing git hooks, git extensions, git GUI tools

**Why DropRights=n?** Git needs to read/write files outside sandbox

---

## Installation

### Prerequisites
- Windows 10/11
- Admin rights
- [Sandboxie-Plus](https://sandboxie-plus.com/) installed

### Steps

**1. Install Sandboxie-Plus:**
Download from https://sandboxie-plus.com/downloads/

**2. Import Configurations:**
```powershell
# Run as Administrator
cd C:\dev\docs\gpt-summaries\devops\251026_sandboxie-env
.\scripts\windows\install-sandboxie-config.ps1
```

**What it does:**
- Backs up current `Sandboxie.ini` (timestamped)
- Imports all box configs from `sandboxie/boxes/*.ini`
- Restarts Sandboxie service

**3. (Optional) Auto-Sandbox Downloads:**
```powershell
# Run as Administrator
.\scripts\windows\force-folders.ps1 -Box "downloads-isolated" -Paths @("$env:USERPROFILE\Downloads")
```

**4. (Optional) Create Desktop Shortcuts:**
```powershell
.\scripts\windows\make-shortcuts.ps1
```

Creates:
- `Open-Browser-Isolated.lnk`
- `Run-Unknown-EXE.lnk`
- `Clean-Downloads-Box.lnk`

---

## Usage Examples

### Launch Program in Box

**PowerShell:**
```powershell
.\scripts\windows\run-in-box.ps1 -Box "unknown-exe" -Command "C:\path\to\app.exe" -Args @("--arg1", "value")
```

**Batch:**
```cmd
.\scripts\windows\Run-In-Box.cmd unknown-exe "C:\path\to\app.exe"
```

### Open Isolated Browser
```cmd
.\scripts\windows\Open-Browser-Isolated.cmd
```

### Clean Downloads Box
```cmd
.\scripts\windows\Clean-Downloads-Box.cmd
```

### Manual Launch
```cmd
"C:\Program Files\Sandboxie-Plus\Start.exe" /box:browser-isolated chrome.exe
```

---

## Cursor Integration

The `.cursor/rules/sandboxie-usage.mdc` file teaches Cursor AI about your sandboxes:

**Rules:**
- Use named boxes (5 available)
- Launch via `Start.exe /box:<name> <program>`
- **Do NOT sandbox Docker/DevContainers** (breaks networking)

**Ask Cursor:**
- "Run this exe in sandbox"
- "Open browser isolated"
- "Test this script in repo-tooling box"

---

## Security Notes

### What Sandboxie DOES Protect:
- ✅ Filesystem (changes contained)
- ✅ Registry (changes contained)
- ✅ Process isolation
- ✅ COM/RPC isolation

### What Sandboxie DOESN'T Protect:
- ❌ Network attacks (sandboxed apps can still access network)
- ❌ Zero-day exploits targeting Sandboxie itself
- ❌ Hardware attacks
- ❌ Social engineering

### Best Practices:
- Use highest ConfigLevel (7) for untrusted code
- Enable DropRights unless app needs filesystem access
- Clean boxes regularly (delete sandbox)
- Don't run privileged operations in sandbox
- Don't save credentials in sandboxed browsers

---

## Troubleshooting

### Box Not Appearing
```powershell
# Verify box imported
Get-Content "C:\ProgramData\Sandboxie-Plus\Sandboxie.ini" | Select-String "downloads-isolated"

# Re-import
.\scripts\windows\install-sandboxie-config.ps1
```

### ForceFolder Not Working
```powershell
# Verify setting
Get-Content "C:\ProgramData\Sandboxie-Plus\Sandboxie.ini" | Select-String "ForceFolder"

# Re-apply
.\scripts\windows\force-folders.ps1
```

### App Crashes in Sandbox
- Lower ConfigLevel (try 5 or 3)
- Disable DropRights
- Check Sandboxie logs (Right-click system tray icon → View Messages)

### Service Won't Restart
```powershell
# Manual restart
net stop SbieSvc
net start SbieSvc
```

---

## When NOT to Use Sandboxes

**Don't sandbox:**
- ❌ Docker/DevContainers (breaks networking)
- ❌ Development IDEs (Cursor, VS Code)
- ❌ Git operations on main repos (use git-tools box if testing)
- ❌ Build processes for production code
- ❌ Database servers

**Why?** Sandboxing these breaks functionality or creates inconsistent state.

---

## Maintenance

### Clean All Boxes
```powershell
# Clean specific box
"C:\Program Files\Sandboxie-Plus\Start.exe" /box:downloads-isolated delete_sandbox_silent

# Clean all boxes
Get-ChildItem "C:\Sandbox\*\*" | Remove-Item -Recurse -Force
```

### Update Box Configs
1. Edit `.ini` file in `sandboxie/boxes/`
2. Re-run `install-sandboxie-config.ps1`
3. Service restarts automatically

### Backup Current Config
```powershell
copy "C:\ProgramData\Sandboxie-Plus\Sandboxie.ini" "C:\dev\docs\backups\Sandboxie.ini.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
```

---

## Advanced Usage

### Create Custom Box
1. Create `sandboxie/boxes/my-box.ini`:
   ```ini
   [my-box]
   Enabled=y
   ConfigLevel=7
   DropRights=y
   ```
2. Run `install-sandboxie-config.ps1`

### Multiple Forced Folders
```powershell
.\scripts\windows\force-folders.ps1 -Box "downloads-isolated" -Paths @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop\Temp"
)
```

### Launch with Environment Variables
```powershell
$env:TEST_VAR = "value"
.\scripts\windows\run-in-box.ps1 -Box "repo-tooling" -Command "node" -Args @("script.js")
```

---

## Script Reference

| Script | Purpose | Admin Required |
|--------|---------|----------------|
| `install-sandboxie-config.ps1` | Import all box configs | ✅ Yes |
| `force-folders.ps1` | Auto-sandbox folders | ✅ Yes |
| `run-in-box.ps1` | Launch program in box | ❌ No |
| `make-shortcuts.ps1` | Create desktop shortcuts | ❌ No |
| `Open-Browser-Isolated.cmd` | Quick browser launch | ❌ No |
| `Run-In-Box.cmd` | Generic launcher (batch) | ❌ No |
| `Clean-Downloads-Box.cmd` | Clean downloads box | ❌ No |

---

## Files Structure

```
251026_sandboxie-env/
├── .cursor/rules/
│   └── sandboxie-usage.mdc          # Cursor AI instructions
├── docs/
│   └── SANDBOXIE_INTEGRATION.md     # This file
├── sandboxie/boxes/
│   ├── browser-isolated.ini         # Browser box config
│   ├── downloads-isolated.ini       # Downloads box config
│   ├── git-tools.ini                # Git tools box config
│   ├── repo-tooling.ini             # Repo tooling box config
│   └── unknown-exe.ini              # Unknown exe box config
└── scripts/windows/
    ├── install-sandboxie-config.ps1 # Main installer
    ├── force-folders.ps1            # Auto-sandbox folders
    ├── run-in-box.ps1               # PowerShell launcher
    ├── make-shortcuts.ps1           # Create shortcuts
    ├── Open-Browser-Isolated.cmd    # Quick browser
    ├── Run-In-Box.cmd               # Batch launcher
    └── Clean-Downloads-Box.cmd      # Cleanup utility
```

---

## Related Documentation

- [Sandboxie-Plus Official Docs](https://sandboxie-plus.com/sandboxie/)
- [Security Best Practices](../../standards/security-guidelines.md)
- [Windows Development Setup](../../standards/windows-dev-setup.md)

---

## Changelog

**2025-10-26 - v1.0**
- Initial implementation
- 5 box configurations
- 7 automation scripts
- Cursor integration
- Complete documentation

---

**Maintained By:** You
**Last Updated:** 2025-10-26
**Status:** ✅ Production Ready
