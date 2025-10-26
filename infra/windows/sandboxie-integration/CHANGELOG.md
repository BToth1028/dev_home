# Changelog

All notable changes to the Sandboxie Integration Package.

---

## [1.0.0] - 2025-10-26

### Added
- **Network Hardening:** `unknown-exe_network-strict.ini` overlay for deny-by-default internet access
- **Automated Cleanup:** `clean-all-boxes.ps1` to clean all boxes at once
- **Scheduled Cleanup:** `schedule-cleanup.ps1` and `unschedule-cleanup.ps1` for automated maintenance
- **Interactive Launcher:** `launch-dialog.ps1` for dialog-based box selection and command entry
- **Decision Log:** `docs/decisions/2025-10-26_sandboxie-followups.md` documenting v1.0 improvements
- **Changelog:** This file

### Changed
- **Improved Uninstall:** `uninstall-sandboxie-config.ps1` now cleaner with better error handling
- **Enhanced .gitignore:** Added Sandboxie-specific backup and log patterns

### Security
- Network isolation option for `unknown-exe` box (blocks internet by default)
- Automated cleanup reduces attack surface over time

---

## [0.9.0] - 2025-10-26 (Initial Release)

### Added
- **Box Configurations:** 5 pre-configured boxes
  - `downloads-isolated` - Auto-sandbox Downloads folder
  - `unknown-exe` - Untrusted executables
  - `browser-isolated` - Isolated browsing
  - `repo-tooling` - Repository/build tools
  - `git-tools` - Git operations (broader access)

- **Automation Scripts:**
  - `install-sandboxie-config.ps1` - Main installer (backs up, imports boxes)
  - `force-folders.ps1` - Auto-sandbox folders
  - `run-in-box.ps1` - PowerShell launcher
  - `make-shortcuts.ps1` - Create desktop shortcuts
  - `Open-Browser-Isolated.cmd` - Quick browser launch
  - `Run-In-Box.cmd` - Batch launcher
  - `Clean-Downloads-Box.cmd` - Cleanup utility

- **Documentation:**
  - `README.md` - Package overview
  - `docs/SANDBOXIE_INTEGRATION.md` - Comprehensive guide (400+ lines)
  - `USAGE_EXAMPLES.md` - 20+ practical examples
  - `_REVIEW_SUMMARY.md` - Complete review and analysis

- **Cursor Integration:**
  - `.cursor/rules/sandboxie-usage.mdc` - AI instructions for Sandboxie usage
  - Clear box selection guidance
  - Exclusion rules (don't sandbox Docker/DevContainers)

### Security
- ConfigLevel=7 (highest isolation) for all boxes except git-tools
- DropRights=y by default for privilege reduction
- git-tools has DropRights=n for necessary file access

---

## Upgrade Guide

### From 0.9.0 to 1.0.0

**New files to add:**
```
sandboxie/boxes/overlays/unknown-exe_network-strict.ini
scripts/windows/clean-all-boxes.ps1
scripts/windows/schedule-cleanup.ps1
scripts/windows/unschedule-cleanup.ps1
scripts/windows/launch-dialog.ps1
docs/decisions/2025-10-26_sandboxie-followups.md
CHANGELOG.md (this file)
```

**Updated files:**
```
scripts/windows/uninstall-sandboxie-config.ps1 (improved)
.gitignore (enhanced)
README.md (v1.0 notes)
```

**No breaking changes** - all v0.9.0 functionality preserved.

**Optional setup:**
1. Enable network hardening (see decision log)
2. Schedule automated cleanup
3. Try interactive launcher

---

## Version Scheme

- **Major.Minor.Patch** (Semantic Versioning)
- **Major (1.x):** Breaking changes, major architecture shifts
- **Minor (x.1):** New features, non-breaking additions
- **Patch (x.x.1):** Bug fixes, documentation updates

---

**Current:** v1.0.0
**Next planned:** v1.1.0 (GUI launcher, telemetry)

