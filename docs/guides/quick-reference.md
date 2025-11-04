# Quick Reference Card

**Last Updated:** October 27, 2025

---

## Service URLs

| Service | URL | Purpose |
|---------|-----|---------|
| **Backstage UI** | http://localhost:3000 | Service catalog, docs |
| **Backstage API** | http://localhost:7007 | Backend API |
| **MkDocs** | http://localhost:8000 | Documentation portal |
| **Structurizr** | http://localhost:8081 | Architecture diagrams |
| **Sourcegraph** | http://localhost:7080 | Code search |
| **VECTOR_MGMT** | http://localhost:8765 | Chat history search |
| **Qdrant** | http://localhost:6333 | Vector database |
| **Ollama** | http://localhost:11434 | Embeddings service |

---

## Common Commands

### Start/Stop Services
```powershell
# Start all Project Context OS services
.\scripts\up.ps1

# Stop all services
.\scripts\down.ps1

# Check health
.\scripts\check-all.ps1
```

### Hot Context
```powershell
# Refresh manually
cd C:\DEV\tools\context-builder
python build_context.py refresh

# Check file
cat C:\DEV\.cursor\rules\context-hot.mdc

# Check age
ls C:\DEV\.cursor\rules\context-hot.mdc | Select LastWriteTime
```

### VECTOR_MGMT
```powershell
# Start service
cd C:\AI_Coding\00_SYSTEM\01_INFRASTRUCTURE\00_VECTOR_MGMT\40_RUNTIME
.\START_VEC_MGMT.ps1

# Health check
curl http://localhost:8765/health

# Search history
curl "http://localhost:8765/search?q=YOUR_QUERY&k=5"

# Example searches
curl "http://localhost:8765/search?q=authentication&k=5"
curl "http://localhost:8765/search?q=database+migration&k=10"
curl "http://localhost:8765/search?q=recent+bugs&k=3"
```

### Vector Services
```powershell
# Check Qdrant
curl http://localhost:6333
curl http://localhost:6333/collections

# Check Ollama
curl http://localhost:11434
docker exec ollama ollama list

# Pull embedding model (if needed)
docker exec ollama ollama pull nomic-embed-text
```

---

## File Locations

### Configuration
- Hot Context settings: `C:\DEV\tools\context-builder\settings.yaml`
- Backstage config: `C:\DEV\backstage\app-config.local.yaml`
- MkDocs config: `C:\DEV\mkdocs.yml`
- Sourcegraph config: `C:\DEV\sourcegraph\docker-compose.yaml`

### Output
- Hot Context file: `C:\DEV\.cursor\rules\context-hot.mdc`
- Structure map: `C:\DEV\STRUCTURE.md`
- System status: `C:\DEV\STATUS.md`
- Token log: `C:\DEV\data\token-usage.csv`

### Documentation
- Complete Guide: `C:\DEV\docs\COMPLETE_SYSTEM_GUIDE.md`
- Vector Integration: `C:\DEV\docs\VECTOR_SYSTEMS_INTEGRATION.md`
- Implementation: `C:\DEV\docs\IMPLEMENTATION_CHECKLIST.md`
- ADRs: `C:\DEV\docs\architecture\decisions\`

### Scripts
- All scripts: `C:\DEV\scripts\`
- Context builder: `C:\DEV\tools\context-builder\`
- Auto-injection: `C:\DEV\infra\context-automation\`

---

## Daily Workflows

### Morning Routine
```powershell
# Check system health
.\scripts\check-all.ps1

# If services down, restart
.\scripts\up.ps1

# Open dashboards (optional)
start http://localhost:3000  # Backstage
start http://localhost:8000  # MkDocs
```

### Starting New Feature
1. Check Backstage for service: http://localhost:3000
2. Search MkDocs for past decisions: http://localhost:8000
3. Review architecture: http://localhost:8081
4. Search past work: `curl "http://localhost:8765/search?q=similar+feature&k=5"`
5. Open Cursor, press Ctrl+N (context auto-injects)
6. Reference specific docs: "Check ADR 2025-10-27"

### Making a Decision
```powershell
# Create ADR
.\scripts\new-adr.ps1 "Use Redis for caching"

# Edit file, add details
# Commit it
git add docs/architecture/decisions/
git commit -m "docs: add Redis caching decision"

# Context updates automatically (via git hook or nightly)
```

---

## Troubleshooting

### Hot Context Not Updating
```powershell
# Run manually
cd C:\DEV\tools\context-builder
python build_context.py refresh --verbose

# Check services
curl http://localhost:6333  # Qdrant
curl http://localhost:11434  # Ollama

# Check scheduled task
Get-ScheduledTask -TaskName "CursorHotContextRefresh"
```

### VECTOR_MGMT Not Responding
```powershell
# Check API
curl http://localhost:8765/health

# Restart
cd C:\AI_Coding\00_SYSTEM\01_INFRASTRUCTURE\00_VECTOR_MGMT\40_RUNTIME
.\STOP_VEC_MGMT.ps1
.\START_VEC_MGMT.ps1

# Check Docker
docker ps | Select-String "qdrant|ollama"
```

### Auto-Injection Not Working
```powershell
# Check processes
Get-Process | Where-Object {$_.Name -like "*autohotkey*"}

# Restart
cd C:\DEV\infra\context-automation
.\t2_chat_time.ahk

# Test query
.\query_vect_api.ps1 -Test -Verbose
```

### Backstage Not Loading
```powershell
# Check backend
curl http://localhost:7007

# Restart
cd C:\DEV\backstage
node .yarn/releases/yarn-4.4.1.cjs start

# Check catalog
cat C:\DEV\backstage\catalog-info.yaml
```

---

## Key Metrics

### Token Usage Targets
- Baseline (no system): 200K tokens/chat
- Target (with system): <80K tokens/chat
- Goal: >60% savings

### Check Token Usage
```powershell
# Log a chat
.\scripts\track-tokens.ps1 -Tokens 57000 -Type "with-system"

# Weekly report
.\scripts\token-report.ps1
```

### System Health
- Hot context age: <24 hours
- API response: <100ms
- Service uptime: >99%

---

## Emergency Procedures

### Disable Everything
```powershell
# Stop auto-injection
Get-Process | Where-Object {$_.Name -like "*autohotkey*"} | Stop-Process

# Stop Docker services
docker stop qdrant ollama

# Stop VECTOR_MGMT
cd C:\AI_Coding\00_SYSTEM\01_INFRASTRUCTURE\00_VECTOR_MGMT\40_RUNTIME
.\STOP_VEC_MGMT.ps1

# Remove hot context
Remove-Item C:\DEV\.cursor\rules\context-hot.mdc
```

### Restore from Backup
```powershell
# Run backup script
.\scripts\restore-vectors.ps1 -BackupDate "2025-10-27"
```

---

## Support

- Complete documentation: `C:\DEV\docs\COMPLETE_SYSTEM_GUIDE.md`
- Troubleshooting: See Complete System Guide Part 6
- Implementation help: `C:\DEV\docs\IMPLEMENTATION_CHECKLIST.md`

---

**Print this page and keep it handy!**
