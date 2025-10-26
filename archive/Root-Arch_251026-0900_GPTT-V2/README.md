# Cursor Gold Standard v2

**Production-ready templates for modern development with Cursor AI.**

## Features

### AI-First Design
- `.cursorignore` files optimize AI context
- `.cursor/rules/` define coding standards per template
- Co-located documentation for better AI understanding

### Developer Experience
- DevContainer configurations for instant environments
- Docker Compose with health checks
- Pre-commit hooks (Husky + pre-commit)
- Complete CI/CD workflows (GitHub Actions)
- Automated dependency updates (Dependabot)

### Both Templates Include
- PostgreSQL 16 integration with working examples
- Health check endpoints (`/health`, `/db/ping`)
- OS-native path helpers for data/logs/cache
- Modern tooling (ESLint 9, Black, Pytest, Vitest)
- Multiple ADR examples
- Comprehensive documentation

## Quick Start

**1. Create .env.example files:**
```powershell
# Windows PowerShell
.\CREATE_ENV_FILES.ps1
```
```bash
# Linux/Mac/WSL
./CREATE_ENV_FILES.sh
```

**2. Clone a template to your apps directory:**
```bash
cp -r templates/starter-node-service ../apps/my-new-project
cd ../apps/my-new-project
cp .env.example .env
docker compose up --build
```

**3. Verify it works:**
- Node: http://localhost:3000/health
- Python: http://localhost:8000/health

## Recommended PC Layout
```
C:\dev\
  apps\         # Your applications
  libs\         # Shared libraries
  infra\        # Infrastructure code
  templates\    # Starter templates (this package)
  scratch\      # Experiments
  archive\      # Old projects
  docs\         # Cross-project docs
```

## What's New in V2

- `.cursorignore` + `.cursor/rules/` everywhere
- Dependabot configuration
- Node: ESLint 9 flat config + Husky
- Docker health checks on all services
- CONTRIBUTING.md in both templates
- Second ADR example (Python)
- Working DB integration examples
- Complete setup documentation

## Documentation

- **[SETUP.md](SETUP.md)** - Complete setup guide and usage instructions
- **[IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md)** - Feature checklist and validation
- **[docs/COMPREHENSIVE_FILESYSTEM_BEST_PRACTICES.md](docs/COMPREHENSIVE_FILESYSTEM_BEST_PRACTICES.md)** - Industry best practices
- **[docs/STRUCTURE.md](docs/STRUCTURE.md)** - Project structure reference

## Templates

### starter-node-service
TypeScript + Express + PostgreSQL
Modern ESM, Vitest testing, Husky hooks

### starter-python-api
FastAPI + PostgreSQL + Pytest
Black formatting, pre-commit hooks, type hints

## Support

See `SETUP.md` for troubleshooting and detailed instructions.

## Version

**v2.0.0** - Production Ready
**Last Updated:** 2025-10-26
