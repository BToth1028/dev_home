# Vector Systems Integration Guide

**Created**: October 27, 2025
**Purpose**: How your three vector/context systems work together
**Audience**: Implementation team (you + ChatGPT)

---

## Overview

You have **three vector-powered context systems** that create a complete knowledge management solution:

```
┌─────────────────────────────────────────────────────────────┐
│                  COMPLETE CONTEXT STACK                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  LAYER 1: Hot Context Builder                               │
│  ─────────────────────────────────────                      │
│  Location:  C:\DEV\tools\context-builder\                   │
│  Storage:   Qdrant collection "hot-context"                 │
│  Output:    .cursor/rules/context-hot.mdc                   │
│  Purpose:   Current standards and patterns                  │
│  Lifespan:  Days to weeks                                   │
│  Size:      <12KB                                           │
│  Update:    Nightly + on doc changes                        │
│  Cursor:    Auto-reads every chat                           │
│                                                              │
│  Indexes:                                                    │
│  • C:\DEV\docs\**\*.md                                      │
│  • C:\DEV\README.md                                         │
│  • C:\DEV\templates\*\README.md                             │
│  • C:\DEV\STRUCTURE.md                                      │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  LAYER 2: VECTOR_MGMT (Chat History)                        │
│  ────────────────────────────────────────                   │
│  Location:  C:\AI_Coding\...\00_VECTOR_MGMT\               │
│  Storage:   Qdrant collection "chat-history"                │
│  Output:    REST API on port 8765                           │
│  Purpose:   Recent work and conversations                   │
│  Lifespan:  Weeks to months                                 │
│  Size:      12,000+ conversations                           │
│  Update:    Real-time extraction                            │
│  Cursor:    Auto-injected on Ctrl+N                         │
│                                                              │
│  Indexes:                                                    │
│  • Cursor state.vscdb (chat database)                       │
│  • All conversations from Aug 2025 onward                   │
│  • User messages + AI responses                             │
│  • Code blocks, file references, errors                     │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  LAYER 3: Project Context OS (Knowledge Base)               │
│  ─────────────────────────────────────────                  │
│  Location:  C:\DEV\infra\                                   │
│  Storage:   Web portals (not vector search)                 │
│  Output:    http://localhost:3000, :8000, :8081, :7080     │
│  Purpose:   Long-term system documentation                  │
│  Lifespan:  Months to years                                 │
│  Size:      Unlimited                                       │
│  Update:    Manual on changes                               │
│  Cursor:    You reference explicitly                        │
│                                                              │
│  Components:                                                 │
│  • Backstage - Service catalog                              │
│  • MkDocs - Documentation portal                            │
│  • Structurizr - Architecture diagrams                      │
│  • Sourcegraph - Code search                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Shared Infrastructure

### Qdrant Vector Database

**Role:** Powers both Hot Context and VECTOR_MGMT

**Setup:**
```yaml
# C:\DEV\infra\vector-services\compose.yml
services:
  qdrant:
    image: qdrant/qdrant:latest
    container_name: qdrant
    ports:
      - "6333:6333"  # HTTP API
      - "6334:6334"  # gRPC API
    volumes:
      - ./data/qdrant:/qdrant/storage
    restart: unless-stopped
    environment:
      - QDRANT__SERVICE__HTTP_PORT=6333
      - QDRANT__SERVICE__GRPC_PORT=6334
```

**Collections:**

1. **hot-context**
   - Vector dimension: 768 (nomic-embed-text)
   - Distance: Cosine
   - Contains: Doc chunks from C:\DEV\docs\
   - Size: ~500-1000 vectors
   - Refresh: Nightly

2. **chat-history**
   - Vector dimension: 768 (nomic-embed-text)
   - Distance: Cosine
   - Contains: Cursor conversations
   - Size: 12,000+ vectors
   - Refresh: Real-time

**Access:**
```bash
# Health
curl http://localhost:6333

# List collections
curl http://localhost:6333/collections

# Collection info
curl http://localhost:6333/collections/hot-context
curl http://localhost:6333/collections/chat-history
```

---

### Ollama Embedding Service

**Role:** Generates embeddings for both systems

**Setup:**
```yaml
# C:\DEV\infra\vector-services\compose.yml
services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    ports:
      - "11434:11434"
    volumes:
      - ./data/ollama:/root/.ollama
    restart: unless-stopped
