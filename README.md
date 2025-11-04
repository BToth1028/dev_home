# Engineering Home - Project Context OS

**Complete development environment with integrated documentation, service catalog, code search, and architecture visualization.**

## What Is This?

A durable, enterprise-grade engineering workspace that provides:

- **Service Catalog** (Backstage) - Who owns what, service status
- **Code Search** (Sourcegraph) - Find anything across all repos
- **Documentation Portal** (MkDocs) - Searchable knowledge base
- **Architecture Diagrams** (Structurizr) - Live C4 models
- **Standardized Templates** - Bootstrap new services with best practices
- **Decision Tracking** - Architecture Decision Records (ADRs)

## Quick Start

### First Time Setup

```powershell
# See complete setup guide
code GETTING_STARTED.md

# Or quick start:
cd C:\DEV
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install mkdocs-material mkdocs-mermaid2 pydeps
npm install
```

### Start Everything

```powershell
.\scripts\up.ps1 -all
```

### Access Portals

- **Documentation:** http://localhost:8000 (MkDocs)
- **Service Catalog:** http://localhost:7007 (Backstage)
- **Code Search:** http://localhost:7080 (Sourcegraph)
- **Architecture:** http://localhost:8081 (Structurizr)

## Directory Structure

```
C:\DEV\
├── docs/                      Complete documentation
│   ├── guides/               Step-by-step guides
│   ├── architecture/         Decisions, diagrams, integrations
│   ├── reference/            Quick reference materials
│   └── index.md              Documentation portal home
├── backstage/                 Service catalog portal
├── sourcegraph/               Code search engine
├── templates/                 Service templates
│   ├── starter-python-api/   FastAPI template
│   └── starter-node-service/ Node.js template
├── scripts/                   Automation scripts
│   ├── up.ps1                Start systems
│   ├── down.ps1              Stop systems
│   ├── new-adr.ps1           Create ADR
│   └── gen-structure.ps1     Update workspace map
├── services/                  Sample services
├── apps/                      Your applications (separate repos)
├── libs/                      Shared libraries (separate repos)
├── tools/                     Development tools
├── infra/                     Infrastructure configs
├── .cursor/rules/             Cursor context files
├── GETTING_STARTED.md         Complete setup guide
├── STATUS.md                  Current system status
└── STRUCTURE.md               Workspace map ("the bible")
```

## Common Tasks

### Create a New Service

```powershell
# Create from template
.\scripts\new-service.ps1 -Name my-api -Type api

# Or manually
Copy-Item -Recurse templates\starter-python-api apps\my-api
cd apps\my-api
git init
cp .env.example .env
```

### Create an ADR

```powershell
.\scripts\new-adr.ps1 "Use PostgreSQL for persistence"
# Creates: docs/architecture/decisions/YYYY-MM-DD_use-postgresql-for-persistence.md
```

### Generate Dependency Graphs

```powershell
.\scripts\gen-ts-deps.ps1    # TypeScript projects
.\scripts\gen-py-deps.ps1    # Python projects
```

### Update Workspace Map

```powershell
.\scripts\gen-structure.ps1
# Updates: STRUCTURE.md
```

### Health Check

```powershell
.\scripts\smoke.ps1
```

## Key Documentation

### Getting Started
- **[GETTING_STARTED.md](GETTING_STARTED.md)** - Complete setup guide
- **[STATUS.md](STATUS.md)** - Current system status
- **[STRUCTURE.md](STRUCTURE.md)** - Complete workspace map

### Guides
- **[Complete System Guide](docs/guides/complete-system-guide.md)** - 60+ page comprehensive guide
- **[Implementation Checklist](docs/guides/implementation-checklist.md)** - Step-by-step implementation
- **[Quick Reference](docs/guides/quick-reference.md)** - Commands and URLs

