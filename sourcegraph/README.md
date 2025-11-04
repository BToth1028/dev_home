# Sourcegraph Deployment

This directory contains the Docker Compose configuration for running a minimal Sourcegraph instance.

## Quick Start

```bash
# Start Sourcegraph
docker compose up -d

# Check status
docker ps

# View logs
docker logs sourcegraph -f

# Stop Sourcegraph
docker compose down
```

## Configuration

### Environment Variables

The deployment uses these key environment variables:

- `SRC_LOG_LEVEL=info` - Logging verbosity
- `DEPLOY_TYPE=docker-compose` - Deployment identifier
- `DISABLE_CODE_INSIGHTS=true` - Disables Code Insights for minimal setup
- `SRC_FRONTEND_EXTERNAL_URL=http://localhost:7080` - External URL

### Ports

- `7080` - Web UI and API
- `3178` - Internal gitserver (commented out by default, enable for debugging)

### Volumes

- `sourcegraph-data` - Main data directory (`/var/opt/sourcegraph`)
- `sourcegraph-config` - Configuration files (`/etc/sourcegraph`)

## Initial Setup

1. Access the UI at http://localhost:7080
2. Create the first admin user
3. Configure site settings at `/site-admin/configuration`:

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

## Adding Repositories

1. Go to **Site admin** > **Repositories** > **Manage code hosts**
2. Add your code host (GitHub, GitLab, etc.)
3. Or add individual repos via **Add repositories**

## Troubleshooting

### Check for DNS errors
```bash
docker logs sourcegraph 2>&1 | grep -i "gitserver-0"
```

### Health check
```bash
curl -I http://localhost:7080/healthz
```

### Container not starting
```bash
# Check logs
docker logs sourcegraph --tail 100

# Check resource usage
docker stats sourcegraph

# Ensure ports are free
netstat -an | findstr :7080
```

### Reset everything
```bash
docker compose down -v
docker compose up -d
```

## Resource Requirements

- **Minimum:** 2GB RAM, 2 CPU cores
- **Recommended:** 8GB RAM, 4 CPU cores
- **Disk:** 10GB+ for repositories

## Notes

- This uses the `sourcegraph/server` all-in-one image for simplicity
- For production deployments, consider the full multi-service setup
- The `gitserver-0` DNS error is resolved by using the bundled image
- No external databases required for this minimal setup

## Related Documentation

- **[Quick Start Guide](../docs/architecture/sourcegraph/QUICK_START_GUIDE.md)** - User walkthrough
- **[Architecture Docs](../docs/architecture/sourcegraph/)** - Complete Sourcegraph documentation
- **[Official Docs](https://docs.sourcegraph.com/)** - Sourcegraph official documentation

---

**See also:** [Getting Started](../GETTING_STARTED.md) | [Status](../STATUS.md) | [Structure](../STRUCTURE.md)
