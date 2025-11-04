# ADR: Integrating Hot Context with Existing VECTOR_MGMT

**Date**: October 26, 2025
**Status**: Active
**Context**: You already have a production vector system - how does the new hot context fit?

---

## Current State: What You Already Have

### System 1: VECTOR_MGMT (Production)
**Location**: `C:\AI_Coding\00_SYSTEM\01_INFRASTRUCTURE\00_VECTOR_MGMT\`

**What it does:**
- Extracts **ALL Cursor chat history** from `state.vscdb`
- Indexes 12,412+ records with Qdrant + Ollama
- REST API on port 8765 (10-80ms search)
- Queue-based processing (coordinator + workers)
- Enhanced parser (98% data recovery, 39x improvement)

**Data source**: Past conversations (state.vscdb)
**Use case**: "What was I working on?" semantic search across chat history

### System 2: CTXT_MGMT (Production)
**Location**: `C:\AI_Coding\00_SYSTEM\01_INFRASTRUCTURE\01_CTXT_MGMT\`

**What it does:**
- AutoHotkey automation for Cursor
- Detects new chats (Ctrl+N)
- Queries VECTOR_MGMT API
- Auto-injects relevant past conversations
- Token tracking

**Data source**: VECTOR_MGMT API
**Use case**: Auto-inject context when you start a new chat

**Result**: 80-90% token savings ($480-540/week)

---

## New Addition: Hot Context Builder

### System 3: Hot Context Builder (Just Built)
**Location**: `C:\DEV\tools\context-builder\`

**What it does:**
- Indexes **project documentation** (docs/, standards/, ADRs, READMEs)
- Generates `.cursor/rules/context-hot.mdc` (<12KB)
- Cursor **automatically reads** this file (no injection needed)
- Refreshes nightly + on-commit

**Data source**: Project documentation (not chat history)
**Use case**: Cursor always knows current project standards/architecture

---

## How They Work Together (Three-Layer Context)

```
┌─────────────────────────────────────────────────────────┐
│ LAYER 1: Always-On Context (Cursor Rules)              │
│ Source: Hot Context Builder → .cursor/rules/           │
│ Content: Project standards, architecture, conventions  │
│ Token cost: 0 (Cursor reads automatically)             │
│ Refresh: Nightly + on-commit                           │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│ LAYER 2: Dynamic Context (Auto-Injected)               │
│ Source: VECTOR_MGMT → CTXT_MGMT → New chat            │
│ Content: Relevant past conversations, recent work      │
│ Token cost: 20-30K (vs 150K manual)                    │
│ Refresh: On every new chat                             │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│ LAYER 3: Your Input                                    │
│ Source: You                                             │
│ Content: Current task/question                         │
│ Token cost: 5-20K (actual work)                        │
└─────────────────────────────────────────────────────────┘
```

### Example Workflow

**You press Ctrl+N (new chat):**

1. **Cursor reads** `.cursor/rules/context-hot.mdc` automatically
   - "Use pathlib, no comments, Python 3.11+, tabs for indentation..."
   - "Services need /health endpoint, logging, metrics..."
   - "Recent ADR: Use queue-based patterns for background jobs"

2. **CTXT_MGMT detects**, queries **VECTOR_MGMT**, injects:
   ```
   ### Context from Recent Work

   [2025-10-26 15:30] Built cursor hot context system with:
   - Structure-aware semantic chunking
   - Hybrid search + reranking
   - Auto-generation of rules file

   [2025-10-26 14:00] Enhanced .cursorignore to exclude noise

   [2025-10-25 16:00] Expanded project-standards.mdc with examples
   ```

3. **You type**: "Let's add health metrics to the context builder"

4. **AI responds** with full understanding:
   - Knows project standards (Layer 1: always-on context)
   - Knows recent work (Layer 2: injected conversation history)
   - Knows current task (Layer 3: your message)

**Total tokens**: ~40-50K (vs 150K+ without this system)
**Savings**: 70-80% per chat

---

## Integration Architecture

```
C:\AI_Coding\00_SYSTEM\01_INFRASTRUCTURE\
├── 00_VECTOR_MGMT\               # Keep as-is (production)
│   ├── 40_RUNTIME\
│   │   ├── 00_CONTROL\           # Queue system
│   │   ├── 02_EXTRACT\           # state.vscdb → SQLite
│   │   ├── 03_VECTOR\            # SQLite → Qdrant
│   │   └── 04_SEARCH\            # REST API (port 8765)
│   └── [12,412+ chat records]
│
└── 01_CTXT_MGMT\                 # Keep as-is (production)
    ├── TIER-02\
    │   ├── query_vect_api.ps1    # Queries VECTOR_MGMT
    │   ├── t2_chat_time.ahk      # Cursor automation
    │   └── t2_proc_monitor.ps1   # Process detection
    └── [Auto-injection logic]

