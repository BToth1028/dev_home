# Sourcegraph Deployment with All-in-One Image

**Date:** 2025-10-27
**Status:** Implemented
**Decision:** Use `sourcegraph/server` all-in-one image for local deployment

## Context

Need a local code search and intelligence platform for the C:\DEV engineering workspace to enable:
- Cross-repository code search
- Go-to-definition across repos
- Find references globally
- Code intelligence and navigation

## Problem

Initial deployment attempts encountered several issues:
1. **gitserver-0 DNS errors** - Frontend couldn't locate internal gitserver
2. **Circular dependencies** - Separate `gitserver` and `frontend` images had startup order issues
3. **Database requirements** - Full multi-container setup requires external PostgreSQL
4. **Code Insights failures** - Bundled DB doesn't support Code Insights feature

## Decision

Deploy using `sourcegraph/server:5.5.0` all-in-one Docker image with minimal configuration.

### Architecture

```
┌───────────────────────────────────┐
│   sourcegraph (all-in-one)        │
│   - Frontend: 7080                │
│   - Internal gitserver            │
│   - Bundled PostgreSQL            │
│   - All services integrated       │
└───────────────────────────────────┘
```

### Configuration

**File:** `sourcegraph/docker-compose.yaml`

```yaml
services:
  sourcegraph:
    image: sourcegraph/server:5.5.0
    container_name: sourcegraph
    environment:
      - SRC_LOG_LEVEL=info
      - DEPLOY_TYPE=docker-compose
      - DISABLE_CODE_INSIGHTS=true
      - SRC_FRONTEND_EXTERNAL_URL=http://localhost:7080
    ports:
      - "7080:7080"
    volumes:
      - sourcegraph-data:/var/opt/sourcegraph
      - sourcegraph-config:/etc/sourcegraph
    restart: unless-stopped
```

## Rationale

### Why All-in-One Image?

1. **No inter-service dependencies** - Everything bundled internally
2. **Simpler deployment** - Single container to manage
3. **No DNS issues** - Internal services communicate via localhost
4. **Minimal resources** - ~2GB RAM, suitable for local development
5. **Quick startup** - No orchestration complexity

### Why Disable Code Insights?

- Requires external PostgreSQL with specific user roles
- Not critical for core code search functionality
- Reduces resource usage
- Eliminates startup errors

## Alternatives Considered

### Separate gitserver and frontend containers
**Rejected:** Circular dependency - gitserver needs frontend config, frontend needs gitserver available

**Details:**
- `sourcegraph/gitserver` won't start listening on port 3178 until it fetches config from frontend
- `sourcegraph/frontend` needs gitserver to be available at startup
- Both require internal DNS names (`sourcegraph-frontend-internal`) not easily configured

### Full multi-container deployment with databases
**Rejected:** Too complex for local development needs

**Details:**
- Requires PostgreSQL for main DB, codeintel DB, and codeinsights DB
- Requires MinIO or S3 for blob storage
- 5-10 containers total
- 8GB+ RAM requirement
- More suitable for production/team deployments

### Single container with experimental flags
**Rejected:** Flags not recognized in current build

**Details:**
- Attempted `experimentalFeatures.gitServerInternal` in site config
- Not supported in `sourcegraph/server:5.5.0`
- Would still have had bundled gitserver anyway

## Implementation

### Deployment

```powershell
cd C:\dev\sourcegraph
docker compose up -d
```

### Initial Setup

1. Access http://localhost:7080
2. Create admin account (first user)
3. Configure site settings:

```json
{
  "externalURL": "http://localhost:7080",
  "auth.providers": [
    {
      "type": "builtin",
      "allowSignup": true
    }
  ]
}
```

### Adding Repositories

**For local C:\DEV repos:**
- Go to Site admin → Repositories → Add repositories
- Add single Git repository
- Use format: `file:///C:/DEV/<repo>/.git`

**For GitHub/GitLab:**
- Site admin → Manage code hosts
- Add GitHub or GitLab connection
- Configure access token
- Select repositories to sync

## Results

- ✅ No gitserver-0 DNS errors
- ✅ Container stable (no restart loops)
- ✅ Frontend accessible at http://localhost:7080
- ✅ Repository indexing working
- ✅ Code search functional
- ✅ Symbol navigation working
- ✅ Resource usage: ~2GB RAM

## Lessons Learned

1. **Start simple** - All-in-one is better for local dev than microservices
2. **Check dependencies** - Separate images may have hidden coupling
3. **Read the errors** - DNS errors indicated architectural mismatch
4. **Disable optional features** - Code Insights not needed for core functionality
5. **Official images vary** - `server` vs separate `frontend`/`gitserver` have different use cases

## Maintenance

### Updates

```powershell
cd C:\dev\sourcegraph
docker compose pull
docker compose down
docker compose up -d
```

### Backup

```powershell
# Backup volumes
docker run --rm -v sourcegraph_sourcegraph-data:/data -v C:\backups:/backup alpine tar czf /backup/sourcegraph-data.tar.gz -C /data .
```

### Troubleshooting

```powershell
# Check logs
docker logs sourcegraph --tail 100 -f

# Verify no DNS errors
docker logs sourcegraph 2>&1 | findstr "gitserver-0"

# Check health
curl http://localhost:7080/healthz
```

## Related

- **Implementation:** `sourcegraph/docker-compose.yaml`
- **Documentation:** `sourcegraph/README.md`
- **User Guide:** `docs/architecture/sourcegraph/QUICK_START_GUIDE.md`
- **Architecture:** `docs/architecture/sourcegraph/2025-10-27_gitserver-dns-fix.md`

## References

- [Sourcegraph Docker Deployment](https://docs.sourcegraph.com/admin/deploy/docker-single-container)
- [All-in-One Image Documentation](https://docs.sourcegraph.com/admin/deploy/docker-single-container)

