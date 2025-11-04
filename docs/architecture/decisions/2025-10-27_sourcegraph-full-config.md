# Sourcegraph Full Configuration

**Date:** 2025-10-27
**Status:** Implemented
**Context:** Fixed Sourcegraph database authentication and enabled all features

---

## Problem

Sourcegraph was failing to start due to PostgreSQL authentication errors:
- Error: "FATAL: role 'root' does not exist"
- Code Insights database couldn't connect
- Initial solution attempted to disable features (rejected)

## Solution

Properly configured all three Sourcegraph databases with correct authentication:

```yaml
environment:
  - SOURCEGRAPH_5_1_DB_MIGRATION=true
  - PGUSER=sg
  - PGDATABASE=sg
  - PGHOST=127.0.0.1
  - CODEINTEL_PGUSER=sg
  - CODEINTEL_PGDATABASE=sg
  - CODEINTEL_PGHOST=127.0.0.1
  - CODEINSIGHTS_PGUSER=sg
  - CODEINSIGHTS_PGDATABASE=sg
  - CODEINSIGHTS_PGHOST=127.0.0.1
```

## Key Points

- **Never disable features to work around issues** - always fix root cause
- Sourcegraph 5.5.0 requires database migration flag on first startup
- Default internal PostgreSQL user is `sg`, not `root`
- All three databases need explicit configuration

## Features Enabled

✅ Code search
✅ Code intelligence
✅ Code insights
✅ Batch changes
✅ All observability features
✅ Full database functionality

## Migration Process

First startup includes automatic database reindexing:
- Takes 2-5 minutes depending on data
- Creates migration marker file
- Only runs once
- All services start after completion

## Verification

```powershell
# Check logs
docker logs sourcegraph-frontend

# Test endpoint
curl http://localhost:7080

# Monitor startup
docker ps
```

## Related

- [Project Context OS Implementation](2025-10-27_project-context-os-implementation.md)
- [Backstage Port Fix](2025-10-27_backstage-port-conflict-fix.md)

---

**Principle:** Always implement full, production-quality solutions. Never accept workarounds or disabled features.
