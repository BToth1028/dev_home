# Switch repo layout to un-numbered dirs

**Date**: 2025-10-26
**Source**: ChatGPT
**Context**: User removed numeric prefixes from per-repo structure.
**Original Prompt**: "I think we get rid of the numbering system completely."

---

## Key Takeaways

- Standard is now: `docs/src/tests/config/data/runtime`
- Updated rules, .cursorignore, scripts, all templates
- Migration script provided for bulk updates to existing repos
- File path references in code/config need updating

---

## Implementation Guide

### 1) Update rules & CI (one-time)

**`.cursor/rules/project-standards.mdc`** (root + templates):
```markdown
- Repo dirs: docs/src/tests/config/data/runtime
```

**`.cursorignore`** (root + templates):
```
data/
runtime/
.env
.env.*
node_modules/
__pycache__/
```

### 2) Fix scaffold + creator scripts

**`scaffold-repo.ps1`** (ensure dirs):
```powershell
$dirs = "docs","src","tests","config","data","runtime",".cursor\rules"
$dirs | % { New-Item -ItemType Directory $_ -EA 0 | Out-Null }
```

**`new-service.ps1`** (normalize template layout):
```powershell
$map = @{
  "configs"   = "config"
  "docs\adr"  = "docs\decisions"
}
foreach ($k in $map.Keys) {
  $from = Join-Path $dest $k
  if (Test-Path $from) {
    $to = Join-Path $dest $map[$k]
    New-Item -ItemType Directory $to -EA 0 | Out-Null
    robocopy $from $to *.* /S | Out-Null
    Remove-Item $from -Recurse -Force
  }
}
```

### 3) Migrate existing repos (bulk)

```powershell
$apps="C:\DEV\apps"
Get-ChildItem $apps -Directory | %{
  $r=$_.FullName
  ren "$r\10_DOCS" docs -EA 0
  ren "$r\20_SRC"  src  -EA 0
  ren "$r\30_DATA" data -EA 0
  ren "$r\40_RUNTIME" runtime -EA 0
  ren "$r\50_CONFIG" config -EA 0

  # Patch common file refs
  gci $r -Recurse -File -Include *.md,*.py,*.ts,*.tsx,*.js,*.json,*.yml,*.yaml |
    % {
      (Get-Content $_) -replace "10_DOCS","docs" `
                       -replace "20_SRC","src" `
                       -replace "30_DATA","data" `
                       -replace "40_RUNTIME","runtime" `
                       -replace "50_CONFIG","config" | Set-Content $_
    }
}
```

### 4) Touch Flask/Node entry points (paths/env)

**Python** imports from `src` unchanged if you run from repo root:
```powershell
# Run service
$env:PYTHONPATH="src"; python .\src\app.py

# Tests
pytest -q
```

**Node/TypeScript**:
```powershell
pnpm dev
pnpm test
```

### 5) Hot Context builder (paths)

In `tools/context-builder/settings.yaml`, update sources:
```yaml
sources:
  - path: "docs/standards"
  - path: "docs/architecture"
  - path: "docs/decisions"
  - path: "README.md"
```

Rebuild:
```powershell
py tools\context-builder\build_hot_context.py
```

### 6) Update Custom Instructions & Memory

Replace any `"10_DOCS,20_SRC,..."` with `"docs, src, tests, config, data, runtime"` in:
- Cursor settings
- GPT custom instructions
- Project documentation

---

## What Was Changed

**✅ COMPLETED:**
1. **Root workspace**: Updated `.cursor/rules/project-standards.mdc` and `.cursorignore`
2. **Both templates**: Updated project standards and ignore files
3. **Scripts**:
   - `scaffold-repo.ps1` now creates un-numbered dirs
   - `new-service.ps1` normalizes template layout automatically (`configs` → `config`, `docs/adr` → `docs/decisions`)
4. **Environment files**: Updated path references in generated `.env.example` files
5. **Output messages**: Updated help text in `new-service.ps1` to show new structure

**🔄 Template Normalization:**
- `configs/` → `config/`
- `docs/adr/` → `docs/decisions/`
- Automatically applied when creating new services

**📝 Migration Notes:**
- Existing repos in `apps/` need manual migration (use bulk script above)
- Python apps: Set `PYTHONPATH=src` when running
- All file references in code/docs need updating

---

## Verification Checklist

After migration, verify each service:

**Python (Flask)**:
```powershell
cd C:\dev\apps\my-service
py -m venv .venv; .\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item config\.env.example .env -Force
$env:PYTHONPATH="src"; python .\src\app.py
# In new terminal:
Invoke-WebRequest http://localhost:8000/health | % Content
pytest -q
```

**Node/TypeScript**:
```powershell
cd C:\dev\apps\my-service
corepack enable; pnpm i
Copy-Item config\.env.example .env -Force
pnpm dev
# In new terminal:
Invoke-WebRequest http://localhost:3000/health | % Content
pnpm test
```

---

## Related

- Workspace scaffolding standards
- Template smoke CI
- [2025-10-26_cursor-rules-and-ignore.md](./2025-10-26_cursor-rules-and-ignore.md) - Cursor setup
- Project naming conventions
