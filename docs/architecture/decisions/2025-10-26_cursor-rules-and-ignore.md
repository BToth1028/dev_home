# Add Cursor rules, .cursorignore, and verification workflow

**Date**: 2025-10-26
**Source**: ChatGPT
**Context**: User asked how to implement the rules/ignore and run checks.
**Original Prompt**: "how do i do this"

## Key Takeaways

One-off commands for existing repos; snippet to bake into new-service.ps1; health + test commands for Python/Node.

## Implementation Guide

### A) Add to an existing repo

Replace `my-service` with your repo name.

```powershell
# 1) Create the rules folder
cd C:\dev\apps\my-service
New-Item -ItemType Directory .cursor\rules -Force | Out-Null

# 2) Write the project standards file
@"
# Project Standards
- Windows 11 Pro, PowerShell-first
- Names: ^[a-z0-9-]+$ ; no [] ()
- Repo dirs: docs/src/tests/config/data/runtime
- Deliverables: filenames, tree, PS cmds, tests, /health, logging, metrics
- Use pathlib (Python), minimal deps, show diffs for edits
"@ | Set-Content .cursor\rules\project-standards.mdc

# 3) Add .cursorignore at repo root
@"
data/
runtime/
.env
.env.*
node_modules/
__pycache__/
"@ | Set-Content .cursorignore
```

### B) Make every new project get these automatically

✅ **IMPLEMENTED** - Added to `C:\dev\scripts\new-service.ps1` after template copy step.

The script now ensures Cursor standards exist in every new repo automatically.

### C) Run the fast verification checklist

#### Python (Flask template)

```powershell
cd C:\dev\apps\my-service
# set up
py -m venv .venv; .\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item config\.env.example .env -Force
# run service
$env:PYTHONPATH="src"; python .\src\app.py
# in a new terminal:
Invoke-WebRequest http://localhost:8000/health | % Content
# tests
pytest -q
```

#### Node/TypeScript template

```powershell
cd C:\dev\apps\my-service
corepack enable; pnpm i
Copy-Item config\.env.example .env -Force
# run service (adjust script name if needed)
pnpm dev
# in a new terminal:
Invoke-WebRequest http://localhost:3000/health | % Content
# tests
pnpm test
```

You should see the health endpoint return `{"status":"ok"}` and tests pass. If either fails, debug the template.

## What Was Changed

1. **Templates Updated**: Added `.cursor/rules/project-standards.mdc` and `.cursorignore` to both:
   - `templates/starter-python-api/`
   - `templates/starter-node-service/`

2. **Scaffolding Script Updated**: Modified `scripts/new-service.ps1` to ensure Cursor standards exist in every new service (even if templates change).

3. **Files Are Versioned**: The `.cursor/` and `.cursorignore` files are now tracked in git within the templates, ensuring consistency across all new projects.

## Related

- Workspace scaffolding standards
- Template smoke CI
- Project naming conventions