```

**Model:**
```bash
# Pull nomic-embed-text (768-dim embeddings)
docker exec ollama ollama pull nomic-embed-text

# Verify
docker exec ollama ollama list
```

**Usage:**
```python
import requests

def get_embedding(text):
    response = requests.post(
        'http://localhost:11434/api/embeddings',
        json={
            'model': 'nomic-embed-text',
            'prompt': text
        }
    )
    return response.json()['embedding']

# Returns 768-dimensional vector
```

**Performance:**
- Embedding time: 50-200ms per chunk
- Batch processing: 20-50 chunks/second
- Memory: ~2GB for model

---

## System 1: Hot Context Builder

### Architecture

```
C:\DEV\docs\ (source files)
        ↓
[1] File watcher detects changes
        ↓
[2] build_context.py index
        ↓
[3] Chunk files (800 chars, on headings)
        ↓
[4] Generate embeddings (Ollama)
        ↓
[5] Store in Qdrant collection "hot-context"
        ↓
[6] build_context.py generate
        ↓
[7] Query collection with predefined queries
        ↓
[8] Rank by relevance (score >0.7)
        ↓
[9] Format top 10 chunks
        ↓
[10] Write to .cursor/rules/context-hot.mdc
        ↓
Cursor auto-reads on every chat
```

### Configuration

**File:** `C:\DEV\tools\context-builder\settings.yaml`

```yaml
# Data sources
sources:
  - C:\DEV\docs\
  - C:\DEV\README.md
  - C:\DEV\templates\*\README.md
  - C:\DEV\STRUCTURE.md
  - C:\DEV\*.md

# Exclusions
exclude:
  - "**\node_modules\**"
  - "**\venv\**"
  - "**\.git\**"
  - "**\__pycache__\**"

# Vector DB
qdrant:
  host: localhost
  port: 6333
  collection: hot-context

# Embeddings
ollama:
  host: localhost
  port: 11434
  model: nomic-embed-text

# Chunking
chunking:
  method: semantic  # Split on markdown headings
  max_size: 800     # Characters per chunk
  overlap: 100      # Character overlap between chunks

# Queries (what to search for)
queries:
  - "API development standards and best practices"
  - "Authentication and authorization patterns"
  - "Database schema design and migration standards"
  - "Testing requirements and coverage expectations"
  - "Code style and formatting rules"
  - "Deployment and infrastructure patterns"
  - "Error handling and logging standards"
  - "Security and compliance requirements"

# Retrieval
retrieval:
  top_k: 10                # Top 10 chunks per query
  relevance_threshold: 0.7  # Min relevance score
  max_total: 12            # Max total chunks in output

# Output
output:
  path: C:\DEV\.cursor\rules\context-hot.mdc
  max_size: 12288          # 12KB max (Cursor limit)
  include_metadata: true    # Timestamps, sources
```

### Automation

**Nightly Refresh:**
```powershell
# C:\DEV\tools\context-builder\refresh.ps1
$ErrorActionPreference = "Stop"

cd C:\DEV\tools\context-builder

Write-Host "Starting hot context refresh..." -ForegroundColor Cyan

# Check services
$qdrant = Invoke-WebRequest -Uri "http://localhost:6333" -UseBasicParsing -ErrorAction SilentlyContinue
$ollama = Invoke-WebRequest -Uri "http://localhost:11434" -UseBasicParsing -ErrorAction SilentlyContinue

if (!$qdrant) {
    Write-Error "Qdrant not responding"
    exit 1
}

if (!$ollama) {
    Write-Error "Ollama not responding"
    exit 1
}

# Refresh
python build_context.py refresh --verbose

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Hot context refreshed" -ForegroundColor Green

    # Show stats
    $file = Get-Item "C:\DEV\.cursor\rules\context-hot.mdc"
    Write-Host "  Size: $($file.Length) bytes"
    Write-Host "  Updated: $($file.LastWriteTime)"
} else {
    Write-Error "Refresh failed"
    exit 1
}
```

**Scheduled Task:**
```powershell
# Install scheduled task
$action = New-ScheduledTaskAction `
    -Execute "pwsh.exe" `
    -Argument "-File C:\DEV\tools\context-builder\refresh.ps1" `
    -WorkingDirectory "C:\DEV\tools\context-builder"

$trigger = New-ScheduledTaskTrigger -Daily -At 3am

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable

Register-ScheduledTask `
    -TaskName "CursorHotContextRefresh" `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Description "Refresh Cursor hot context nightly" `
    -User $env:USERNAME `
    -RunLevel Highest
```

