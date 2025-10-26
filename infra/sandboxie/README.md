# Sandboxie Plus Configuration

Pre-configured Sandboxie Plus boxes for isolated Windows development.

## What This Provides

**5 pre-configured sandbox environments:**
1. `BrowserIsolated` – Web browser isolation for downloading files
2. `DownloadsIsolated` – Run downloaded executables safely
3. `GitTools` – Isolated git operations
4. `RepoTooling` – Safe environment for repo management tools
5. `UnknownExe` – General-purpose isolation for untrusted executables

## Quick Start

**Prerequisites:**
- Windows 10/11
- [Sandboxie Plus](https://sandboxie-plus.com/) installed

**Installation:**
```powershell
cd scripts\windows
.\install-sandboxie-config.ps1
```

**Uninstall:**
```powershell
cd scripts\windows
.\uninstall-sandboxie-config.ps1
```

## Documentation

- **Full integration guide:** `SANDBOXIE_INTEGRATION.md`
- **Usage examples:** `USAGE_EXAMPLES.md`

## Structure

```
sandboxie/
├── boxes/                          ← Box configuration files (.ini)
│   ├── browser-isolated.ini
│   ├── downloads-isolated.ini
│   ├── git-tools.ini
│   ├── repo-tooling.ini
│   └── unknown-exe.ini
├── scripts/
│   └── windows/                    ← Installation scripts
│       ├── install-sandboxie-config.ps1
│       ├── uninstall-sandboxie-config.ps1
│       ├── run-in-box.ps1
│       ├── force-folders.ps1
│       └── ...shortcuts and cleanup scripts
├── README.md                       ← This file
├── SANDBOXIE_INTEGRATION.md        ← Full documentation
└── USAGE_EXAMPLES.md               ← Usage examples
```

## Common Commands

**Run something in a box:**
```powershell
.\scripts\windows\Run-In-Box.cmd
# Follow the interactive prompts
```

**Open browser in isolated mode:**
```powershell
.\scripts\windows\Open-Browser-Isolated.cmd
```

**Clean the downloads box:**
```powershell
.\scripts\windows\Clean-Downloads-Box.cmd
```

## When to Use Each Box

| Box | Use For | Isolation Level |
|-----|---------|-----------------|
| `BrowserIsolated` | Downloading files from the web | High |
| `DownloadsIsolated` | Running installers/executables from downloads | High |
| `GitTools` | Git operations on untrusted repos | Medium |
| `RepoTooling` | Repo management tools (GitHub CLI, etc.) | Medium |
| `UnknownExe` | Any untrusted executable | High |

## Security Note

Sandboxie provides isolation but is **not a security boundary**. Don't run obviously malicious software even in a sandbox. Use for:
- Testing unfamiliar tools
- Running downloaded installers
- Isolating messy applications
- Experimenting with new software

---

**Last Updated:** 2025-10-26

