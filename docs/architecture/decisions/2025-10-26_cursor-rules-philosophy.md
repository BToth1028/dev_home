# ADR: Cursor Rules & Context Management Philosophy

**Date**: October 26, 2025
**Status**: Active
**Decision Maker**: RToth

---

## Context

During implementation of the "Hot Context Vector" system for Cursor, a philosophical question arose:

**Should we implement the "simplest solution first" or "production-grade, long-term solution"?**

---

## Decision

**Build production-grade, long-term solutions from the start.**

### Rationale

1. **Avoid Technical Debt**
   - Simple/minimal implementations require rebuilding later
   - Refactoring costs more than building it right initially
   - Time spent on throwaway code is wasted time

2. **Research-Backed Approach**
   - Industry best practices exist for a reason
   - Qdrant, NVIDIA, Databricks, Weaviate publish validated patterns
   - Use proven approaches, not experiments

3. **Long-Term Thinking**
   - Systems built to last reduce maintenance burden
   - Future-proof architecture scales better
   - Production-grade patterns are reusable

4. **User Preference**
   - Explicit request: "I want things that are going to last"
   - Willingness to invest time upfront
   - Focus on quality over speed

---

## Implementation Guidelines

### For AI Assistants

**DO:**
- ✅ Implement production-grade solutions with research-backed patterns
- ✅ Include proper error handling, logging, monitoring
- ✅ Add comprehensive documentation
- ✅ Think long-term: "Will this need to be rebuilt?"
- ✅ Use industry best practices (structure-aware chunking, reranking, etc.)

**DON'T:**
- ❌ Suggest "minimal MVP" unless explicitly requested
- ❌ Cut corners on error handling "for simplicity"
- ❌ Skip features that will be needed later
- ❌ Use "quick and dirty" approaches

### For Code Reviews

**Questions to Ask:**
- Will this need to be rewritten in 6 months?
- Are we following industry best practices?
- Is error handling comprehensive?
- Is it observable/debuggable?
- Will it scale?

If answer is "no" → Rebuild it properly now.

---

## Examples

### ✅ Production-Grade (Preferred)

**Cursor Hot Context Builder:**
- Structure-aware semantic chunking (not fixed-size)
- Hybrid search with reranking
- Comprehensive error handling
- Health checks, monitoring
- Configurable via `settings.yaml`
- Full automation (nightly + pre-commit)
- Documentation with troubleshooting

**Why:** Will last years, handles edge cases, production-ready.

### ❌ Minimal/Quick (Avoid)

**Simple chunker:**
```python
def chunks(txt, n=1000):
    for i in range(0, len(txt), n):
        yield txt[i:i+n]
```

**Why:** Works but:
- Breaks mid-sentence/code block
- No semantic awareness
- Will need rewriting when quality issues emerge
- Throwaway code

---

## Trade-offs Accepted

### More Upfront Time
- **Cost**: 40-60 hours for production version vs. 4-8 hours for minimal
- **Benefit**: Never needs rebuilding, scales, maintainable

### More Complexity
- **Cost**: More moving parts (reranking, health checks, config)
- **Benefit**: Observable, debuggable, handles failures gracefully

### Steeper Learning Curve
- **Cost**: More to understand initially
- **Benefit**: Based on industry patterns (transferable knowledge)

---

## Related Decisions

- **Cursor Context Best Practices**: Full research-backed implementation chosen
- **VECTOR_MGMT Integration**: Production system (not prototype) being integrated
- **Queue-Based Jobs**: Robust pattern preferred over simple cron

---

## Review & Updates

This philosophy may evolve, but default stance is:

**Build it right the first time. Production-grade is the standard.**

---

## Note on Cursor Rules

The Cursor IDE-level rule "Suggest the simplest solution first" should be understood as:
- Simplest **production-grade** solution
- NOT "minimal viable" or "quick and dirty"
- Focus on clarity, not cutting corners

This ADR clarifies that interpretation.

---

**Approved By**: RToth
**Date**: October 26, 2025
