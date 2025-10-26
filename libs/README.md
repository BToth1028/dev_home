# Libs

**Purpose:** Shared libraries and packages used across multiple projects

---

## Structure

```
libs/
├── shared-auth/          # Authentication utilities
├── common-utils/         # Helper functions
├── ui-components/        # Reusable UI components
└── api-client/           # Shared API client
```

---

## When to Create a Library

Create a shared library when:
- ✅ Code is reused in 2+ projects
- ✅ Functionality is well-defined and stable
- ✅ You want independent versioning
- ✅ Multiple teams need the same code

**Don't create a library when:**
- ❌ Code is only used in one place
- ❌ Functionality is still changing rapidly
- ❌ Copy-paste would be simpler

---

## Creating a New Library

### Option 1: Start from Template
```powershell
cp -r C:\dev\templates\starter-node-service C:\dev\libs\my-lib
cd C:\dev\libs\my-lib
# Adapt for library (remove app-specific code)
```

### Option 2: Extract from Existing Project
```powershell
# When code in apps/ becomes reusable:
mkdir C:\dev\libs\extracted-lib
# Move shared code here
# Publish to npm/PyPI or use as local dependency
```

---

## Publishing

### Python (PyPI)
```bash
cd C:\dev\libs\my-python-lib
python -m build
twine upload dist/*
```

### Node (npm)
```bash
cd C:\dev\libs\my-node-lib
npm publish
```

### Local Use (without publishing)
```json
// package.json
"dependencies": {
  "my-lib": "file:../../libs/my-lib"
}
```

---

**Status:** Ready for shared code! 📦