C:\DEV\                           # New addition
├── .cursor\rules\
│   ├── project-standards.mdc     # Static rules (enhanced)
│   └── context-hot.mdc           # Generated (docs index)
│
└── tools\context-builder\        # New system
    ├── build_context.py          # Index docs → generate rules
    ├── settings.yaml             # Config
    └── [Nightly refresh]
```

**Key insight**: These are **separate, complementary systems**:
- **VECTOR_MGMT**: Chat history search (state.vscdb)
- **Hot Context**: Project docs compression (.cursor/rules/)
- **CTXT_MGMT**: Glue layer (auto-inject from VECTOR_MGMT)

---

## What We Can Leverage from VECTOR_MGMT

### 1. Existing Qdrant + Ollama Infrastructure ✅

**VECTOR_MGMT already has:**
- Qdrant running (Docker)
- Ollama with nomic-embed-text model
- Production-tested configuration

**Hot Context Builder can:**
- Use the **same services** (different collection)
- No need to spin up separate instances
- Share embeddings infrastructure

**Action**: Update `tools/context-builder/settings.yaml`:
```yaml
qdrant_url: http://localhost:6333  # Same Qdrant instance
ollama_url: http://localhost:11434  # Same Ollama instance
collection: cursor_hot_context      # Different collection (no conflict)
```

### 2. Enhanced Parser Pattern ✅

**VECTOR_MGMT has:**
- Multi-position array checking (1-175)
- Multi-field extraction (5+ content fields)
- 98% recovery rate (39x improvement)

**Hot Context Builder could:**
- Apply same pattern to markdown parsing
- More robust content extraction
- Better handling of malformed docs

**Action**: Enhance `semantic_chunk_markdown()` with multi-field checking pattern

### 3. Queue-Based Processing Pattern ✅

**VECTOR_MGMT has:**
- Coordinator + Worker architecture
- Atomic job claiming
- Exponential backoff retries
- SQLite queue database

**Hot Context Builder could:**
- Use same pattern for async indexing
- Better reliability for large doc sets
- Proper retry on failures

**Action**: Port queue system from VECTOR_MGMT to handle doc indexing

### 4. REST API Pattern ✅

**VECTOR_MGMT has:**
- Flask API on port 8765
- `/health`, `/search`, `/conversation/{id}` endpoints
- Hybrid search implementation

**Hot Context Builder could:**
- Add similar API for doc search (port 8766?)
- Unified query interface
- Same monitoring/health patterns

**Action**: Optional - add API if you want programmatic access to doc search

### 5. Monitoring & Observability ✅

**VECTOR_MGMT has:**
- Real-time dashboard
- Queue stats
- Health checks
- Logging patterns

**Hot Context Builder could:**
- Same logging format
- Same health check patterns
- Unified monitoring dashboard

**Action**: Adopt VECTOR_MGMT's logging/monitoring standards

---

## Recommended Integration Steps

### Phase 1: Minimal Integration (Today, 30 minutes)

**Use existing VECTOR_MGMT infrastructure:**

```powershell
# 1. Verify VECTOR_MGMT is running
curl http://localhost:6333  # Qdrant
curl http://localhost:11434  # Ollama

# 2. Hot Context Builder will use same services
cd C:\DEV\tools\context-builder
python build_context.py health
# Should connect to existing Qdrant/Ollama

# 3. Create separate collection (no conflict)
python build_context.py index
# Creates "cursor_hot_context" collection
# VECTOR_MGMT uses different collection name

# 4. Generate context file
python build_context.py generate
# Creates .cursor/rules/context-hot.mdc
```

**Result**: Hot Context Builder using your existing infrastructure, zero new services.

### Phase 2: Add Doc Search to VECTOR_MGMT (Optional, 4-8 hours)

**Extend VECTOR_MGMT API to include doc search:**

```python
# Add to C:\AI_Coding\...\00_VECTOR_MGMT\40_RUNTIME\04_SEARCH\api.py

@app.route('/search/docs', methods=['GET'])
def search_docs():
    """Search project documentation (not chat history)."""
    query = request.args.get('q', '')
    k = int(request.args.get('k', 10))

    # Query "cursor_hot_context" collection
    results = qdrant.search(
        collection_name="cursor_hot_context",
        query_vector=get_embedding(query),
        limit=k
    )

    return jsonify([{
        'text': r.payload['text'],
        'source': r.payload['source'],
        'score': r.score
    } for r in results])
```

**Result**: Unified API for both chat history AND docs search.

### Phase 3: Unified Monitoring (Optional, 2-4 hours)

**Add Hot Context stats to VECTOR_MGMT dashboard:**

```python
# Add to dashboard
@app.route('/stats')
def stats():
    return {
        'chat_history': {
            'collection': 'main',
            'records': get_count('main'),
            'last_update': get_last_update('main')
        },
        'project_docs': {
            'collection': 'cursor_hot_context',
            'records': get_count('cursor_hot_context'),
            'last_update': get_last_update('cursor_hot_context')
        }
    }
