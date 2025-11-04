# Resolve Sourcegraph "lookup gitserver-0" DNS Error with All-in-One Image

**Date:** 2025-10-27
**Status:** Implemented
**Source:** Local Docker troubleshooting

## Context

Frontend service was attempting DNS lookups for `gitserver-0` which doesn't exist in minimal deployments. The experimental `gitServerInternal` flag was either unrecognized or unsupported. Attempts to run separate `gitserver` and `frontend` containers revealed circular dependency issues.

## Problem

- Error: `lookup gitserver-0 on 127.0.0.11:53: no such host`
- Site config changes had no effect
- Single-container deployment lacks explicit gitserver addressing
- Repository synchronization stalled in QUEUED state

## Decision

Use the `sourcegraph/server` all-in-one image which bundles gitserver internally, eliminating inter-service dependency issues present in the separate `gitserver` and `frontend` images.

## Implementation

### Architecture

```
┌───────────────────────────────────┐
│   sourcegraph (all-in-one)        │
│   - Frontend: 7080                │
│   - Internal gitserver: 3178      │
│   - All services bundled          │
└───────────────────────────────────┘
```

### Configuration

**File:** `sourcegraph/docker-compose.yaml`

Key changes:
- Single `sourcegraph/server:5.5.0` all-in-one image
- Internal gitserver bundled (no inter-service dependencies)
- `DISABLE_CODE_INSIGHTS=true` for simplified deployment
- Removed reliance on experimental site-config flags
- Exposes both port 7080 (frontend) and 3178 (gitserver)

### Deployment Commands

```powershell
cd C:\dev\sourcegraph
docker compose down
docker compose up -d
```

### Verification

```powershell
# Check container health
docker ps --format "table {{.Names}}\t{{.Status}}"

# Verify no gitserver-0 DNS errors
docker logs sourcegraph 2>&1 | Select-String -Pattern "gitserver-0" | Measure-Object

# Check frontend is accessible
curl -I http://localhost:7080

# Monitor logs for repository activity
docker logs sourcegraph --tail 50 -f
```

### Minimal Site Config

After deployment, set this in the UI at `http://localhost:7080/site-admin/configuration`:

```json
{
  "externalURL": "http://localhost:7080",
  "auth.providers": [{ "type": "builtin", "allowSignup": true }]
}
```

**Do not** add `experimentalFeatures.gitServerInternal` — the compose setup makes it unnecessary.

## Expected Behavior

- No `gitserver-0` DNS lookup errors
- Container remains stable (no restart loops)
- Frontend accessible at http://localhost:7080
- Repository page loads without errors
- Repo statuses transition: `QUEUED → CLONING → INDEXED`
- Internal gitserver handles repository operations

## Key Takeaways

- The `gitserver-0` lookup error occurs when internal service discovery fails
- The `sourcegraph/server` all-in-one image is more reliable for minimal deployments
- Separate `gitserver` and `frontend` images have circular dependencies
- The experimental `gitServerInternal` flag may not work in all builds
- Simple deployments should use the bundled approach rather than microservices

## Alternatives Considered

### Separate gitserver and frontend containers
**Rejected:** Circular dependency - gitserver needs config from frontend before listening, but frontend needs gitserver to be available

### Single-container with site-config flag
**Rejected:** The experimental `gitServerInternal` flag wasn't recognized

### Full multi-container deployment with databases
**Rejected:** Too complex for minimal setup; requires PostgreSQL instances

### File-based repositories (`file:///`)
**Not pursued:** Workaround that doesn't solve the core DNS issue

## Related

- Docker user-defined network DNS resolution
- Sourcegraph `SRC_GIT_SERVERS` environment variable behavior
- ADR: [2025-10-27_sourcegraph-limitations-resolved.md](../decisions/2025-10-27_sourcegraph-limitations-resolved.md)
