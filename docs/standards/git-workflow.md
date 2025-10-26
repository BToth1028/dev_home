# Git Workflow Standard

My git workflow and conventions.

---

## Branch Strategy

### Main Branches
- `main` - Production-ready code
- `develop` (optional) - Integration branch for features

### Working Branches
- `feature/<name>` - New features
- `fix/<name>` - Bug fixes
- `chore/<name>` - Maintenance, dependencies, tooling
- `docs/<name>` - Documentation only

**Examples:**
- `feature/user-authentication`
- `fix/payment-null-pointer`
- `chore/upgrade-dependencies`
- `docs/api-endpoints`

---

## Commit Message Format

**Use Conventional Commits:**

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `style` - Formatting (no logic change)
- `refactor` - Code refactoring
- `test` - Adding tests
- `chore` - Maintenance
- `perf` - Performance improvement
- `ci` - CI/CD changes
- `build` - Build system changes

### Examples

```bash
feat: add user registration endpoint
feat(auth): implement JWT authentication
fix: resolve database connection timeout
fix(api): handle null values in user query
docs: update API documentation
docs(readme): add setup instructions
chore: upgrade dependencies
chore(deps): bump postgres from 15 to 16
refactor: simplify error handling
test: add unit tests for user service
```

### Scope (Optional)
Module, component, or area affected:
- `auth`, `api`, `db`, `ui`, `docs`, `deps`

---

## Workflow

### Starting New Work

```bash
# 1. Update main
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/my-feature

# 3. Work and commit frequently
git add .
git commit -m "feat: add initial structure"
git commit -m "feat: implement core logic"
git commit -m "test: add unit tests"

# 4. Push to remote
git push -u origin feature/my-feature
```

### Before Merging

```bash
# 1. Ensure tests pass
npm test  # or pytest

# 2. Ensure linting passes
npm run lint  # or pre-commit run -a

# 3. Update from main
git checkout main
git pull origin main
git checkout feature/my-feature
git merge main  # or rebase

# 4. Push final changes
git push
```

### Merging

```bash
# Option A: Merge via PR/GitHub
# (Preferred - allows code review)

# Option B: Local merge
git checkout main
git merge feature/my-feature
git push origin main

# Clean up
git branch -d feature/my-feature
git push origin --delete feature/my-feature
```

---

## Do's and Don'ts

### DO:
- ✅ Commit frequently with meaningful messages
- ✅ Write descriptive commit messages
- ✅ Keep commits focused (one logical change per commit)
- ✅ Test before pushing
- ✅ Pull before starting new work
- ✅ Use branches for all work (don't commit directly to main)

### DON'T:
- ❌ Commit broken code
- ❌ Use vague messages ("fix stuff", "update")
- ❌ Commit commented-out code
- ❌ Commit sensitive data (.env files, secrets, API keys)
- ❌ Force push to shared branches
- ❌ Commit large binary files (unless necessary)

---

## PR/Code Review Guidelines

### Creating a PR
1. Write clear title using conventional commit format
2. Describe what changed and why
3. Link related issues
4. Add screenshots (if UI change)
5. Ensure CI passes

### PR Description Template

```markdown
## What
Brief description of changes

## Why
Reason for this change (user story, bug report)

## How to Test
1. Step 1
2. Step 2
3. Expected result

## Screenshots (if applicable)

## Checklist
- [ ] Tests pass
- [ ] Linter passes
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

---

## Emergency Fixes (Hotfix)

```bash
# 1. Branch from main
git checkout main
git pull origin main
git checkout -b fix/critical-bug

# 2. Fix and test
# (make minimal changes)

# 3. Commit and push
git commit -m "fix: resolve critical payment bug"
git push -u origin fix/critical-bug

# 4. Immediate PR to main
# 5. After merge, backport to develop if using GitFlow
```

---

## Tags/Releases

```bash
# Create release tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# List tags
git tag

# Delete tag (if mistake)
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0
```

**Versioning:**
- `v1.0.0` - Major.Minor.Patch (Semantic Versioning)
- `v1.0.0-beta.1` - Pre-release

---

## .gitignore Best Practices

**Always ignore:**
```
# Dependencies
node_modules/
.venv/
vendor/

# Environment
.env
.env.local
.env.*.local

# Build
dist/
build/
*.pyc
__pycache__/

# IDE
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/
```

---

## Useful Git Config

```bash
# Set user info
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Default branch name
git config --global init.defaultBranch main

# Line endings (Windows)
git config --global core.autocrlf true

# Pull strategy
git config --global pull.rebase false

# Default editor
git config --global core.editor "code --wait"
```

---

**Last Updated:** 2025-10-26


