# Backstage Developer Portal

Local developer portal for the C:\DEV engineering workspace - service catalog, ownership, and documentation.

## Quick Start

```powershell
# Start Backstage
cd C:\DEV
.\scripts\up.ps1 -backstage

# Or manually
cd C:\DEV\backstage
yarn dev

# Access UI
# Open: http://localhost:7007
# Frontend: 3000, Backend API: 7007
```

## What is Backstage?

Backstage is an open-source developer portal that provides:

### Core Features
- **Service Catalog** - Centralized registry of all your services, libraries, and tools
- **Software Templates** - Scaffolding for new services with best practices built-in
- **TechDocs** - Documentation automatically built from markdown in your repos
- **Search** - Find services, docs, APIs across your entire workspace
- **Ownership** - Clear ownership and responsibility tracking

### Use Cases for C:\DEV

1. **Service Discovery** - "What services do we have and who owns them?"
2. **New Service Creation** - Scaffold from templates with standards baked in
3. **Documentation Portal** - Single place for all service documentation
4. **Dependency Tracking** - See what depends on what
5. **Health Monitoring** - Service status at a glance

## Installation

Backstage is already scaffolded in this directory. If you need to reinstall:

```powershell
cd C:\DEV
npx @backstage/create-app@latest
# Name: backstage
# Folder: C:\DEV\backstage
```

First install takes ~5-10 minutes (downloads ~2900 packages).

## Configuration

### Local Development (`app-config.local.yaml`)

Configured for local dev with:
- **Guest authentication** - No login required
- **TechDocs enabled** - Renders markdown from repos
- **Catalog auto-discovery** - Scans `apps/`, `libs/`, `tools/` for `catalog-info.yaml`
- **Local ports** - Frontend: 3000, Backend: 7007

### Catalog Locations

Backstage automatically discovers services with `catalog-info.yaml`:

```yaml
catalog:
  locations:
    - type: file
      target: ../apps/**/catalog-info.yaml
    - type: file
      target: ../libs/**/catalog-info.yaml
    - type: file
      target: ../tools/**/catalog-info.yaml
```

## Usage

### Register a Service

Create `catalog-info.yaml` in your service root:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: my-service
  description: Authentication service
  annotations:
    backstage.io/techdocs-ref: dir:.
    github.com/project-slug: username/my-service
spec:
  type: service
  lifecycle: production
  owner: team-platform
  dependsOn:
    - component:default/postgres-db
    - component:default/redis-cache
```

Backstage will auto-discover it within ~30 seconds.

### Component Types

- `service` - Backend APIs, microservices
- `library` - Shared code libraries
- `website` - Frontend applications
- `resource` - Databases, queues, storage

### Lifecycles

- `experimental` - Early development, may change
- `production` - Stable, used in production
- `deprecated` - Being phased out

### TechDocs

To enable documentation for a service:

1. Add `docs/` folder with `index.md`
2. Add annotation to `catalog-info.yaml`:
   ```yaml
   annotations:
     backstage.io/techdocs-ref: dir:.
   ```
3. Docs automatically build and appear in Backstage UI

### Software Templates

Create templates in `backstage/templates/`:

```yaml
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: python-api-template
  title: Python FastAPI Service
  description: Create a new Python API with FastAPI
spec:
  owner: team-platform
  type: service
  parameters:
    - title: Service Details
      required:
        - name
        - description
      properties:
        name:
          title: Name
          type: string
        description:
          title: Description
          type: string
  steps:
    - id: fetch
      name: Fetch Template
      action: fetch:template
      input:
        url: ./skeleton
        values:
          name: ${{ parameters.name }}
```

## Access

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:7007
- **First user becomes admin**
- **Guest access enabled** in local dev

## File Structure

```
backstage/
├── app-config.yaml              # Base configuration
├── app-config.local.yaml        # Local overrides
├── catalog-info.yaml            # Backstage service registration
├── package.json                 # Dependencies
├── packages/
│   ├── app/                     # Frontend React app
│   │   ├── src/
│   │   └── package.json
│   └── backend/                 # Backend Node.js API
│       ├── src/
│       └── package.json
├── plugins/                     # Custom plugins
└── templates/                   # Service templates

backstage-configs/               # Additional configs (optional)
├── app-config.local.yaml        # Alternative local config
└── catalog-info.yaml            # Alternative catalog

docs/architecture/backstage/     # Documentation (if needed)
```

## Common Commands

```powershell
# Install dependencies
cd backstage
yarn install

# Start dev server (both frontend and backend)
yarn dev

# Start only frontend
yarn start

# Start only backend
yarn start-backend

# Build for production
yarn build

# Type checking
yarn tsc

# Linting
yarn lint
```

## Architecture Decisions

- **[Deployment Strategy](../docs/architecture/decisions/2025-10-27_backstage-deployment.md)** - Local vs cloud deployment (if exists)

## Troubleshooting

### Installation fails

```powershell
# Ensure Node 20+ and Yarn
node --version  # Should be 20+
npm install -g yarn

# Clear cache
npm cache clean --force
yarn cache clean
```

### Won't start

```powershell
cd backstage
rm -r node_modules
rm yarn.lock
yarn install
yarn dev
```

### Port conflicts

Edit `app-config.local.yaml`:
```yaml
app:
  baseUrl: http://localhost:3001  # Change from 3000
backend:
  baseUrl: http://localhost:7008  # Change from 7007
```

### Catalog not discovering services

1. Check catalog locations in `app-config.local.yaml`
2. Verify `catalog-info.yaml` syntax (use YAML validator)
3. Check backend logs for errors
4. Manual refresh: Catalog → Register Existing Component

### TechDocs not building

```powershell
# Install Python dependencies
pip install mkdocs-techdocs-core

# Check configuration
cat app-config.local.yaml | grep -A 5 techdocs
```

## Customization

### Add GitHub Integration

Edit `app-config.local.yaml`:
```yaml
integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}
```

### Add Plugins

```powershell
cd backstage
yarn add @backstage/plugin-kubernetes
# Follow plugin docs for configuration
```

### Customize Theme

Edit `packages/app/src/App.tsx` to change colors, logos, etc.

## Resources

- **Official Docs:** https://backstage.io/docs
- **Getting Started:** https://backstage.io/docs/getting-started
- **Plugin Marketplace:** https://backstage.io/plugins
- **Community:** https://discord.gg/backstage

## Related

- [MkDocs Portal](../docs/) - Documentation site
- [Sourcegraph](../sourcegraph/) - Code search
- [Getting Started](../GETTING_STARTED.md) - Workspace setup
- [Structure](../STRUCTURE.md) - Workspace map

---

**Ready to start?** Run `.\scripts\up.ps1 -backstage` →
