# Sourcegraph Quick Start Guide

## First Time Setup (5 Minutes)

### Step 1: Create Admin Account

1. Open http://localhost:7080
2. You'll see a signup page
3. Create your account (first user becomes admin)
   - Username: (your choice)
   - Email: (any email, doesn't need to be real)
   - Password: (your choice)

### Step 2: Add Your Code Repositories

Two options:

#### Option A: Add Local Repos (Recommended for C:\DEV)

1. Click **"Add repositories"** or go to **Site admin** → **Repositories**
2. Click **"Add repositories"**
3. Choose **"Single Git repository"**
4. Add each repo you want to search:
   ```
   Name: backstage
   Clone URL: file:///C:/DEV/backstage/.git

   Name: services-status-api
   Clone URL: file:///C:/DEV/services/status-api/.git

   Name: templates-node
   Clone URL: file:///C:/DEV/templates/starter-node-service/.git
   ```

**Note:** For local file paths, you need Git repos initialized. If not Git repos, skip to Option B.

#### Option B: Add GitHub/GitLab Repos

1. Go to **Site admin** → **Manage code hosts**
2. Click **"Add code host"**
3. Choose **GitHub** or **GitLab**
4. Enter your access token
5. Select repos to sync

#### Option C: Skip for Now

You can test with public repos first:
- Sourcegraph will suggest popular repos
- Search across open source projects

### Step 3: Wait for Indexing (2-5 minutes)

- Go to **Site admin** → **Repositories**
- Watch status change from "Cloning" → "Indexed"
- This is automatic

## What Can You Do?

### 1. Search Code Across All Repos

**Search bar at top:**

```
Basic search:
  function handleRequest

Case-sensitive:
  case:yes ValidationError

Regex:
  handleError.*timeout

File type:
  lang:typescript handleRequest

Specific file:
  file:server.js

Exclude:
  handleRequest -file:test

Multiple conditions:
  lang:python class.*Database file:models/
```

**Examples for your C:\DEV setup:**
```
Find all TODO comments:
  TODO lang:typescript

Find API endpoints:
  @app.route lang:python

Find Docker configs:
  FROM file:Dockerfile

Find security issues:
  password OR secret lang:javascript
```

### 2. Code Navigation (The Killer Feature)

Once code is indexed:

- **Click any function/class** → Goes to definition
- **Right-click symbol** → Find references
- **Hover over code** → See documentation
- **Follow imports** → Jump between files

**Try this:**
1. Search for a function in your code
2. Click on it
3. Right-click → "Find references"
4. See everywhere it's used across ALL your repos!

### 3. Symbol Search

Find functions/classes directly:

```
Find a class:
  type:symbol DatabaseConnection

Find a function:
  type:symbol handleRequest

Find in specific repo:
  repo:backstage type:symbol Component
```

### 4. Browse Repositories

**Left sidebar:**
- Click any repo
- Browse files like GitHub
- Navigate folder structure
- View file history

### 5. Search Across Repos

```
Find all Express servers:
  repo:services/ express

Find Docker setups:
  file:docker-compose.yaml

Find Python APIs:
  repo:services/ lang:python fastapi

Find React components:
  repo:backstage/ lang:typescript React.FC
```

## Real-World Use Cases for Your C:\DEV

### Use Case 1: Find Where Something Is Used

**Problem:** "Where do I use this function?"

```
1. Search: myFunction
2. Click result
3. Right-click → "Find references"
4. See all usages across all repos
```

### Use Case 2: Find Similar Code

**Problem:** "How did I handle errors in other services?"

```
Search: try.*except lang:python repo:services/
or
Search: try.*catch lang:typescript repo:templates/
```

### Use Case 3: Audit Security

**Problem:** "Do I have any hardcoded secrets?"

```
Search: password|secret|api_key|token
Filter: -file:test -file:.env.example
```

### Use Case 4: Find Configuration

**Problem:** "Which services use Postgres?"

```
Search: postgres OR postgresql
Filter: file:docker-compose OR file:requirements.txt
```

### Use Case 5: Understand New Codebase

**Problem:** "I inherited a project, where do I start?"

```
1. Search for main entry point:
   file:main.py OR file:index.ts OR file:server.js

2. Find core models:
   type:symbol class.*Model lang:python

3. Find API routes:
   @app.route OR router.get OR app.post
```

## Advanced Features

### Search Filters

| Filter | Example | What It Does |
|--------|---------|--------------|
| `repo:` | `repo:backstage` | Search specific repo |
| `file:` | `file:package.json` | Search specific files |
| `lang:` | `lang:python` | Filter by language |
| `type:symbol` | `type:symbol UserModel` | Find definitions |
| `case:yes` | `case:yes UserId` | Case-sensitive |
| `-` | `-file:test` | Exclude pattern |

### Regex Patterns

```
Find all exports:
  export (const|function|class)

Find error handling:
  (try|catch|except|raise|throw)

Find database queries:
  (SELECT|INSERT|UPDATE|DELETE).*FROM

Find API endpoints:
  \/(api|v1|v2)\/[a-z]+
```

### Saved Searches

1. Run a search you'll use often
2. Click **"Save search"**
3. Name it (e.g., "All TODOs")
4. Access from sidebar anytime

### Code Monitoring (If Enabled)

Set up alerts for code changes:
- New TODOs added
- Security patterns detected
- Deprecated code usage

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `/` | Focus search bar |
| `t` | Go to file (in repo view) |
| `?` | Show all shortcuts |
| `Ctrl+K` | Quick open |

## Tips & Tricks

### Tip 1: Use Repo Filters for Focus

```
Instead of:
  handleRequest

Do this:
  repo:services/ handleRequest
```

### Tip 2: Combine Multiple Filters

```
Find API routes in TypeScript services:
  repo:services/ lang:typescript router.get|router.post
```

### Tip 3: Use Symbol Search for Definitions

```
Instead of text search:
  class DatabaseConnection

Use symbol search:
  type:symbol DatabaseConnection
```

### Tip 4: Find Examples in Your Own Code

```
Need to remember how to use a library?

  repo:^services/ import.*express
  repo:^backstage/ import.*react
```

### Tip 5: Search Commit Messages (If Git Integration Set Up)

```
Search for why code changed:
  type:commit fix bug
  type:commit add feature
```

## Integration with Your Workflow

### VS Code Integration (Optional)

Install Sourcegraph extension:
1. Open VS Code
2. Extensions → Search "Sourcegraph"
3. Connect to http://localhost:7080
4. Search without leaving editor

### Browser Extension (Optional)

Add to Chrome/Firefox:
- Adds "Open in Sourcegraph" to GitHub
- Code navigation on GitHub PRs
- Search from any page

### Command Line (Optional)

Install `src` CLI:
```powershell
npm install -g @sourcegraph/src

# Configure
src login http://localhost:7080

# Search from terminal
src search 'repo:services/ lang:python'
```

## What NOT to Do

❌ **Don't add non-Git directories** - Won't work
❌ **Don't expect instant indexing** - Takes 2-5 min first time
❌ **Don't search before indexing completes** - Results will be incomplete
❌ **Don't add your entire C:\ drive** - Be selective with repos

## Troubleshooting

### No Search Results?

1. Check if repos are indexed: **Site admin** → **Repositories**
2. Wait for status to show "Indexed"
3. Try a simpler search first

### Can't Add Local Repos?

- Make sure they're Git repositories
- Use `file:///` prefix for Windows paths
- Or use GitHub/GitLab integration instead

### Search Is Slow?

- First searches are always slower (warming up)
- Be more specific with filters
- Use `repo:` to limit scope

## Next Steps

### Start Simple

1. ✅ Create account
2. ✅ Add 1-2 repos
3. ✅ Wait for indexing
4. ✅ Try basic search: `TODO`
5. ✅ Click a result, explore navigation

### Then Level Up

- Add more repos
- Use advanced filters
- Set up saved searches
- Try code monitoring
- Install browser extension

### Pro Tips

**Build a search library for C:\DEV:**

```
All TODOs:
  TODO repo:^github\.com/yourorg/

Security audit:
  password|secret|token -file:test

Find API endpoints:
  repo:services/ @app.route|router.get

Database queries:
  repo:services/ SELECT.*FROM|INSERT.*INTO

Error handling:
  repo:services/ try.*catch|try.*except
```

Save these and run them weekly!

## Resources

- **Official Docs:** https://docs.sourcegraph.com
- **Search Syntax:** https://docs.sourcegraph.com/code_search/reference/queries
- **Examples:** https://docs.sourcegraph.com/code_search/tutorials

## Quick Reference Card

```
BASIC SEARCH
  handleRequest              Find text
  lang:typescript           Filter by language
  file:server.js            Specific file
  repo:backstage/           Specific repo

ADVANCED SEARCH
  case:yes UserId           Case-sensitive
  regex.*pattern            Regular expression
  type:symbol ClassName     Find definitions
  -file:test                Exclude files

NAVIGATION
  Click symbol              → Go to definition
  Right-click               → Find references
  Hover                     → Documentation

SHORTCUTS
  /                         Focus search
  ?                         Show shortcuts
  Ctrl+K                    Quick open
```

---

**Ready to start? Open http://localhost:7080 and create your account!**

The first search is always the hardest. Try searching for `TODO` and see what you find across your codebase. 🚀
