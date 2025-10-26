# Git Command Reference

Quick reference for common Git commands.

---

## Basic Operations

```bash
# Initialize repo
git init

# Clone repo
git clone <url>

# Check status
git status

# Add files
git add .
git add <file>

# Commit
git commit -m "feat: description"
git commit -am "fix: description"  # Add + commit modified files

# Push
git push
git push -u origin main  # First push, set upstream
```

---

## Branching

```bash
# List branches
git branch
git branch -a  # Include remote branches

# Create branch
git branch feature-name

# Switch branch
git checkout feature-name
git switch feature-name  # Newer syntax

# Create and switch
git checkout -b feature-name
git switch -c feature-name

# Delete branch
git branch -d feature-name  # Safe delete (must be merged)
git branch -D feature-name  # Force delete

# Rename branch
git branch -m new-name
```

---

## Undoing Changes

```bash
# Discard local changes to file
git checkout -- <file>
git restore <file>

# Unstage file
git reset HEAD <file>
git restore --staged <file>

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Revert a commit (creates new commit)
git revert <commit-hash>
```

---

## Viewing History

```bash
# View log
git log
git log --oneline
git log --graph --oneline --all

# View changes
git diff
git diff <file>
git diff --staged

# Show commit
git show <commit-hash>
```

---

## Remote Operations

```bash
# View remotes
git remote -v

# Add remote
git remote add origin <url>

# Fetch changes
git fetch

# Pull changes
git pull
git pull origin main

# Push branch
git push origin branch-name
```

---

## Stashing

```bash
# Stash changes
git stash
git stash save "description"

# List stashes
git stash list

# Apply stash
git stash apply
git stash apply stash@{0}

# Apply and remove
git stash pop

# Drop stash
git stash drop stash@{0}
```

---

## Merging

```bash
# Merge branch into current
git merge feature-branch

# Abort merge
git merge --abort

# Merge with no fast-forward
git merge --no-ff feature-branch
```

---

## Tagging

```bash
# List tags
git tag

# Create tag
git tag v1.0.0
git tag -a v1.0.0 -m "Version 1.0.0"

# Push tags
git push --tags

# Delete tag
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0  # Delete remote
```

---

## Configuration

```bash
# Set user info
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# View config
git config --list
git config user.name

# Set default editor
git config --global core.editor "code --wait"

# Line endings (Windows)
git config --global core.autocrlf true
```

---

## Conventional Commits

```bash
# Format: <type>(<scope>): <description>

feat: add user authentication
fix: resolve null pointer in payment
docs: update API documentation
style: format code with prettier
refactor: simplify error handling
test: add unit tests for orders
chore: upgrade dependencies
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation only
- `style` - Code style (formatting, no logic change)
- `refactor` - Code refactoring
- `test` - Adding tests
- `chore` - Maintenance tasks

---

## Useful Aliases

Add to `~/.gitconfig`:

```ini
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = log --graph --oneline --all
    amend = commit --amend --no-edit
```

Usage: `git st`, `git co main`, etc.