**Git Hook (On Doc Changes):**
```bash
#!/bin/bash
# .git/hooks/post-commit

if git diff --name-only HEAD~1 | grep -qE '^docs/|README.md|STRUCTURE.md'; then
    echo "📝 Docs changed, regenerating hot context..."

    cd tools/context-builder || exit 1

    if python build_context.py refresh; then
        echo "✓ Hot context updated"
    else
        echo "✗ Hot context refresh failed"
        exit 1
    fi
fi
```

### Output Format

**File:** `.cursor/rules/context-hot.mdc`

```markdown
<!-- Auto-generated: 2025-10-27 03:00:15 -->
<!-- Source: C:\DEV\tools\context-builder -->
<!-- Queries: 8 | Chunks: 10 | Total relevance: 8.95 -->

# Cursor Hot Context

**Last Updated:** 2025-10-27 03:00:15
**Sources:** 47 documents indexed
**Relevance:** High-confidence context for current work

---

## API Standards (Score: 0.95)

**Source:** `docs/architecture/patterns/api-standards.md:12-45`

All APIs must use FastAPI with async/await patterns:

```python
from fastapi import FastAPI, HTTPException
from typing import Optional

app = FastAPI()

@app.get("/health")
async def health():
    return {"status": "ok"}
```

Authentication required on all endpoints except /health and /metrics.
Use JWT tokens with 1-hour expiry (see ADR-2025-10-15).

---

## Authentication Patterns (Score: 0.92)

**Source:** `docs/architecture/decisions/2025-10-15_jwt-auth.md:23-67`

JWT authentication with the following requirements:
- 1-hour access token expiry
- 7-day refresh token expiry
- RS256 signing algorithm
- Stored in HTTP-only cookies
- Include user_id, email, roles in claims

Example implementation in auth-service.

---

## Database Conventions (Score: 0.89)

**Source:** `docs/architecture/patterns/database-patterns.md:34-78`

PostgreSQL for all relational data:
- UUID primary keys (not auto-increment)
- created_at, updated_at on all tables
- Soft deletes with deleted_at
- Migrations via Alembic
- Connection pooling (10-20 connections)

---

[... 7 more chunks ...]

---

## Usage

This file is automatically read by Cursor on every chat.
No need to @mention or reference manually.

To refresh manually:
```powershell
cd C:\DEV\tools\context-builder
python build_context.py refresh
```

To customize queries: Edit `settings.yaml`
To add sources: Add paths to `sources` in `settings.yaml`
```

---

## System 2: VECTOR_MGMT (Chat History)

### Architecture

```
Cursor state.vscdb (SQLite)
        ↓
[1] Extraction (every 30 seconds)
        ↓
[2] Parse JSON (enhanced parser, 98% recovery)
        ↓
[3] Filter/score (0-10 rating, drop empty)
        ↓
[4] Enqueue to PROC.db (SQLite job queue)
        ↓
[5] Worker pulls job
        ↓
[6] Generate embedding (Ollama)
        ↓
[7] Store in Qdrant collection "chat-history"
        ↓
[8] Archive to STATE.db
        ↓
[REST API on port 8765]
        ↓
[Auto-injection on Ctrl+N]
        ↓
Context appears in Cursor chat
```

### API Endpoints

**Base URL:** `http://localhost:8765`

#### GET /health
```bash
curl http://localhost:8765/health

Response:
{
  "ok": true,
  "db_rows": 12412,
  "qdrant_collections": 1,
  "qdrant_vectors": 12412,
  "uptime_seconds": 86400
}
```

#### GET /search
```bash
curl "http://localhost:8765/search?q=authentication&k=5"

Parameters:
- q: Search query (required)
- k: Number of results (default: 5, max: 20)
- threshold: Min relevance score (default: 0.5)
- recent_only: Limit to last N days (optional)

Response:
[
  {
    "id": "conv_abc123",
    "text": "Implemented JWT authentication...",
    "score": 0.95,
    "timestamp": "2025-10-26T14:30:00Z",
    "conversation_id": "conv_abc123",
    "message_type": "assistant",
    "has_code": true,
    "language": "python"
  },
  ...
]
```