### Architecture
- **[Architecture Overview](docs/architecture/README.md)** - System design
- **[Decisions (ADRs)](docs/architecture/decisions/)** - All architecture decisions
- **[Integration Guides](docs/architecture/integration/)** - How systems connect
- **[C4 Diagrams](docs/architecture/c4/workspace.dsl)** - Visual architecture

### References
- **[Git Commands](docs/reference/git-commands.md)** - Git cheat sheet
- **[Docker Commands](docs/reference/docker-commands.md)** - Docker reference

## Polyrepo Workspace

This workspace manages multiple repositories:

```
C:\DEV\
├── engineering-home\     ← THIS REPO (standards, templates, Context OS)
├── apps\
│   ├── user-service\    ← separate repo
│   ├── order-api\       ← separate repo
│   └── ...
└── libs\
    ├── auth-sdk\        ← separate repo
    └── ...
```

Each app/lib is its own git repository. This repo (`engineering-home`) provides:
- Shared documentation
- Service templates
- Development tools
- Standards and conventions
- Project Context OS infrastructure

## Scripts Reference

| Script | Purpose |
|--------|---------|
| `up.ps1` | Start Context OS systems |
| `down.ps1` | Stop all systems |
| `smoke.ps1` | Health check all services |
| `new-adr.ps1` | Create Architecture Decision Record |
| `new-service.ps1` | Scaffold new service from template |
| `gen-structure.ps1` | Update STRUCTURE.md map |
| `gen-ts-deps.ps1` | Generate TypeScript dependency graphs |
| `gen-py-deps.ps1` | Generate Python dependency graphs |
| `backup-sourcegraph.ps1` | Backup Sourcegraph data |
| `scaffold-repo.ps1` | Initialize new repository |

## Template Services

### Python FastAPI
```powershell
templates/starter-python-api/
├── src/              FastAPI application
├── tests/            Pytest tests
├── docs/             Documentation
├── Dockerfile        Production build
├── compose.yml       Local development
└── requirements.txt  Dependencies
```

### Node.js TypeScript
```powershell
templates/starter-node-service/
├── src/              TypeScript source
├── tests/            Jest tests
├── docs/             Documentation
├── Dockerfile        Production build
├── compose.yml       Local development
└── package.json      Dependencies
```

## Cursor Integration

This workspace includes Cursor context rules:

- `.cursor/rules/project-context-os-enterprise.mdc` - Project Context OS standards
- `.cursor/rules/context-hot.mdc` - Generated hot context (future)

These files help Cursor understand your workspace structure and conventions.

## CI/CD

GitHub Actions workflows in `.github/workflows/`:

- `ci-docs.yml` - Build and test documentation
- `ci-deps.yml` - Auto-generate dependency graphs
- `security.yml` - Weekly CodeQL security scans
- `structure.yml` - Auto-update STRUCTURE.md

## Support

### Documentation
- Browse: http://localhost:8000 (when MkDocs running)
- Search: Press `/` in MkDocs

### Find Services
- Catalog: http://localhost:7007 (Backstage)

### Search Code
- Search: http://localhost:7080 (Sourcegraph)

### View Architecture
- Diagrams: http://localhost:8081 (Structurizr)

### Issues
- Check [STATUS.md](STATUS.md) for current system status
- See [GETTING_STARTED.md](GETTING_STARTED.md) troubleshooting section
- Review [docs/guides/](docs/guides/) for comprehensive guides

## Contributing

1. Create an ADR for significant decisions
2. Update documentation when adding features
3. Follow templates for new services
4. Run health checks before committing
5. Update STRUCTURE.md if changing directory layout

## Resources

- **Backstage:** https://backstage.io/docs
- **Sourcegraph:** https://docs.sourcegraph.com
- **MkDocs:** https://squidfunk.github.io/mkdocs-material/
- **Structurizr:** https://structurizr.com/help/dsl

---

**Status:** ✅ Operational | **Last Updated:** 2025-10-27 | **Version:** 1.0
