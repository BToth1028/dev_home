# Sourcegraph Deployment - Limitations and Trade-offs

**Date:** 2025-10-27
**Status:** Superseded by [2025-10-27_sourcegraph-deployment.md](2025-10-27_sourcegraph-deployment.md)
**Note:** This ADR documents the decision-making process. See the superseding ADR for current implementation.

## Original Limitations

### ⚠️ Code Insights disabled
- **Cause:** Requires external Postgres (bundled DB doesn't support required user roles)
- **Impact:** No dashboards, analytics, or historical metrics
- **Decision:** Disable feature for stability

### ⚠️ S3 blobstore warnings
- **Cause:** No external object storage configured
- **Impact:** Warning messages in logs, LSIF uploads unavailable
- **Decision:** Accept warnings as non-critical

## Resolution Approach

After exploring multiple options, settled on **single all-in-one image** with minimal configuration.

### Decision: Keep It Simple

**Current Implementation:**
- Single `sourcegraph/server:5.5.0` container
- Code Insights disabled via environment variable
- No external storage configured
- Accept S3 warnings as cosmetic

**Why This Approach:**
- Core functionality (code search, navigation) works perfectly
- Minimal resource usage (~2GB RAM)
- Simple to manage (one container)
- Suitable for local development
- Warnings don't affect functionality

## Alternatives Considered

### Option A: Add MinIO for Object Storage
**Rejected:** Adds complexity for marginal benefit

**Would provide:**
- Clean logs (no S3 warnings)
- LSIF upload capability

**Trade-offs:**
- Additional container to manage
- Extra 50MB+ memory usage
- More complex configuration
- Not needed for core search functionality

### Option B: External PostgreSQL for Code Insights
**Rejected:** Too complex for local development

**Would provide:**
- Code Insights dashboards
- Historical analytics

**Trade-offs:**
- 3 additional PostgreSQL containers required
- Complex user role management
- 200MB+ additional memory
- Enterprise feature not essential for local dev

### Option C: Multi-container microservices deployment
**Rejected:** Circular dependencies and complexity

**Attempted:**
- Separate `sourcegraph/gitserver` container
- Separate `sourcegraph/frontend` container

**Failed because:**
- Gitserver won't start without fetching config from frontend
- Frontend needs gitserver available at startup
- Circular dependency impossible to resolve cleanly
- Required complex internal DNS configuration

## Technical Details

### Failed Disk Storage Attempt

Tried `PRECISE_CODE_INTEL_UPLOAD_BACKEND=disk`:

```
FATAL: invalid backend "disk" for PRECISE_CODE_INTEL_UPLOAD_BACKEND:
must be S3, GCS, or Blobstore
```

**Lesson:** Sourcegraph 5.5.0 requires actual object storage protocol, not simple disk paths.

### Why Code Insights Must Be Disabled

Enabling without external DB causes crashes:

```
FATAL: role "root" does not exist (SQLSTATE 28000)
```

Bundled PostgreSQL doesn't have the user roles Code Insights expects.

## Current Status

**What Works:**
- ✅ Code search across repositories
- ✅ Symbol navigation (go-to-definition)
- ✅ Find references
- ✅ Cross-repository intelligence
- ✅ Regex search patterns
- ✅ Language-aware search

**What Doesn't Work (By Design):**
- ❌ Code Insights dashboards
- ❌ LSIF uploads
- ⚠️ S3 warnings in logs (cosmetic only)

**Resource Usage:**
- Memory: ~2GB
- Disk: <1GB for data
- CPU: <5% idle, <20% during indexing

## Recommendations

### For Local Development (Current)
**Keep the simple setup** - it provides all essential functionality with minimal overhead.

### For Team Deployment
**Consider full deployment** if:
- Multiple developers need shared instance
- LSIF uploads required
- Code Insights dashboards needed
- Clean logs important for monitoring

Reference: [Official Sourcegraph deployment docs](https://docs.sourcegraph.com/admin/deploy)

### For Production
**Use official production deployment** with:
- External PostgreSQL cluster
- Object storage (S3/GCS)
- Load balancing
- High availability

## Summary

**Problem:** Initial deployment had warnings and disabled features
**Analysis:** Explored multiple enhancement options
**Decision:** Keep simple single-container approach
**Rationale:** Core functionality works perfectly, complexity not justified for local dev
**Status:** ✅ Working as intended

The "limitations" are intentional trade-offs for simplicity, not bugs to fix.

## Related

- **Current Implementation:** [2025-10-27_sourcegraph-deployment.md](2025-10-27_sourcegraph-deployment.md)
- **Technical Details:** [2025-10-27_gitserver-dns-fix.md](../sourcegraph/2025-10-27_gitserver-dns-fix.md)
- **User Guide:** [Quick Start Guide](../sourcegraph/QUICK_START_GUIDE.md)
- **Operations:** [Sourcegraph README](../../sourcegraph/README.md)