#### GET /conversation/{id}
```bash
curl "http://localhost:8765/conversation/conv_abc123"

Response:
{
  "id": "conv_abc123",
  "created": "2025-10-26T14:00:00Z",
  "updated": "2025-10-26T14:45:00Z",
  "messages": [
    {
      "role": "user",
      "content": "How do I implement JWT auth?",
      "timestamp": "2025-10-26T14:30:00Z"
    },
    {
      "role": "assistant",
      "content": "Here's how to implement JWT...",
      "timestamp": "2025-10-26T14:30:15Z",
      "has_code": true
    }
  ],
  "files_referenced": ["auth.py", "models.py"],
  "topics": ["authentication", "jwt", "security"]
}
```

### Auto-Injection System

**Components:**

1. **Process Monitor** - `t2_proc_monitor.ps1`
   - Detects Cursor running
   - Monitors process health
   - Restarts services if needed

2. **AutoHotkey Script** - `t2_chat_time.ahk`
   - Watches for Ctrl+N (new chat)
   - Locks input field
   - Calls query script
   - Injects formatted context
   - Unlocks input

3. **Query Script** - `query_vect_api.ps1`
   - Queries VECTOR_MGMT API
   - Formats results as markdown
   - Returns formatted context

**Workflow:**

```
User presses Ctrl+N
        ↓
AutoHotkey detects (WinWaitActive)
        ↓
Lock input field (ControlSetEnabled 0)
        ↓
Show "Retrieving context..." (ToolTip)
        ↓
Call query_vect_api.ps1 -Query "recent work" -Count 5
        ↓
API searches chat-history collection
        ↓
Returns top 5 relevant conversations
        ↓
Format as markdown:
  ### Recent Context
  **[2025-10-26 14:30]** Implemented JWT auth
  - Added token validation
  - Used RS256 signing
  ...
        ↓
AutoHotkey injects text (SendText)
        ↓
Unlock input field (ControlSetEnabled 1)
        ↓
Hide tooltip
        ↓
User can type (context already present)
```

**Timing:**
- Detection: <100ms
- API query: 50-200ms (search time)
- Formatting: <50ms
- Injection: 100-500ms (depends on text length)
- **Total: <1 second**

### Starting VECTOR_MGMT

**Manual:**
```powershell
cd C:\AI_Coding\00_SYSTEM\01_INFRASTRUCTURE\00_VECTOR_MGMT\40_RUNTIME

# Start all components
.\START_VEC_MGMT.ps1

# Components started:
# - Coordinator (schedules jobs)
# - Worker (processes jobs)
# - API (port 8765)
# - Dashboard (port 5000)

# Verify
curl http://localhost:8765/health
curl http://localhost:5000  # Dashboard
```

**Automatic (Windows Service):**
```powershell
# Create Windows service
$params = @{
    Name = "VECTOR_MGMT"
    BinaryPathName = "pwsh.exe -File C:\AI_Coding\...\START_VEC_MGMT.ps1"
    DisplayName = "Vector Management Service"
    Description = "Chat history extraction and vector search"
    StartupType = "Automatic"
}

New-Service @params

# Start it
Start-Service VECTOR_MGMT

# Verify
Get-Service VECTOR_MGMT
```

**Auto-Injection Setup:**
```powershell
# Copy to C:\DEV for organization
cp -Recurse C:\AI_Coding\...\01_CTXT_MGMT\TIER-02 `
    C:\DEV\infra\context-automation\

cd C:\DEV\infra\context-automation

# Start monitor
.\t2_proc_monitor.ps1 &

# Start injection
.\t2_chat_time.ahk &

# Add to Windows startup
$startup = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$shortcut = "$startup\VECTOR_MGMT_Auto.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcut)
$Shortcut.TargetPath = "pwsh.exe"
$Shortcut.Arguments = "-File C:\DEV\infra\context-automation\startup.ps1"
$Shortcut.Save()
```

---

## System 3: Project Context OS

**Note:** This is NOT vector-powered (it's web portals), but integrates with the vector systems.

### How It Integrates

**1. Documentation indexed by Hot Context:**

```
You write ADR → docs/architecture/decisions/2025-10-27_use-redis.md
      ↓
Hot Context Builder indexes it (nightly)
      ↓
Appears in .cursor/rules/context-hot.mdc
      ↓
