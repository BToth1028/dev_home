# Fix Sourcegraph Known Limitations

**Date:** 2025-10-27
**Status:** Solution Design

## Current Limitations

### 1. Code Insights Disabled
**Error:** Feature unavailable
**Cause:** Requires external Postgres database

### 2. S3 Blobstore Errors
**Error:** `failed to create bucket: lookup blobstore on 127.0.0.11:53: server misbehaving`
**Cause:** Trying to connect to non-existent MinIO/S3 service for LSIF uploads

## Solutions

### Fix #1: Enable Code Insights (External Postgres)

**Option A: Use Existing Postgres Container**

If you already have a Postgres instance running (like `paprika-postgres`):

```yaml
environment:
  - CODEINSIGHTS_PGDATASOURCE=postgresql://user:pass@paprika-postgres:5432/sourcegraph_insights?sslmode=disable
  - PGDATASOURCE=postgresql://user:pass@paprika-postgres:5432/sourcegraph?sslmode=disable
```

**Option B: Add Dedicated Postgres Service**

Add to `sourcegraph/docker-compose.yaml`:

```yaml
services:
  sourcegraph-postgres:
    image: postgres:15-alpine
    container_name: sourcegraph-postgres
    restart: unless-stopped
    environment:
      - POSTGRES_USER=sourcegraph
      - POSTGRES_PASSWORD=sourcegraph
      - POSTGRES_DB=sourcegraph
    volumes:
      - sourcegraph-postgres-data:/var/lib/postgresql/data
    networks:
      - default
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U sourcegraph"]
      interval: 10s
      timeout: 5s
      retries: 5

  sourcegraph:
    depends_on:
      - sourcegraph-postgres
    environment:
      - CODEINSIGHTS_PGDATASOURCE=postgresql://sourcegraph:sourcegraph@sourcegraph-postgres:5432/sourcegraph?sslmode=disable
      - PGDATASOURCE=postgresql://sourcegraph:sourcegraph@sourcegraph-postgres:5432/sourcegraph?sslmode=disable
      - SRC_LOG_LEVEL=info
      - SRC_GIT_SERVERS=1
      - DEPLOY_TYPE=docker-compose

volumes:
  sourcegraph-postgres-data:
    driver: local
```

Then restart:
```powershell
docker compose down
docker volume rm sourcegraph_sourcegraph-data
docker compose up -d
```

### Fix #2: Add MinIO for S3-Compatible Storage

**Option A: Add MinIO Service (Recommended)**

Add to `sourcegraph/docker-compose.yaml`:

```yaml
services:
  blobstore:
    image: minio/minio:latest
    container_name: sourcegraph-minio
    restart: unless-stopped
    command: server /data --console-address ":9001"
    environment:
      - MINIO_ROOT_USER=sourcegraph
      - MINIO_ROOT_PASSWORD=sourcegraph123
    volumes:
      - sourcegraph-minio-data:/data
    ports:
      - "9000:9000"
      - "9001:9001"
    networks:
      - default
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 20s
      retries: 3

  sourcegraph:
    depends_on:
      - blobstore
    environment:
      - PRECISE_CODE_INTEL_UPLOAD_BACKEND=blobstore
      - PRECISE_CODE_INTEL_UPLOAD_AWS_ENDPOINT=http://blobstore:9000
      - PRECISE_CODE_INTEL_UPLOAD_AWS_ACCESS_KEY_ID=sourcegraph
      - PRECISE_CODE_INTEL_UPLOAD_AWS_SECRET_ACCESS_KEY=sourcegraph123
      - PRECISE_CODE_INTEL_UPLOAD_AWS_USE_PATH_STYLE=true
      - PRECISE_CODE_INTEL_UPLOAD_BUCKET=lsif-uploads

volumes:
  sourcegraph-minio-data:
    driver: local
```

**Option B: Use Disk Storage (Simpler)**

Modify `sourcegraph/docker-compose.yaml`:

```yaml
services:
  sourcegraph:
    environment:
      - PRECISE_CODE_INTEL_UPLOAD_BACKEND=disk
      - PRECISE_CODE_INTEL_UPLOAD_ROOT=/var/opt/sourcegraph/lsif-uploads
```

The uploads will be stored in the existing volume.

### Fix #3: Complete Solution (Both Fixes)

Combine both fixes for full functionality:

```yaml
services:
  sourcegraph-postgres:
    image: postgres:15-alpine
    container_name: sourcegraph-postgres
    restart: unless-stopped
    environment:
      - POSTGRES_USER=sourcegraph
      - POSTGRES_PASSWORD=sourcegraph
      - POSTGRES_DB=sourcegraph
    volumes:
      - sourcegraph-postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U sourcegraph"]
      interval: 10s
      timeout: 5s
      retries: 5

  blobstore:
    image: minio/minio:latest
    container_name: sourcegraph-minio
    restart: unless-stopped
    command: server /data --console-address ":9001"
    environment:
      - MINIO_ROOT_USER=sourcegraph
      - MINIO_ROOT_PASSWORD=sourcegraph123
    volumes:
      - sourcegraph-minio-data:/data
    ports:
      - "9000:9000"
      - "9001:9001"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 20s
      retries: 3

  sourcegraph:
    image: sourcegraph/server:5.5.0
    container_name: sourcegraph-frontend
    restart: unless-stopped
    depends_on:
      - sourcegraph-postgres
      - blobstore
    ports:
      - "7080:7080"
      - "2633:2633"
    volumes:
      - sourcegraph-data:/var/opt/sourcegraph
      - sourcegraph-config:/etc/sourcegraph
    environment:
      - SRC_FRONTEND_INTERNAL=sourcegraph-frontend:3090
      - SRC_LOG_LEVEL=info
      - SRC_GIT_SERVERS=1
      - DEPLOY_TYPE=docker-compose
      - CODEINSIGHTS_PGDATASOURCE=postgresql://sourcegraph:sourcegraph@sourcegraph-postgres:5432/sourcegraph?sslmode=disable
      - PGDATASOURCE=postgresql://sourcegraph:sourcegraph@sourcegraph-postgres:5432/sourcegraph?sslmode=disable
      - PRECISE_CODE_INTEL_UPLOAD_BACKEND=blobstore
      - PRECISE_CODE_INTEL_UPLOAD_AWS_ENDPOINT=http://blobstore:9000
      - PRECISE_CODE_INTEL_UPLOAD_AWS_ACCESS_KEY_ID=sourcegraph
      - PRECISE_CODE_INTEL_UPLOAD_AWS_SECRET_ACCESS_KEY=sourcegraph123
      - PRECISE_CODE_INTEL_UPLOAD_AWS_USE_PATH_STYLE=true
      - PRECISE_CODE_INTEL_UPLOAD_BUCKET=lsif-uploads
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost:7080"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 300s

volumes:
  sourcegraph-data:
    driver: local
  sourcegraph-config:
    driver: local
  sourcegraph-postgres-data:
    driver: local
  sourcegraph-minio-data:
    driver: local

networks:
  default:
    name: sourcegraph-network
```

## Recommended Approach

**Quick Fix (Disk Storage):** Use Option B for blobstore - no new containers, just disk storage.

**Full Enterprise Setup:** Use Option A + MinIO for complete functionality with Code Insights and S3 storage.

**Minimal Impact:** Keep current setup - these are warnings, not critical errors. Core search works fine.

## Implementation Steps

### Quick Fix (Recommended for Now)

```powershell
# Edit docker-compose.yaml to add disk storage
cd C:\DEV\sourcegraph

# Add these environment variables to sourcegraph service:
# - PRECISE_CODE_INTEL_UPLOAD_BACKEND=disk
# - PRECISE_CODE_INTEL_UPLOAD_ROOT=/var/opt/sourcegraph/lsif-uploads

# Restart
docker compose restart sourcegraph

# Verify - should see no more blobstore errors
docker logs sourcegraph-frontend --tail 50 | sls "blobstore|error"
```

### Full Setup (For Production)

```powershell
# Backup current state
.\scripts\backup-sourcegraph.ps1

# Update docker-compose.yaml with complete solution
cd C:\DEV\sourcegraph

# Restart with new services
docker compose down
docker compose up -d

# Wait for initialization
Start-Sleep -Seconds 30

# Verify all services
docker ps
docker logs sourcegraph-frontend --tail 100
```

## Verification

After applying fixes:

```powershell
# Check all containers running
docker ps --filter "name=sourcegraph"

# Check for errors
docker logs sourcegraph-frontend --tail 200 | sls "FATAL|error"

# Test health endpoints
curl http://localhost:7080/healthz  # Should return 200 OK

# If MinIO added, check it:
curl http://localhost:9001  # MinIO console
```

## Trade-offs

| Approach | Pros | Cons |
|----------|------|------|
| **Keep as-is** | No changes needed | Warning messages, no Insights |
| **Disk storage** | Simple, no new containers | Limited scalability |
| **MinIO + Postgres** | Full features, scalable | More complexity, more resources |

## Related

- [Sourcegraph DB Failure Fix](2025-10-27_sourcegraph-db-failure.md)
- [Sourcegraph docker-compose.yaml](../../sourcegraph/docker-compose.yaml)
- [MinIO Documentation](https://min.io/docs/minio/container/index.html)
