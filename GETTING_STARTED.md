# Getting Started with Project Context OS

Welcome! This guide walks you through setting up and using the Project Context OS.

## Prerequisites

- Windows 10/11
- PowerShell 5.1 or later
- Python 3.11+
- Node.js 20+
- Docker Desktop
- Git

## Initial Setup

### 1. Install Python Dependencies

```powershell
cd C:\DEV

# Create virtual environment
python -m venv .venv

# Activate and install
.\.venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install mkdocs-material mkdocs-mermaid2 pydeps
```

### 2. Install Node Dependencies

```powershell
npm install
```

### 3. Install Backstage

```powershell
npx @backstage/create-app@latest
# When prompted:
#   Name: backstage
#   Folder: C:\DEV\backstage
```

### 4. Configure Environment

Create `.env` from template:

```powershell
Copy-Item .env.example .env
# Edit .env and fill in your OIDC details (or leave defaults for local dev)
```

## Start the Context OS

### Option A: Start Everything

```powershell
.\scripts\up.ps1 -all
```

### Option B: Start Individual Components

```powershell
.\scripts\up.ps1 -docs          # MkDocs on :8000
.\scripts\up.ps1 -structurizr   # Structurizr on :8081
.\scripts\up.ps1 -backstage     # Backstage on :7007
.\scripts\up.ps1 -sourcegraph   # Sourcegraph on :7080
```

## Access the Systems

Once running, open:

- **Documentation Portal**: http://localhost:8000
- **Developer Portal (Backstage)**: http://localhost:7007
- **Code Search (Sourcegraph)**: http://localhost:7080
- **Architecture Diagrams (Structurizr)**: http://localhost:8081

## Common Tasks

### Create a New ADR

```powershell
.\scripts\new-adr.ps1 "Use PostgreSQL for all services"
```

This creates a dated file in `docs/architecture/decisions/` pre-filled with the template.

### Generate Dependency Graphs

For TypeScript projects:
```powershell
.\scripts\gen-ts-deps.ps1
```

For Python projects:
```powershell
.\scripts\gen-py-deps.ps1
```

Graphs are saved to `docs/architecture/`.

### Check System Health

```powershell
.\scripts\smoke.ps1
```

### Update Workspace Structure

```powershell
.\scripts\gen-structure.ps1
```

This regenerates `STRUCTURE.md` with the current workspace layout.

### Backup Sourcegraph Data

```powershell
.\scripts\backup-sourcegraph.ps1
```

## Sample Services

Two reference services demonstrate health endpoint patterns:

**Python service:**
```powershell
cd services\status-api
..\..\.venv\Scripts\pip install -r requirements.txt
..\..\.venv\Scripts\python app.py
# Runs on http://localhost:5050
```

**Node service:**
```powershell
cd services\status-node
npm install
npm start
# Runs on http://localhost:5051
```

Test with:
```powershell
curl http://localhost:5050/health
curl http://localhost:5051/health
```

## Architecture

Edit the C4 model:

1. Open `docs/architecture/c4/workspace.dsl`
2. Make changes using [Structurizr DSL syntax](https://structurizr.com/dsl)
3. Save and refresh http://localhost:8081 to see updates

## Troubleshooting

### MkDocs not found

```powershell
.\.venv\Scripts\Activate.ps1
pip install mkdocs-material mkdocs-mermaid2
```

### Backstage won't start

```powershell
cd backstage
yarn install
yarn dev
```

### Sourcegraph not starting

```powershell
docker ps -a
docker logs sourcegraph-frontend
```

### Port conflicts

Check what's using ports:
```powershell
netstat -ano | findstr :8000
netstat -ano | findstr :7007
netstat -ano | findstr :7080
netstat -ano | findstr :8081
```

## Next Steps

1. **Add your repos to Sourcegraph** - Index C:\DEV\apps\* and C:\DEV\libs\*
2. **Register services in Backstage** - Add `catalog-info.yaml` to each service
3. **Create your first ADR** - Document a decision
4. **Explore the docs** - Navigate http://localhost:8000

## Learn More

- [STRUCTURE.md](STRUCTURE.md) - Complete workspace map
- [docs/index.md](docs/index.md) - Documentation portal
- [docs/architecture/README.md](docs/architecture/README.md) - Architecture overview
- [.cursor/rules/project-context-os-enterprise.mdc](.cursor/rules/project-context-os-enterprise.mdc) - Context file

## Stopping Systems

```powershell
.\scripts\down.ps1
```

Note: MkDocs and Backstage run in separate PowerShell windows - close those manually.

---

**Questions?** Check [docs/](docs/) or create an ADR for your decision!
