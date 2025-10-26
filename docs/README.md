# Development Documentation & Knowledge Base

**Purpose:** Permanent storage for development knowledge, research, and cross-project documentation.

---

## 📁 Directory Structure

```
docs/
├── reference/          # Quick reference guides, cheat sheets
├── research/           # Deep dives, comparisons, investigations
├── gpt-summaries/      # AI-generated summaries and insights
├── standards/          # Team coding standards and conventions
├── architecture/       # System architecture and cross-project ADRs
└── meetings/           # Meeting notes and decision logs
```

---

## 📂 Folder Purposes

### `reference/`
Quick reference materials you look up frequently:
- Command cheat sheets (git, docker, sql)
- API quick references
- Configuration templates
- Troubleshooting guides

**Example files:**
- `git-commands.md`
- `docker-compose-patterns.md`
- `postgres-queries.md`
- `curl-examples.md`

---

### `research/`
Deep research and comparisons, organized by topic:
- Technology evaluations
- Best practices research
- Performance comparisons
- Tool evaluations

**Organized by topic:**
- `cursor-best-practices/`
- `api-frameworks/`
- `database-comparison/`
- `template-architecture/`

**File naming:** `YYYY-MM-DD_descriptive-title.md`

**Example:**
- `research/cursor-best-practices/2025-10-26_comprehensive-filesystem-guide.md`
- `research/api-frameworks/2025-10-15_fastapi-vs-flask.md`

---

### `gpt-summaries/`
Outputs from ChatGPT, Claude, Cursor, or other AI tools.

**Organized by category:**
- `architecture/` - System design, patterns
- `coding-patterns/` - Code organization, best practices
- `devops/` - Deployment, CI/CD, infrastructure
- `_inbox/` - Temporary holding area (sort later)

**When to use:**
- Saving AI-generated explanations
- Research summaries from AI tools
- Code reviews and suggestions
- Architecture recommendations

---

### `standards/`
Team/personal coding standards and conventions:
- Coding style guides
- Git workflow
- PR templates
- Security checklists
- Review guidelines

**These are prescriptive:** This is how WE do things.

**Example files:**
- `coding-style-guide.md`
- `git-workflow.md`
- `pr-checklist.md`
- `security-review.md`

---

### `architecture/`
Cross-project architecture documentation:

**`diagrams/`** - Visual representations:
- System architecture diagrams
- Data flow diagrams
- Network topology
- Deployment diagrams

**`decisions/`** - Architecture Decision Records (ADRs):
- Cross-cutting decisions (e.g., "All projects use PostgreSQL")
- Technology choices that affect multiple projects
- Architectural patterns adopted organization-wide

**Note:** Project-specific ADRs go in the project repo, not here.

---

### `meetings/`
Meeting notes, brainstorming sessions, decision logs.

**Organized by month:** `YYYY-MM/YYYY-MM-DD_meeting-topic.md`

**Example:**
- `2025-10/2025-10-26_architecture-review.md`
- `2025-10/2025-10-15_api-design-brainstorm.md`

---

## 📝 File Naming Convention

**Format:** `YYYY-MM-DD_descriptive-title.md`

**Why this format?**
- ✅ Sorts chronologically
- ✅ Easy to search
- ✅ Self-documenting
- ✅ Works across all OS

**Examples:**
- ✅ `2025-10-26_cursor-filesystem-best-practices.md`
- ✅ `2025-10-27_postgres-connection-pooling.md`
- ✅ `2025-11-01_microservices-pattern-comparison.md`
- ❌ `doc1.md`
- ❌ `notes.txt`
- ❌ `Untitled-Document.md`

---

## 🚀 Quick Start

### Saving a GPT Summary
```bash
# Copy the summary to your clipboard, then:
notepad C:\dev\docs\gpt-summaries\_inbox\2025-10-26_topic-name.md
# Paste and save

# Later, organize it:
move C:\dev\docs\gpt-summaries\_inbox\2025-10-26_topic-name.md C:\dev\docs\gpt-summaries\architecture\
```

### Adding Research
```bash
# Create a new research document
notepad C:\dev\docs\research\cursor-best-practices\2025-10-26_new-finding.md
```

### Creating a Reference
```bash
# Create a quick reference
notepad C:\dev\docs\reference\git-commands.md
```

---

## 🔍 Searching Your Knowledge Base

**PowerShell:**
```powershell
# Search all docs for a term
Get-ChildItem C:\dev\docs -Recurse -Filter *.md | Select-String "postgres"

# Search specific folder
Get-ChildItem C:\dev\docs\research -Recurse -Filter *.md | Select-String "cursor"
```

**VS Code / Cursor:**
```bash
# Open entire docs folder
cursor C:\dev\docs

# Use Ctrl+Shift+F to search across all files
```

---

## 🎯 Best Practices

### DO:
- ✅ Use descriptive filenames with dates
- ✅ Add context at top of each document (date, source, purpose)
- ✅ Link related documents together
- ✅ Update existing docs rather than creating duplicates
- ✅ Organize by topic in research/gpt-summaries

### DON'T:
- ❌ Put project-specific docs here (those go in project repos)
- ❌ Store code files here (use libs/ or apps/)
- ❌ Let _inbox grow indefinitely (organize weekly)
- ❌ Use vague names like "notes.md" or "doc1.md"

---

## 🔄 Maintenance

**Weekly:**
- Sort files from `gpt-summaries/_inbox/` into proper categories
- Review and consolidate duplicate information

**Monthly:**
- Archive old meeting notes
- Update outdated reference materials
- Review and merge related research docs

---

## 💾 Backup (Optional)

**Initialize Git:**
```bash
cd C:\dev\docs
git init
git add .
git commit -m "docs: initialize knowledge base"
git remote add origin https://github.com/yourname/dev-docs
git push -u origin main
```

**Alternative:** Use OneDrive, Dropbox, or sync to a private GitHub repo.

---

## 📚 Related Resources

- Project templates: `C:\dev\templates\`
- Active projects: `C:\dev\apps\`
- Shared libraries: `C:\dev\libs\`
- Infrastructure code: `C:\dev\infra\`

---

**Created:** 2025-10-26
**Last Updated:** 2025-10-26
**Maintained By:** You!


