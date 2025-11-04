# Fix Sourcegraph frontend crash from bad Code Insights DSN

**Date:** 2025-10-27
**Status:** Implemented
**Source:** ChatGPT

## Problem

Sourcegraph container dies on startup with:

```
Failed to connect to codeinsights database … role "root" does not exist
```

Frontend's Code Insights subsystem tries to connect to Postgres using `user=root`, which doesn't exist in the bundled DB container.

## Root Cause

When `CODEINSIGHTS_PGDATASOURCE` is empty or unset, the Code Insights feature falls back to default connection parameters that assume `root` user access. The bundled Postgres in the single-node Sourcegraph container doesn't have this role configured.

## Decision

Implemented **Option A** (short-term fix): Disable Code Insights to allow the instance to start.

### Option A: Disable Code Insights (Implemented)

```yaml
environment:
  - SRC_LOG_LEVEL=info
  - DISABLE_CODE_INSIGHTS=true
```

Then reset and start clean:

```powershell
cd C:\DEV\sourcegraph
docker compose down
docker volume rm sourcegraph_sourcegraph-data
docker compose up -d
docker logs -f sourcegraph-frontend
```

Expected: "listening" without FATAL errors.

### Option B: Enterprise Setup (Future Consideration)

For full Code Insights support, run against external Postgres:

```yaml
environment:
  - CODEINSIGHTS_PGDATASOURCE=postgresql://<user>:<pass>@<pg-host>:5432/<db>?sslmode=disable
  - PGDATASOURCE=postgresql://<user>:<pass>@<pg-host>:5432/<db>?sslmode=disable
  - SRC_LOG_LEVEL=info
```

Requires:
- External Postgres instance
- Schema initialization on first boot
- Volume wipe before migration

## Verification

```powershell
docker logs sourcegraph-frontend --tail 200 | sls "listening|FATAL|error"
curl http://localhost:7080/-.healthz
```

Should return:
- 200 OK from healthcheck
- No FATAL lines in logs
- "listening" messages in logs

## Consequences

**Positive:**
- Sourcegraph instance starts successfully
- Core search and intelligence features work
- Simple single-node setup maintained

**Negative:**
- Code Insights feature disabled
- No historical code analytics
- Dashboard/metrics features unavailable

**Future:**
- Can enable Option B when enterprise features needed
- Requires external Postgres provisioning
- Migration path available when ready

## Related

- [Project Context OS Implementation](2025-10-27_project-context-os-implementation.md)
- [Sourcegraph docker-compose.yaml](../../sourcegraph/docker-compose.yaml)
- [Sourcegraph README](../../sourcegraph/README.md)

## References

- [Sourcegraph Docs: Deploy](https://docs.sourcegraph.com/admin/deploy)
- [Sourcegraph Docs: Code Insights](https://docs.sourcegraph.com/code_insights)
