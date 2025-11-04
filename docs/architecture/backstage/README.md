# Backstage Documentation

Developer portal and service catalog documentation.

## Quick Start

```powershell
# Start Backstage
cd C:\DEV
.\scripts\up.ps1 -backstage

# Access UI
# Open: http://localhost:7007
```

## Documentation

- **[Backstage README](../../backstage/README.md)** - Complete setup and usage guide
- **[Templates](../../backstage/templates/)** - Service scaffolding templates (when created)

## Architecture Decisions

- **[Backstage Deployment](../decisions/2025-10-27_backstage-deployment.md)** - Local vs cloud strategy (if exists)

## What is Backstage?

Backstage is an open-source developer portal that centralizes:

### Core Capabilities
- **Service Catalog** - Registry of all services, libraries, tools
- **Software Templates** - Scaffolding with best practices
- **TechDocs** - Documentation from markdown in repos
- **Search** - Find anything across your workspace
- **Ownership Tracking** - Who owns what

### Integration with Project Context OS

Backstage complements the other systems:

- **MkDocs** - Documentation portal (cross-cutting docs)
- **Backstage** - Service catalog (per-service docs)
- **Sourcegraph** - Code search (code-level)
- **Structurizr** - Architecture diagrams (system-level)

Together they provide complete visibility across the workspace.

## Access

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:7007
- **Guest access enabled** in local dev

## File Structure

```
C:\DEV\backstage/
├── app-config.yaml              Base configuration
├── app-config.local.yaml        Local dev overrides
├── catalog-info.yaml            Self-registration
├── packages/
│   ├── app/                     Frontend
│   └── backend/                 API
└── templates/                   Service templates

docs/architecture/backstage/
└── README.md                    This file
```

## Resources

- **Official Docs:** https://backstage.io/docs
- **Getting Started:** https://backstage.io/docs/getting-started
- **Plugins:** https://backstage.io/plugins

---

**Ready to start?** See the [Backstage README](../../backstage/README.md) →