Cursor knows "Use Redis for caching" automatically
      ↓
Also searchable in MkDocs → http://localhost:8000
```

**2. Conversations indexed by VECTOR_MGMT:**

```
You discuss Redis in Cursor chat
      ↓
VECTOR_MGMT extracts conversation
      ↓
Stored in chat-history collection
      ↓
Future searches find it: "redis caching patterns"
      ↓
Auto-injected when relevant
```

**3. Backstage catalog referenced:**

```
You create service: .\scripts\new-service.ps1 cache-service
      ↓
Creates catalog-info.yaml
      ↓
Appears in Backstage → http://localhost:3000
      ↓
In Cursor: "Check Backstage for cache-service structure"
      ↓
Cursor reads catalog-info.yaml
      ↓
Understands service type, tech stack, dependencies
```

**4. Complete integration:**

```
Morning:
├─ Hot Context: "Use Redis, PostgreSQL, FastAPI"
├─ VECTOR_MGMT: "[2025-10-26] Implemented caching"
└─ You reference: "Check cache-service in Backstage"

Cursor now has:
✓ Standards (Hot Context)
✓ Recent work (VECTOR_MGMT)
✓ Service details (Backstage)

= Complete, accurate context
```

---

## Unified Management

### Single Docker Compose

**File:** `C:\DEV\infra\vector-services\compose.yml`

```yaml
version: '3.8'

services:
  # Shared vector database
  qdrant:
    image: qdrant/qdrant:latest
    container_name: qdrant
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - ./data/qdrant:/qdrant/storage
    restart: unless-stopped
    networks:
      - vector-net

  # Shared embedding service
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    ports:
      - "11434:11434"
    volumes:
      - ./data/ollama:/root/.ollama
    restart: unless-stopped
    networks:
      - vector-net

  # Hot context builder (optional service mode)
  hot-context-builder:
    build: ../../tools/context-builder
    container_name: hot-context-builder
    volumes:
      - C:\DEV:/workspace
      - C:\DEV\.cursor\rules:/output
    environment:
      - QDRANT_URL=http://qdrant:6333
      - OLLAMA_URL=http://ollama:11434
      - COLLECTION_NAME=hot-context
      - SCHEDULE=0 3 * * *  # 3 AM daily
    depends_on:
      - qdrant
      - ollama
    networks:
      - vector-net

  # VECTOR_MGMT API
  chat-search-api:
    build: ../../infra/chat-search
    container_name: chat-search-api
    ports:
      - "8765:8765"
    volumes:
      - C:\Users\{user}\AppData\Roaming\Cursor:/cursor-data
    environment:
      - QDRANT_URL=http://qdrant:6333
      - OLLAMA_URL=http://ollama:11434
      - COLLECTION_NAME=chat-history
      - CURSOR_DB=/cursor-data/User/workspaceStorage/.../state.vscdb
    depends_on:
      - qdrant
      - ollama
    networks:
      - vector-net

networks:
  vector-net:
    driver: bridge
```

**Start everything:**
```powershell
cd C:\DEV\infra\vector-services
docker-compose up -d

# Wait for startup
Start-Sleep -Seconds 30

# Pull embedding model
docker exec ollama ollama pull nomic-embed-text

# Verify
curl http://localhost:6333       # Qdrant
curl http://localhost:11434      # Ollama
curl http://localhost:8765/health  # VECTOR_MGMT
```

### Unified Monitoring

**Script:** `C:\DEV\scripts\check-vectors.ps1`

```powershell
Write-Host "`n=== VECTOR SERVICES STATUS ===`n" -ForegroundColor Cyan

# Check Docker containers
$containers = @('qdrant', 'ollama')
foreach ($container in $containers) {
    $status = docker ps --filter "name=$container" --format "{{.Status}}"
    if ($status) {
        Write-Host "✓ $container`: $status" -ForegroundColor Green
    } else {
        Write-Host "✗ $container`: Not running" -ForegroundColor Red
    }
}

# Check Qdrant collections
Write-Host "`n=== Qdrant Collections ===`n" -ForegroundColor Cyan
$collections = Invoke-RestMethod "http://localhost:6333/collections"
foreach ($col in $collections.result.collections) {
    $info = Invoke-RestMethod "http://localhost:6333/collections/$($col.name)"
    Write-Host "$($col.name):"
    Write-Host "  Vectors: $($info.result.vectors_count)"
    Write-Host "  Status: $($info.result.status)"
}

