# Cursor Hot Context Builder

Production-grade context management for Cursor IDE using vector search.

## What It Does

Automatically generates a compact, high-signal `.cursor/rules/context-hot.mdc` file by:
1. Indexing your docs/standards/ADRs with semantic chunking
2. Querying for most relevant context via vector search
3. Generating a <12KB rules file that Cursor auto-reads

**Result**: Cursor always has current project context without burning tokens.

## Research-Backed Design

Based on best practices from:
- Cursor community patterns
- Qdrant code search optimization
- RAG chunking research (NVIDIA, Databricks, Weaviate)

Features:
- ✅ Structure-aware chunking (splits on markdown headings)
- ✅ Hybrid search (semantic + keyword)
- ✅ Reranking for precision
- ✅ Relevance filtering (score >0.7)
- ✅ Size constraints (<12KB, ~500 lines)
- ✅ Automatic refresh (nightly + on-commit)

## Prerequisites

1. **Qdrant** (vector database)
```powershell
docker run -d -p 6333:6333 -v ${PWD}/data/qdrant:/qdrant/storage qdrant/qdrant:latest
```

2. **Ollama** (local embeddings)
```powershell
docker run -d -p 11434:11434 -v ${PWD}/data/ollama:/root/.ollama ollama/ollama:latest

# Pull embedding model
docker exec -it <container_id> ollama pull nomic-embed-text
```

3. **Python dependencies**
```powershell
pip install -r requirements.txt
```

## Quick Start

### 1. Health Check
```powershell
python build_context.py health
```

### 2. Initial Index
```powershell
python build_context.py index
```

### 3. Generate Context
```powershell
python build_context.py generate
```

### 4. Full Refresh (index + generate)
```powershell
python build_context.py refresh
```

## Configuration

Edit `settings.yaml` to customize:
- **sources**: Which dirs/files to index
- **queries**: What context to retrieve
- **top_k**: How many chunks (8-12 recommended)
- **chunk_size**: Chunk size (800-1200 optimal)
- **relevance_threshold**: Filter threshold (0.7 default)

## Automation

### Nightly Refresh (Windows Task Scheduler)

Create `refresh.ps1`:
```powershell
cd C:\DEV\tools\context-builder
python build_context.py refresh
```

Schedule:
```powershell
$action = New-ScheduledTaskAction -Execute "pwsh.exe" `
    -Argument "-File C:\DEV\tools\context-builder\refresh.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 3am
Register-ScheduledTask -TaskName "CursorContextRefresh" `
    -Action $action -Trigger $trigger
```

### Pre-Commit Hook

Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash
if git diff --cached --name-only | grep -qE '^docs/|README.md'; then
    echo "📝 Docs changed, regenerating hot context..."
    cd tools/context-builder
    python build_context.py refresh
    git add ../../.cursor/rules/context-hot.mdc
fi
```

Make executable:
```powershell
chmod +x .git/hooks/pre-commit
```

## Output

Generated file: `.cursor/rules/context-hot.mdc`

Structure:
- Header with metadata (timestamp, queries, sources)
- Top-K chunks with relevance scores
- Source file references
- Usage instructions

Cursor automatically reads this file - no manual @mentions needed.

## Troubleshooting

**"Qdrant connection failed"**
- Check Docker: `docker ps | grep qdrant`
- Check port: `curl http://localhost:6333`

**"Ollama embedding failed"**
- Check Docker: `docker ps | grep ollama`
- Pull model: `docker exec <id> ollama pull nomic-embed-text`

**"Output file too large"**
- Reduce `top_k` in `settings.yaml`
- Increase `relevance_threshold` (filter more results)
- Adjust `chunk_size` (smaller chunks)

**"Results not relevant"**
- Tune `queries` in `settings.yaml` to be more specific
- Check if sources are indexed: `python build_context.py index`
- Try different query phrasing

## Performance

- **Indexing**: ~2-5 seconds for 50 files
- **Search**: <100ms per query
- **Generation**: <2 seconds total
- **Output size**: 6-10KB typical

## Integration with Existing System

If you already have VECTOR_MGMT running:
- This tool is standalone (separate collection)
- Can coexist - different use cases:
  - VECTOR_MGMT: Full chat history search
  - Hot context: Compressed current context for Cursor

## References

- Research decisions: `../../docs/architecture/decisions/2025-10-26_cursor-context-best-practices.md`
- Integration ADR: `../../docs/architecture/decisions/2025-10-26_integrate-vector-context-mgmt.md`
- Quick wins: `../../docs/architecture/2025-10-26_vector-mgmt-quick-wins.md`
