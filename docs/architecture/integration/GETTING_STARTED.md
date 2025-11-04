# Getting Started with Cursor Hot Context

Quick guide to set up and use the production-grade context management system.

---

## What You're Building

A system that automatically provides Cursor with relevant project context using vector search:

**Before**: Every new chat, manually explain context (150K tokens, 5-10 min)
**After**: Context auto-loaded from vector search (20-30K tokens, instant)
**Savings**: 70-90% token reduction = $25K-28K/year

---

## Prerequisites Check

### 1. Docker Desktop
```powershell
docker --version
# Should output: Docker version 24.x or higher
```

If not installed: [Download Docker Desktop](https://www.docker.com/products/docker-desktop/)

### 2. Python 3.11+
```powershell
python --version
# Should output: Python 3.11.x or higher
```

### 3. pip (Python package manager)
```powershell
pip --version
```

---

## Installation (10 minutes)

### Option A: Automated Setup (Recommended)

```powershell
cd C:\DEV\tools\context-builder
.\setup.ps1
```

This will:
1. ✅ Check Docker
2. ✅ Start Qdrant and Ollama containers
3. ✅ Download embedding model
4. ✅ Install Python dependencies
5. ✅ Create initial index
6. ✅ Generate first context file
7. ✅ Set up nightly refresh (Task Scheduler)
8. ✅ Set up pre-commit hook

**Done!** Skip to "Verification" section.

---

### Option B: Manual Setup

#### Step 1: Start Services
```powershell
cd C:\DEV\tools\context-builder
docker-compose up -d

# Wait 10 seconds for startup
Start-Sleep -Seconds 10
```

#### Step 2: Download Embedding Model
```powershell
# Find Ollama container ID
docker ps

# Pull model (replace <container_id>)
docker exec <container_id> ollama pull nomic-embed-text
```

#### Step 3: Install Python Dependencies
```powershell
pip install -r requirements.txt
```

#### Step 4: Create Initial Index
```powershell
python build_context.py refresh
```

This takes 2-5 minutes on first run.

---

## Verification

### 1. Check Services
```powershell
python build_context.py health
```

Expected output:
```
🏥 Health check...
   ✅ Qdrant: 1 collections
   ✅ Ollama: 768-dim embeddings

✅ All systems operational
```

### 2. Check Generated File
```powershell
cat .cursor\rules\context-hot.mdc
```

Should see:
- Header with timestamp
- 8-12 context chunks from your docs
- Source file references
- Relevance scores

### 3. Test in Cursor

1. Open Cursor IDE
2. Create new chat (Ctrl+L or Ctrl+K)
3. Type: "What are the project standards?"
4. Cursor should reference content from `context-hot.mdc` automatically

**If it doesn't**, check:
- File exists: `.cursor/rules/context-hot.mdc`
- File size: 6-12KB (not empty, not huge)
- Cursor restarted after generation

---

## Usage

### Daily Use (Automatic)

**You don't need to do anything.** The system:
- Refreshes nightly at 3 AM (Task Scheduler)
- Regenerates on commit when docs change (Git hook)
- Keeps Cursor context fresh automatically

### Manual Refresh

If you want to update immediately:

```powershell
cd C:\DEV\tools\context-builder

# Full refresh (re-index + regenerate)
python build_context.py refresh

# Just regenerate (use existing index)
python build_context.py generate

# Just re-index (don't regenerate yet)
python build_context.py index
```

---

## Customization

Edit `settings.yaml` to tune:

### Add More Sources
```yaml
sources:
  - docs/standards
  - docs/architecture
  - docs/architecture/decisions
  - README.md
  - apps/my-app/docs  # Add your app docs
```

### Change Queries
```yaml
queries:
  - project standards and coding conventions
  - recent architecture decisions
  - how to set up new services  # Add custom query
```

### Adjust Result Count
```yaml
top_k: 12  # Increase to 15 for more context
```

### Change Chunk Size
```yaml
chunk_size: 1000   # Increase to 1200 for longer chunks
chunk_overlap: 120  # Increase to 180 for more overlap
```

After changes:
```powershell
python build_context.py refresh
```

---

## Troubleshooting

### "Qdrant connection failed"

**Check container:**
```powershell
docker ps | Select-String "qdrant"
```

If not running:
```powershell
docker-compose up -d qdrant
```

**Check port:**
```powershell
curl http://localhost:6333
```

Should return JSON with version info.

---

### "Ollama embedding failed"

**Check container:**
```powershell
docker ps | Select-String "ollama"
```

**Check model:**
```powershell
docker exec <container_id> ollama list
# Should show: nomic-embed-text
```

If model missing:
```powershell
docker exec <container_id> ollama pull nomic-embed-text
```

---

### "Output file too large (>12KB)"

**Reduce results:**
Edit `settings.yaml`:
```yaml
top_k: 8  # Reduce from 12
relevance_threshold: 0.75  # Increase from 0.7 (filter more)
```

Then:
```powershell
python build_context.py generate
```

---

### "Results not relevant"

**Tune queries:**
Edit `settings.yaml` to be more specific:
```yaml
queries:
  - python coding standards and pathlib usage
  - recent ADRs about API design
  - directory structure for new services
```

**Check indexed files:**
```powershell
# See what's indexed
curl http://localhost:6333/collections/cursor_hot_context
```

---

### "Context not appearing in Cursor"

1. **Restart Cursor** after first generation
2. Check file exists: `.cursor\rules\context-hot.mdc`
3. Check file not empty: `cat .cursor\rules\context-hot.mdc`
4. Check `.cursorignore` doesn't block: `context-hot.mdc` should be listed (to exclude from indexing, but Cursor still reads it)

---

## Performance

**Expected metrics:**
- **Indexing**: 2-5 seconds (50 docs)
- **Search**: <100ms per query
- **Generation**: <2 seconds total
- **Output size**: 6-10KB typical

**If slower:**
- More sources = longer indexing (expected)
- Check Docker resource limits
- Check disk I/O (antivirus scanning?)

---

## Monitoring

### Check Index Size
```powershell
curl http://localhost:6333/collections/cursor_hot_context
```

Look for `"points_count"` - should match number of chunks.

### Check Task Scheduler
```powershell
Get-ScheduledTask -TaskName "CursorContextRefresh"
```

Should show:
- State: Ready
- Next Run Time: Tomorrow at 3 AM

### View Logs
```powershell
# Last run output
Get-Content C:\DEV\runtime\logs\context-refresh.log
```

---

## Next Steps

### Week 1: Observe
- Let it run for a week
- Notice if Cursor responses improve
- Check nightly refresh is working

### Week 2: Tune
- Adjust queries in `settings.yaml`
- Add more sources if needed
- Fine-tune `top_k` and thresholds

### Week 3: Measure
- Compare token usage (Cursor shows in status bar)
- Estimate cost savings
- Document patterns in ADRs

### Week 4: Expand
- Add more sources (app-specific docs)
- Create topic-specific context files
- Integrate with CI/CD pipeline

---

## Advanced: Multiple Context Files

For larger projects, split by topic:

```yaml
# settings-testing.yaml (copy of settings.yaml)
collection: cursor_context_testing
queries:
  - testing patterns and pytest usage
  - test structure and fixtures
```

Generate separate file:
```powershell
python build_context.py generate --config settings-testing.yaml --output .cursor/rules/context-testing.mdc
```

Result: Multiple specialized context files.

---

## Support

- **Documentation**: See `README.md` for technical details
- **Architecture**: See `../../docs/architecture/decisions/2025-10-26_cursor-context-best-practices.md`
- **Issues**: Check `../../docs/architecture/decisions/` for troubleshooting ADRs

---

## Success Indicators

After 1 week, you should see:

✅ **Cursor understands project context without explanation**
✅ **New chats start productively (no "what were we doing?")**
✅ **Token usage down 50-70% per chat**
✅ **Time saved: 5-10 minutes per chat**
✅ **Nightly refresh working (check Task Scheduler history)**

If not seeing these → revisit customization and troubleshooting sections.

---

**Ready? Run the setup!**

```powershell
cd C:\DEV\tools\context-builder
.\setup.ps1
```