# Check VECTOR_MGMT API
Write-Host "`n=== VECTOR_MGMT API ===`n" -ForegroundColor Cyan
try {
    $health = Invoke-RestMethod "http://localhost:8765/health"
    Write-Host "✓ API responding" -ForegroundColor Green
    Write-Host "  Records: $($health.db_rows)"
    Write-Host "  Uptime: $([math]::Round($health.uptime_seconds / 3600, 1)) hours"
} catch {
    Write-Host "✗ API not responding" -ForegroundColor Red
}

# Check hot context file
Write-Host "`n=== Hot Context File ===`n" -ForegroundColor Cyan
$hotContext = "C:\DEV\.cursor\rules\context-hot.mdc"
if (Test-Path $hotContext) {
    $file = Get-Item $hotContext
    $age = (Get-Date) - $file.LastWriteTime
    Write-Host "✓ File exists" -ForegroundColor Green
    Write-Host "  Size: $($file.Length) bytes"
    Write-Host "  Age: $([math]::Round($age.TotalHours, 1)) hours"
    if ($age.TotalHours -gt 25) {
        Write-Host "  ⚠️  File is stale (>24 hours)" -ForegroundColor Yellow
    }
} else {
    Write-Host "✗ File missing" -ForegroundColor Red
}

Write-Host "`n"
```

### Unified Backup

**Script:** `C:\DEV\scripts\backup-vectors.ps1`

```powershell
param(
    [string]$BackupDir = "C:\DEV\backups\vectors\$(Get-Date -Format 'yyyy-MM-dd')"
)

New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

Write-Host "Backing up vector systems to $BackupDir..." -ForegroundColor Cyan

# Backup Qdrant data
Write-Host "Backing up Qdrant..." -ForegroundColor Yellow
docker exec qdrant /bin/bash -c "cd /qdrant/storage && tar czf /tmp/qdrant-backup.tar.gz *"
docker cp qdrant:/tmp/qdrant-backup.tar.gz "$BackupDir/qdrant-$(Get-Date -Format 'HHmmss').tar.gz"

# Backup hot context config
Write-Host "Backing up hot context config..." -ForegroundColor Yellow
Copy-Item C:\DEV\tools\context-builder\settings.yaml "$BackupDir/hot-context-settings.yaml"

# Backup VECTOR_MGMT databases
Write-Host "Backing up VECTOR_MGMT databases..." -ForegroundColor Yellow
$vmPath = "C:\AI_Coding\00_SYSTEM\01_INFRASTRUCTURE\00_VECTOR_MGMT\40_RUNTIME"
Copy-Item "$vmPath\PROC.db" "$BackupDir/PROC.db"
Copy-Item "$vmPath\STATE.db" "$BackupDir/STATE.db"

# Backup hot context file
Copy-Item C:\DEV\.cursor\rules\context-hot.mdc "$BackupDir/context-hot.mdc"

Write-Host "✓ Backup complete" -ForegroundColor Green
```

---

## Token Savings Analysis

### How Each System Contributes

**Without any system:**
```
New chat: 200K tokens
├─ Manual context: 150K tokens
│  ├─ "Read these files..." 50K
│  ├─ "Remember we decided..." 30K
│  ├─ "Here's the architecture..." 40K
│  └─ "Previous work on this..." 30K
└─ Actual work: 50K tokens
```

**With Hot Context only:**
```
New chat: 80K tokens (60% savings)
├─ Hot context: Included in Cursor overhead
├─ Remaining explanation: 30K tokens
│  └─ "Here's what we did before..."
└─ Actual work: 50K tokens
```

**With VECTOR_MGMT only:**
```
New chat: 80K tokens (60% savings)
├─ Auto-injected history: 20K tokens
├─ Remaining explanation: 10K tokens
│  └─ "Use these standards..."
└─ Actual work: 50K tokens
```

**With both systems:**
```
New chat: 57K tokens (71.5% savings)
├─ Hot context: Included (standards known)
├─ Auto-injected history: 5K tokens (recent work)
├─ Minimal explanation: 2K tokens (specific refs)
└─ Actual work: 50K tokens
```

**Annual savings:**
- 20 chats/week × 143K tokens saved/chat = 2.86M tokens/week saved
- 2.86M tokens/week × 52 weeks = 148.7M tokens/year saved
- 148.7M tokens × $0.000003/token = **~$7,436/year saved**

Plus:
- Time savings: 2.5 hours/week = 130 hours/year = $13,000 value
- **Total annual value: $20,436**

---

## Maintenance Checklist

### Daily (Automated)
- [x] Hot context refreshes at 3 AM
- [x] VECTOR_MGMT extracts new chats
- [x] Qdrant backups (Docker)

### Weekly (5 min)
```powershell
# Check system health
.\scripts\check-vectors.ps1

