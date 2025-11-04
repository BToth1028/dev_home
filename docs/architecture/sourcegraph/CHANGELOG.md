# Sourcegraph Deployment Changelog

## 2025-10-27 - Final Simplification

### Changed
- **Deployment:** Switched to single all-in-one `sourcegraph/server:5.5.0` image
- **Architecture:** Removed multi-container approaches
- **Configuration:** Simplified to minimal environment variables

### Removed
- `docker-compose.full.yaml` - Multi-container with MinIO (abandoned approach)
- `ENHANCED_SETUP_COMPLETE.md` - Outdated multi-container documentation
- `FIX_GITHUB_SYNC.md` - No longer relevant
- `HOW_TO_FIX_LIMITATIONS.md` - Superseded by ADRs
- `SETUP_OPTIONS.md` - Only one setup option now
- `VERIFICATION_REPORT.md` - Outdated verification

### Added
- `sourcegraph/README.md` - Comprehensive operations guide
- `docs/architecture/decisions/2025-10-27_sourcegraph-deployment.md` - Primary ADR
- `docs/architecture/sourcegraph/2025-10-27_gitserver-dns-fix.md` - Technical details
- Updated `docs/architecture/sourcegraph/README.md` - Navigation hub

### Fixed
- ✅ Resolved gitserver-0 DNS lookup errors
- ✅ Eliminated circular dependency issues
- ✅ Simplified deployment to one container
- ✅ Reduced resource usage
- ✅ Improved stability

## Previous Attempts (Documented for Learning)

### Multi-Container with Separate Gitserver
**Status:** Abandoned
**Reason:** Circular dependency - gitserver needs frontend config, frontend needs gitserver available

### Multi-Container with MinIO
**Status:** Abandoned
**Reason:** Added complexity without significant benefit for local development

### Experimental Site Config Flags
**Status:** Failed
**Reason:** `experimentalFeatures.gitServerInternal` not recognized in build

## Current State

**Deployment:** Single container (`sourcegraph`)
**Image:** `sourcegraph/server:5.5.0`
**Resources:** ~2GB RAM, <1GB disk
**Status:** ✅ Production-ready for local development
**Health:** No critical errors, warnings are cosmetic

## Documentation Structure

```
sourcegraph/
├── docker-compose.yaml           # Current deployment
└── README.md                     # Operations guide

docs/architecture/sourcegraph/
├── README.md                     # Documentation hub
├── QUICK_START_GUIDE.md         # User walkthrough
├── 2025-10-27_gitserver-dns-fix.md  # Technical details
└── CHANGELOG.md                  # This file

docs/architecture/decisions/
├── 2025-10-27_sourcegraph-deployment.md           # Primary ADR
└── 2025-10-27_sourcegraph-limitations-resolved.md  # Trade-offs
```

## Migration Guide

No migration needed - current deployment is stable. If you have old volumes:

```powershell
# Clean start (optional)
cd C:\DEV\sourcegraph
docker compose down -v
docker compose up -d
```

## Future Considerations

- Monitor resource usage as repositories grow
- Consider full deployment if team size increases
- Evaluate Code Insights if external PostgreSQL becomes available
- Review official Sourcegraph updates for improved single-container options

