# GPT/AI Summaries

Outputs from ChatGPT, Claude, Cursor, or other AI tools.

## Structure

```
gpt-summaries/
├── architecture/        # System design, patterns
├── coding-patterns/     # Code organization, best practices
├── devops/              # Deployment, CI/CD, infrastructure
└── _inbox/              # Temporary holding (sort later)
```

## Workflow

1. **Save immediately** to `_inbox/` when you get a useful AI response
2. **Add metadata** at top (date, source, prompt used)
3. **Move to category** within a week
4. **Link related docs** if multiple AI conversations on same topic

## File Template

```markdown
# [Topic Title]

**Date:** 2025-10-26
**Source:** ChatGPT / Claude / Cursor
**Context:** What prompted this research

## Original Prompt
[The question or task you gave the AI]

## Summary
[Key takeaways]

## Full Response
[Complete AI output]

## Related
- [Link to other relevant docs]
```

## File Naming

**Format:** `YYYY-MM-DD_topic-description.md`

**Examples:**
- `2025-10-26_cursor-filesystem-best-practices.md`
- `2025-10-27_postgres-indexing-strategies.md`
