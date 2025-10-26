# Sandboxie-Plus Integration Package

**Version:** v1.0  
**Created:** 2025-10-26  
**Platform:** Windows  
**Purpose:** Secure sandbox environment for development

---

## What This Is

Complete Sandboxie-Plus integration with:
- 5 pre-configured sandbox boxes
- Optional network hardening (deny-by-default internet)
- Automated cleanup (scheduled tasks)
- 12 automation scripts (PowerShell + Batch)
- Interactive launcher dialog
- Cursor AI integration
- Complete documentation

---

## Quick Start

**1. Install Sandboxie-Plus:**
https://sandboxie-plus.com/downloads/

**2. Import configurations:**
```powershell
# Run as Administrator
.\scripts\windows\install-sandboxie-config.ps1
```

**3. Use it:**
```cmd
# Open isolated browser
.\scripts\windows\Open-Browser-Isolated.cmd

# Run untrusted exe
.\scripts\windows\Run-In-Box.cmd unknown-exe "path\to\file.exe"
```

---

## Boxes Included

1. **downloads-isolated** - Auto-sandbox Downloads folder
2. **unknown-exe** - Run untrusted executables
3. **browser-isolated** - Isolated web browsing
4. **repo-tooling** - Repository/build tools
5. **git-tools** - Git operations (broader access)

---

## What's New in v1.0

**Security Hardening:**
- Network-strict overlay for `unknown-exe` (deny-by-default internet)

**Automation:**
- Scheduled cleanup (daily or weekly)
- Clean all boxes at once
- Interactive launcher dialog

**Improvements:**
- Better uninstall/restore script
- Enhanced .gitignore

---

## Documentation

**Full guide:**  
[docs/SANDBOXIE_INTEGRATION.md](docs/SANDBOXIE_INTEGRATION.md)

**Quick examples:**  
[USAGE_EXAMPLES.md](USAGE_EXAMPLES.md)

**v1.0 improvements:**  
[docs/decisions/2025-10-26_sandboxie-followups.md](docs/decisions/2025-10-26_sandboxie-followups.md)

**Sections:**
- Installation
- Usage examples
- Security notes (including network hardening)
- Troubleshooting
- Script reference
- Scheduled cleanup

---

## Files

```
├── .cursor/rules/              # Cursor AI instructions
├── docs/                       # Documentation + decision logs
├── sandboxie/boxes/            # Box configurations + overlays
└── scripts/windows/            # Automation scripts (12 total)
```

---

## Cursor Integration

Ask Cursor:
- "Run this exe in sandbox"
- "Open browser isolated"
- "Test script in repo-tooling box"

Cursor knows which boxes to use and won't sandbox Docker/DevContainers.

---

## Requirements

- Windows 10/11
- Sandboxie-Plus installed
- Admin rights (for setup only)

---

## Optional Features

### Network Hardening
Block internet by default in `unknown-exe`:
```powershell
# See docs/decisions/2025-10-26_sandboxie-followups.md
```

### Scheduled Cleanup
Automate box cleanup:
```powershell
.\scripts\windows\schedule-cleanup.ps1  # Run as Admin
```

### Interactive Launcher
Friendly dialog-based launcher:
```powershell
.\scripts\windows\launch-dialog.ps1
```

---

**Version:** v1.0  
**Status:** ✅ Production hardened  
**Tested:** 2025-10-26
