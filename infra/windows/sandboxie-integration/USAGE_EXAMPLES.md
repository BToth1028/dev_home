# Sandboxie Usage Examples

Quick reference for common tasks.

---

## Running Untrusted Executables

### Downloaded Installer
```powershell
# PowerShell
.\scripts\windows\run-in-box.ps1 -Box "unknown-exe" -Command "C:\Users\YourName\Downloads\setup.exe"

# Batch
.\scripts\windows\Run-In-Box.cmd unknown-exe "C:\Users\YourName\Downloads\setup.exe"
```

### Sketchy Tool
```cmd
.\scripts\windows\Run-In-Box.cmd unknown-exe "suspicious-tool.exe" --flag value
```

---

## Isolated Browsing

### Open Browser
```cmd
# Quick launch
.\scripts\windows\Open-Browser-Isolated.cmd

# Or manually
"C:\Program Files\Sandboxie-Plus\Start.exe" /box:browser-isolated chrome.exe
```

### Firefox Instead of Chrome
```powershell
.\scripts\windows\run-in-box.ps1 -Box "browser-isolated" -Command "C:\Program Files\Mozilla Firefox\firefox.exe"
```

### With Specific URL
```cmd
"C:\Program Files\Sandboxie-Plus\Start.exe" /box:browser-isolated chrome.exe https://suspicious-site.com
```

---

## Testing Development Tools

### Test Package Manager
```powershell
# Test npm install in isolated environment
.\scripts\windows\run-in-box.ps1 -Box "repo-tooling" -Command "npm" -Args @("install", "some-package")
```

### Test Build Script
```powershell
.\scripts\windows\run-in-box.ps1 -Box "repo-tooling" -Command "C:\path\to\build.bat"
```

### Test Python Script
```powershell
.\scripts\windows\run-in-box.ps1 -Box "repo-tooling" -Command "python" -Args @("script.py", "--arg", "value")
```

---

## Git Operations

### Test Git Hook
```powershell
# Git tools box has broader file access
.\scripts\windows\run-in-box.ps1 -Box "git-tools" -Command "git" -Args @("commit", "-m", "test")
```

### Test Git GUI
```powershell
.\scripts\windows\run-in-box.ps1 -Box "git-tools" -Command "C:\Program Files\Git\cmd\git-gui.exe"
```

---

## Cleanup Operations

### Clean Downloads Box
```cmd
# Quick cleanup
.\scripts\windows\Clean-Downloads-Box.cmd

# Or manually
"C:\Program Files\Sandboxie-Plus\Start.exe" /box:downloads-isolated delete_sandbox_silent
```

### Clean Specific Box
```cmd
"C:\Program Files\Sandboxie-Plus\Start.exe" /box:unknown-exe delete_sandbox_silent
```

### Clean All Boxes
```powershell
$boxes = @("downloads-isolated", "unknown-exe", "browser-isolated", "repo-tooling", "git-tools")
foreach ($box in $boxes) {
    & "C:\Program Files\Sandboxie-Plus\Start.exe" /box:$box delete_sandbox_silent
    Write-Host "Cleaned $box"
}
```

---

## Advanced Usage

### Run with Environment Variables
```powershell
$env:TEST_MODE = "true"
.\scripts\windows\run-in-box.ps1 -Box "repo-tooling" -Command "node" -Args @("app.js")
```

### Capture Output
```powershell
$output = & "C:\Program Files\Sandboxie-Plus\Start.exe" /box:repo-tooling /wait cmd.exe /c "echo test"
```

### Run Multiple Commands
```powershell
$commands = @(
    "npm install",
    "npm test",
    "npm run build"
)
foreach ($cmd in $commands) {
    .\scripts\windows\run-in-box.ps1 -Box "repo-tooling" -Command "cmd.exe" -Args @("/c", $cmd)
}
```

---

## Integration with Cursor

When working in Cursor, you can ask:

**"Run this exe in sandbox"**
```powershell
# Cursor will suggest:
.\scripts\windows\run-in-box.ps1 -Box "unknown-exe" -Command "file.exe"
```

**"Test this script in isolation"**
```powershell
# Cursor will suggest:
.\scripts\windows\run-in-box.ps1 -Box "repo-tooling" -Command "python" -Args @("script.py")
```

**"Open isolated browser"**
```cmd
# Cursor will suggest:
.\scripts\windows\Open-Browser-Isolated.cmd
```

---

## Common Patterns

### Before Testing Unknown Tool
1. Download tool
2. Run in `unknown-exe` box
3. Test functionality
4. If safe, clean box and run normally

### Before Visiting Sketchy Site
1. Open isolated browser
2. Visit site
3. Do what you need
4. Clean box (all traces removed)

### Before Running Build Script
1. Review script contents
2. Test in `repo-tooling` box
3. Verify output
4. If good, run normally

---

## Shortcuts

Create desktop shortcuts with:
```powershell
.\scripts\windows\make-shortcuts.ps1
```

Then use:
- **Open-Browser-Isolated** - Double-click to launch
- **Run-Unknown-EXE** - Opens run dialog in unknown-exe box
- **Clean-Downloads-Box** - Quick cleanup

---

## Troubleshooting

### App Won't Start
```powershell
# Try with /wait flag
"C:\Program Files\Sandboxie-Plus\Start.exe" /box:unknown-exe /wait "app.exe"
```

### Need More Access
Edit box config and change `ConfigLevel=7` to `ConfigLevel=5` or `ConfigLevel=3`.

### Permission Denied
Make sure box has `DropRights=n` if it needs file system access (like git-tools).

---

**See also:** [docs/SANDBOXIE_INTEGRATION.md](docs/SANDBOXIE_INTEGRATION.md) for full documentation