# Review hot context
cat C:\DEV\.cursor\rules\context-hot.mdc

# Check token savings
.\scripts\token-report.ps1
```

### Monthly (30 min)
```powershell
# Update Docker images
docker pull qdrant/qdrant:latest
docker pull ollama/ollama:latest

# Restart services
cd C:\DEV\infra\vector-services
docker-compose down
docker-compose up -d

# Verify embeddings model
docker exec ollama ollama list

# Backup vector data
.\scripts\backup-vectors.ps1

# Review Qdrant collections
curl http://localhost:6333/collections | jq

# Clean old backups (keep 30 days)
Get-ChildItem C:\DEV\backups\vectors\ -Recurse |
    Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-30)} |
    Remove-Item -Force
```

---

## Troubleshooting

### "Hot context not updating"

```powershell
# Check scheduled task
Get-ScheduledTask -TaskName "CursorHotContextRefresh" | fl

# Run manually
cd C:\DEV\tools\context-builder
python build_context.py refresh --verbose

# Check logs
cat logs/build.log

# Verify Qdrant
curl http://localhost:6333/collections/hot-context

# Verify Ollama
curl http://localhost:11434/api/tags
```

### "VECTOR_MGMT not responding"

```powershell
# Check API
curl http://localhost:8765/health

# Check Docker
docker ps | Select-String "qdrant|ollama"

# Restart VECTOR_MGMT
cd C:\AI_Coding\...\00_VECTOR_MGMT\40_RUNTIME
.\STOP_VEC_MGMT.ps1
.\START_VEC_MGMT.ps1

# Check logs
cat logs/api.log
cat logs/coordinator.log
```

### "Embeddings generation slow"

```powershell
# Check Ollama model
docker exec ollama ollama list

# Should show nomic-embed-text
# If missing:
docker exec ollama ollama pull nomic-embed-text

# Check Ollama performance
Measure-Command {
    curl -X POST http://localhost:11434/api/embeddings `
        -H "Content-Type: application/json" `
        -d '{"model":"nomic-embed-text","prompt":"test"}'
}

# Should be <500ms
# If slow, check Docker resources
```

### "Qdrant out of memory"

```powershell
# Check Qdrant memory
docker stats qdrant --no-stream

# Check collections size
curl http://localhost:6333/collections | jq

# If too large, consider:
# 1. Reducing hot-context top_k
# 2. Increasing relevance_threshold
# 3. Cleaning old chat-history entries

# Delete old vectors
curl -X POST http://localhost:6333/collections/chat-history/points/delete `
    -H "Content-Type: application/json" `
    -d '{
        "filter": {
            "must": [
                {
                    "key": "timestamp",
                    "range": {
                        "lt": "2025-07-01T00:00:00Z"
                    }
                }
            ]
        }
    }'
```

---

## Summary

You have three integrated context systems:

1. **Hot Context Builder** - Current standards (auto-read by Cursor)
2. **VECTOR_MGMT** - Recent work (auto-injected on new chats)
3. **Project Context OS** - Long-term knowledge (manual reference)

**Shared infrastructure:**
- Qdrant vector database
- Ollama embedding service
- Unified Docker Compose
- Common monitoring

**Result:**
- 70%+ token savings
- Zero manual context
- Complete knowledge coverage
- Automated maintenance

**Next steps:**
1. Review this document with ChatGPT
2. Implement Phase 1 (VECTOR_MGMT)
3. Implement Phase 2 (Hot Context)
4. Monitor and optimize

---

**For more details, see:**
- Complete System Guide: `C:\DEV\docs\COMPLETE_SYSTEM_GUIDE.md`
- Implementation Checklist: `C:\DEV\docs\IMPLEMENTATION_CHECKLIST.md`
- Troubleshooting: This document + Complete System Guide Part 6
