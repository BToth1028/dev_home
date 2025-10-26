# Setup Engineering Home Repository

**Date:** 2025-10-26
**Source:** ChatGPT
**Context:** Asked how to create a new main "home" repo to anchor a polyrepo workspace, integrate Cursor rules, templates, and Sandboxie kit.

---

## Original Prompt

> "I want you to help me setup this Git repo... create a main 'home' repo that anchors your whole polyrepo setup"

---

## Key Takeaways

- Use a public "home" repo for standards, docs, templates, and infra; keep each app/library as its own repo
- Keep secrets out; only commit `.env.example` and public-safe assets
- Include Cursor rules and decision-note template so every project stays consistent
- Provide templates so new services are copy-start, not greenfield chaos
- Optional: multi-root workspace file for Cursor to open the home + active app repos together

---

## Implementation Guide

### 1. Repository Structure

```
C:\dev\                  (engineering-home repo)
├── .cursor/
│   └── rules/
│       └── write-notes.mdc
├── docs/
│   ├── architecture/
│   │   ├── decisions/
│   │   └── diagrams/
│   ├── gpt-summaries/
│   ├── reference/
│   ├── research/
│   ├── standards/
│   └── meetings/
├── templates/
│   ├── starter-python-api/
│   └── starter-node-service/
├── infra/
│   └── sandboxie/
├── README.md
└── .gitignore
```

### 2. Bootstrap a New Service

**From Python template:**
```powershell
Copy-Item -Recurse -Force C:\dev\templates\starter-python-api C:\dev\apps\user-service
cd C:\dev\apps\user-service
git init
git add .
git commit -m "feat: bootstrap user-service from template"
git remote add origin https://github.com/<you>/user-service.git
git push -u origin main
```

**Run the service:**
```powershell
cp .env.example .env
docker compose up --build
```

### 3. Multi-Root Workspace Setup

Create `engineering-home.code-workspace`:
```json
{
  "folders": [
    { "path": "." },
    { "path": "../apps/my-api" },
    { "path": "../libs/auth-sdk" }
  ],
  "settings": {
    "files.exclude": { "**/.git": true }
  }
}
```

Open in Cursor → both standards and app code are one click away.

### 4. Git Hygiene

**Branch protection on main:**
- Require PRs before merge
- Require status checks (CI) before merge

**Labels to add:**
- `feat`, `fix`, `docs`, `infra`, `chore`, `security`

**Optional:** Add `.github/PULL_REQUEST_TEMPLATE.md` and `CODEOWNERS`

### 5. Security

- Never store real secrets in this repo
- Put only example configs (`.env.example`) in templates
- Add `gitleaks` or `git-secrets` pre-commit hooks in app repos
- The Sandboxie kit is safe to be public (contains no sensitive data)

---

## Trade-offs Considered

**Monorepo vs Polyrepo:**
- **Polyrepo (Chosen):** Each app/library is independent, easier to secure, separate CI/CD
  - Pro: Clear boundaries, independent versioning
  - Pro: Easier to set per-repo permissions
  - Con: Need to keep templates in sync manually

- **Monorepo (Not Chosen):** All code in one giant repo
  - Pro: Atomic changes across services
  - Con: Complex build orchestration, all-or-nothing permissions

---

## Related

- See also: `../../gpt-summaries/devops/251026_sandboxie-env/README.md`
- See also: `../diagrams/` (when created)
- Templates: `../../templates/`

---

**Status:** Accepted
