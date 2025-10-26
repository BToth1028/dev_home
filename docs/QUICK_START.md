# Quick Start Guide

## 📁 Your Documentation Structure is Ready!

```
C:\dev\docs\
├── reference/           ← Quick lookups (git, docker commands)
├── research/            ← Deep dives organized by topic
├── gpt-summaries/       ← AI outputs (sorted by category)
├── standards/           ← Your coding conventions
├── architecture/        ← Cross-project architecture
├── meetings/            ← Meeting notes
└── README.md            ← Full documentation (you're here!)
```

---

## 🚀 Common Tasks

### Save a GPT/AI Summary

**Quick method:**
```bash
# 1. Copy AI response to clipboard
# 2. Create file with date
notepad C:\dev\docs\gpt-summaries\_inbox\2025-10-26_topic-name.md
# 3. Paste, save, done!

# Later, organize it:
move C:\dev\docs\gpt-summaries\_inbox\2025-10-26_topic-name.md C:\dev\docs\gpt-summaries\architecture\
```

**Using template:**
```bash
# Copy the template
copy C:\dev\docs\gpt-summaries\_TEMPLATE.md C:\dev\docs\gpt-summaries\_inbox\2025-10-26_my-research.md

# Edit and fill in
notepad C:\dev\docs\gpt-summaries\_inbox\2025-10-26_my-research.md
```

---

### Add Research Notes

```bash
# Create in appropriate topic folder
notepad C:\dev\docs\research\cursor-best-practices\2025-10-26_new-finding.md
```

---

### Quick Reference Lookup

```bash
# Open reference docs
cursor C:\dev\docs\reference\

# Or specific file
notepad C:\dev\docs\reference\git-commands.md
```

---

### Document a Meeting

```bash
# Create monthly folder if needed
mkdir C:\dev\docs\meetings\2025-10

# Create meeting note
notepad C:\dev\docs\meetings\2025-10\2025-10-26_topic.md
```

---

## 🔍 Search Your Docs

**PowerShell:**
```powershell
# Search all docs
Get-ChildItem C:\dev\docs -Recurse -Filter *.md | Select-String "search term"

# Search specific folder
Get-ChildItem C:\dev\docs\research -Recurse -Filter *.md | Select-String "cursor"
```

**Cursor/VS Code:**
```bash
cursor C:\dev\docs
# Use Ctrl+Shift+F to search
```

---

## 📝 File Naming

**Always use:** `YYYY-MM-DD_descriptive-title.md`

**Examples:**
- ✅ `2025-10-26_cursor-optimization-tips.md`
- ✅ `2025-10-27_postgres-connection-pooling.md`
- ❌ `notes.md`
- ❌ `doc1.md`

---

## 🔄 Weekly Maintenance

```powershell
# 1. Sort inbox
cd C:\dev\docs\gpt-summaries\_inbox
# Move files to proper categories

# 2. Review recent additions
Get-ChildItem C:\dev\docs -Recurse -Filter *.md | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-7)} | Select-Object FullName, LastWriteTime
```

---

## 📚 Pre-loaded Content

Your docs already include:

**Reference:**
- `git-commands.md` - Git cheat sheet
- `docker-commands.md` - Docker & Compose reference

**Standards:**
- `git-workflow.md` - Your git conventions

**Templates:**
- `gpt-summaries/_TEMPLATE.md` - Template for AI summaries

**READMEs:**
- Every folder has a README explaining its purpose

---

## 🎯 Next Steps

1. **Save today's work:**
   ```bash
   # Save the comprehensive filesystem guide GPT gave you
   notepad C:\dev\docs\research\cursor-best-practices\2025-10-26_comprehensive-filesystem-guide.md
   ```

2. **Start using it:**
   - Whenever you get useful AI output → Save to `gpt-summaries/_inbox/`
   - Whenever you research something → Document in `research/<topic>/`
   - Whenever you decide on a standard → Document in `standards/`

3. **Keep it organized:**
   - Review `_inbox/` weekly
   - Link related documents together
   - Update READMEs as needed

---

## 💡 Pro Tips

- **Use Cursor to search:** Open entire docs folder, use Cmd/Ctrl+Shift+F
- **Link between docs:** Use relative paths `[See also](../research/topic.md)`
- **Add tags:** Use `#tags` at bottom of files for easier searching
- **Version control (optional):**
  ```bash
  cd C:\dev\docs
  git init
  git add .
  git commit -m "docs: initialize knowledge base"
  ```

---

## 📊 Structure Overview

| Folder | Purpose | When to Use |
|--------|---------|-------------|
| `reference/` | Quick lookups | "I need to remember that git command..." |
| `research/` | Deep dives | "I'm researching Cursor best practices" |
| `gpt-summaries/` | AI outputs | "GPT just gave me great advice on X" |
| `standards/` | Your rules | "This is how I do git commits" |
| `architecture/` | System design | "All projects use PostgreSQL" |
| `meetings/` | Session notes | "Today's architecture discussion" |

---

**Everything is ready to use! Start saving your knowledge. 🎉**

Open the main README for full details:
```bash
notepad C:\dev\docs\README.md
```
