---
title: Project Context OS Implementation
date: 2025-10-27
status: Accepted
source: ChatGPT + Cursor
---

## Context

Need a single, enterprise-grade "context operating system" over the entire C:\DEV workspace that provides:
- Cross-repo code search and intelligence
- Developer portal with service catalog
- Always-current documentation
- Architecture visualization
- Decision log management
- Automated dependency tracking

Previous state: Documentation scattered across repos, no unified search, manual diagram updates, inconsistent decision tracking.

## Decision

Implement a **Project Context OS** using:

1. **Backstage** - Developer portal and service catalog
2. **Sourcegraph** - Cross-repo code search and intelligence
3. **Structurizr Lite** - C4 architecture diagrams from DSL
4. **MkDocs Material** - Central docs portal with search
5. **PowerShell automation** - Scripts for ADRs, dependency graphs, health checks
6. **GitHub Actions** - CI for docs, dependency graphs, security scans

## Implementation

### Core Components

**STRUCTURE.md**
- Single source of truth for entire workspace structure
- Auto-generated via `scripts\gen-structure.ps1`
- Updated by CI on every push to main

**docs/index.md**
- Portal homepage linking to all systems
- Searchable via MkDocs
- Embedded architecture diagrams

**Scripts** (`scripts/`)
- `new-adr.ps1` - Create ADRs from template
- `gen-ts-deps.ps1` - Generate TypeScript dependency graphs
- `gen-py-deps.ps1` - Generate Python dependency graphs
- `gen-structure.ps1` - Regenerate STRUCTURE.md
- `up.ps1` - Start all Context OS systems
- `down.ps1` - Stop all systems
- `smoke.ps1` - Health check all endpoints
- `backup-sourcegraph.ps1` - Backup code search data

**Configuration Files**
- `mkdocs.yml` - Documentation site config
- `package.json` - Node deps (dependency-cruiser)
- `.env.example` - Config template
- `backstage/app-config.local.yaml` - Backstage config
- `sourcegraph/docker-compose.yaml` - Code search setup

**Sample Services** (`services/`)
- `status-api/` - Python/Flask health endpoint pattern
- `status-node/` - Node/Express health endpoint pattern

**Architecture** (`docs/architecture/c4/`)
- `workspace.dsl` - C4 model in Structurizr DSL
- Rendered live via Structurizr Lite on port 8081

**CI Workflows** (`.github/workflows/`)
- `ci-docs.yml` - Build and test docs on every push
- `ci-deps.yml` - Regenerate dependency graphs automatically
- `security.yml` - Weekly CodeQL scans
- `structure.yml` - Auto-update STRUCTURE.md

### Integration with Existing Structure

**Preserves existing:**
- All `docs/` organization and naming conventions
- Polyrepo approach (`apps/`, `libs/` as separate repos)
- Template workflow and scaffolding scripts
- Sandboxie integration
- Cursor rules philosophy

**Enhances existing:**
- `docs/architecture/decisions/` - Now automated via script
- `docs/architecture/` - Adds `c4/` subdirectory for live diagrams
- `docs/index.md` - New portal homepage
- `STRUCTURE.md` - New "bible" for workspace

**Adds new:**
- `backstage/` - Developer portal
- `sourcegraph/` - Code search
- `services/` - Sample service patterns
- 8 new automation scripts
- 4 CI workflows

## Consequences

### Positive

- **Time-to-context < 30s** for any component via Sourcegraph
- **Zero manual diagram updates** - C4 models in Git, rendered live
- **Automated ADR creation** - Template-based, consistent format
- **Always-current docs** - CI regenerates graphs and structure
- **Single entry point** - Backstage portal shows all systems
- **Health visibility** - `/health` and `/ready` endpoints standardized
- **Security by default** - CodeQL, Dependabot, branch protection

### Negative

- Additional systems to maintain (Backstage, Sourcegraph)
- Docker dependency for Structurizr and Sourcegraph
- Learning curve for new tools
- Storage requirements for Sourcegraph index (~few GB per repo)

### Neutral

- Local dev uses simplified auth (guest mode)
- Production requires OIDC setup (GitHub/Google/etc.)
- MkDocs and Backstage run in separate PowerShell windows

## Alternatives Considered

### Option A: Keep status quo (scattered docs)
**Rejected:** Doesn't scale, context hunting takes too long, diagrams drift from reality

### Option B: Confluence/Notion
**Rejected:** Not Git-based, can't version control, no code search, vendor lock-in

### Option C: GitBook/Docusaurus only
**Rejected:** No code intelligence, no service catalog, no architecture visualization

### Option D: Full Backstage with plugins
**Deferred:** Start with core + TechDocs + Catalog, add plugins as needs emerge

## Implementation Checklist

- [x] Create directory structure
- [x] Create STRUCTURE.md (the "bible")
- [x] Create gen-structure.ps1 script
- [x] Create MkDocs configuration and docs/index.md
- [x] Create PowerShell automation scripts
- [x] Create Backstage configuration files
- [x] Create Sourcegraph docker-compose
- [x] Create sample status services
- [x] Create GitHub Actions workflows
- [x] Create Cursor rules file
- [x] Create decision note (this file)
- [ ] Install Backstage via `npx @backstage/create-app@latest`
- [ ] Set up Python venv and install MkDocs
- [ ] Install Node deps (dependency-cruiser)
- [ ] Configure OIDC for production
- [ ] Test smoke script
- [ ] Verify all systems start via up.ps1

## Next Steps

1. **Bootstrap local environment:**
   ```powershell
   # Python
   python -m venv .venv
   .\.venv\Scripts\pip install mkdocs-material mkdocs-mermaid2 pydeps

   # Node
   npm install

   # Backstage
   npx @backstage/create-app@latest
   # Choose: C:\DEV\backstage
   ```

2. **Start systems:**
   ```powershell
   .\scripts\up.ps1 -all
   ```

3. **Verify health:**
   ```powershell
   .\scripts\smoke.ps1
   ```

4. **Index repos in Sourcegraph:**
   - Open http://localhost:7080
   - Add repositories under C:\DEV\apps\* and C:\DEV\libs\*

5. **Register services in Backstage:**
   - Add `catalog-info.yaml` to each service
   - Backstage auto-discovers and catalogs them

## KPIs to Track

- Time-to-context < 30s
- Zero doc build errors on `main`
- Dependency graphs ≤ 1 commit behind
- ≥ 1 ADR per notable change
- All services have health endpoints
- CI green on every merge

## Links

- [STRUCTURE.md](../../../STRUCTURE.md)
- [docs/index.md](../../index.md)
- [Backstage documentation](https://backstage.io/docs)
- [Sourcegraph documentation](https://docs.sourcegraph.com/)
- [Structurizr DSL](https://structurizr.com/dsl)
- [MkDocs Material](https://squidfunk.github.io/mkdocs-material/)

---

**Author:** Engineering Team
**Reviewers:** N/A (initial implementation)
**Implementation Date:** 2025-10-27
