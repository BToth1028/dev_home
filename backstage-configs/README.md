# Backstage Installation

This directory will contain your Backstage developer portal.

## Installation

```powershell
cd C:\DEV
npx @backstage/create-app@latest
```

When prompted:
- **Name:** `backstage`
- **Folder:** `C:\DEV\backstage`

This will scaffold a complete Backstage app into this directory.

## Configuration

After installation, the provided `app-config.local.yaml` overrides Backstage defaults with:
- Local development settings
- Guest authentication (no login required)
- TechDocs enabled
- Catalog locations pointing to `apps/`, `libs/`, `tools/`

## Running

```powershell
cd C:\DEV
.\scripts\up.ps1 -backstage
```

Or manually:
```powershell
cd backstage
yarn install
yarn dev
```

Access at: http://localhost:7007

## Usage

### Register a Service

Create `catalog-info.yaml` in your service:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: my-service
  description: My awesome service
  annotations:
    backstage.io/techdocs-ref: dir:.
spec:
  type: service
  lifecycle: production
  owner: team-platform
```

Backstage auto-discovers it via the catalog locations in `app-config.local.yaml`.

### TechDocs

Backstage renders docs from:
- Service `docs/` folders
- Main docs at `C:\DEV\docs/`

No extra setup needed - it just works!

## Customization

Edit `app-config.local.yaml` to:
- Change ports
- Add more catalog locations
- Configure integrations (GitHub, GitLab, etc.)
- Enable plugins

See [Backstage docs](https://backstage.io/docs) for details.

## Troubleshooting

**Installation fails:**
```powershell
# Ensure Node 20+ is installed
node --version

# Clear npm cache
npm cache clean --force
```

**Won't start:**
```powershell
cd backstage
rm -r node_modules
yarn install
yarn dev
```

## Related

- [Getting Started](../GETTING_STARTED.md)
- [Structure](../STRUCTURE.md)
- [Cursor Rules](../.cursor/rules/project-context-os-enterprise.mdc)