```

**Result**: Single dashboard for all vector search systems.

### Phase 4: Port Queue System (Optional, 6-8 hours)

**Use VECTOR_MGMT's queue pattern for doc indexing:**

```powershell
# Copy queue system
cp -Recurse `
  C:\AI_Coding\...\00_VECTOR_MGMT\40_RUNTIME\00_CONTROL\00_CODE\00_CORE `
  C:\DEV\tools\context-builder\queue

# Adapt for doc indexing
# - coordinator.py: Schedule doc indexing jobs
# - worker.py: Process indexing jobs
# - queue_db.py: Job queue for doc updates
```

**Result**: Production-grade async doc indexing with retries.

---

## Comparison: What Each System Does

| Feature | VECTOR_MGMT | Hot Context Builder | CTXT_MGMT |
|---------|-------------|---------------------|-----------|
| **Data source** | Cursor chat history | Project documentation | VECTOR_MGMT API |
| **Index target** | state.vscdb (16K+ bubbles) | docs/, READMEs, ADRs | N/A |
| **Storage** | Qdrant collection | Qdrant collection (separate) | N/A |
| **Output** | REST API responses | .cursor/rules/context-hot.mdc | Injected text |
| **Refresh** | Continuous (queue) | Nightly + on-commit | Per-chat |
| **Cursor integration** | Via CTXT_MGMT | Direct (auto-read) | Auto-inject |
| **Token cost** | 0 (just indexed) | 0 (Cursor reads) | ~20-30K (injected) |
| **Use case** | "What was I doing?" | "What are standards?" | Automation glue |

**They complement each other:**
- **VECTOR_MGMT**: Historical context (conversations)
- **Hot Context**: Current context (standards/architecture)
- **CTXT_MGMT**: Delivery mechanism (auto-injection)

---

## Benefits of This Approach

### 1. Leverage Existing Investment ✅
- VECTOR_MGMT: Months of work, production-proven
- Hot Context: Research-backed additions
- No redundant infrastructure

### 2. Separate Concerns ✅
- Chat history indexing (VECTOR_MGMT) separate from doc indexing (Hot Context)
- Different refresh rates (continuous vs nightly)
- Different use cases (historical vs current)

### 3. Unified Infrastructure ✅
- Same Qdrant instance
- Same Ollama instance
- Same embedding model
- Separate collections (no conflicts)

### 4. Complete Context Coverage ✅
- **Always-on**: Project standards (Hot Context → Cursor rules)
- **Dynamic**: Past conversations (VECTOR_MGMT → CTXT_MGMT)
- **Current**: Your task (your input)

### 5. Maximum Token Savings ✅
- Hot Context: 0 tokens (Cursor reads automatically)
- VECTOR_MGMT: 20-30K tokens (vs 150K manual)
- Combined: 80-90% savings

---

## Implementation Timeline

### Today (1 hour)
- ✅ Hot Context Builder uses existing Qdrant/Ollama
- ✅ Create "cursor_hot_context" collection
- ✅ Generate first `.cursor/rules/context-hot.mdc`
- ✅ Test in Cursor

### This Week (4-8 hours)
- Enhance Hot Context chunking with VECTOR_MGMT parser patterns
- Add doc search endpoint to VECTOR_MGMT API
- Unified health checks

### This Month (20-30 hours)
- Port queue system for async doc indexing
- Unified monitoring dashboard
- Full integration testing
- Documentation updates

---

## Decision

**Recommended Approach**: Minimal Integration (Phase 1)

**Rationale:**
- Leverage existing VECTOR_MGMT infrastructure ✅
- Hot Context Builder as complementary (not replacement) ✅
- Separate collections (no conflicts) ✅
- Immediate benefits (today) ✅
- Optional enhancements later (Phases 2-4) ✅

**Next Action**: Run `python build_context.py health` to verify it connects to your existing services.

---

## Summary

You have **two powerful systems** that work together:

1. **VECTOR_MGMT** (existing): Searches 12K+ past conversations
2. **Hot Context Builder** (new): Compresses project docs into Cursor rules

Both use the same infrastructure (Qdrant + Ollama), different collections, different use cases.

**Combined result:**
- Cursor always knows project standards (Layer 1: auto-read)
- New chats auto-inject relevant history (Layer 2: CTXT_MGMT)
- 80-90% token savings = $25K-28K/year

**No need to rebuild anything** - just add Hot Context Builder to complement your existing production systems.

---

**Status**: Ready to integrate
**Risk**: Low (uses existing infrastructure, separate collections)
**Effort**: 1 hour (minimal) to 30 hours (full integration)
**ROI**: Additive to existing $25K/year savings
