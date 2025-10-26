# Engineering Home

This is the root playbook for our polyrepo workspace.

## Structure

- `docs/` – org docs, decisions, checklists, knowledge base
- `templates/` – starter repos (Python API, Node service, etc.)
- `infra/` – shared devops assets (Sandboxie kit, local stacks)
- `.cursor/` – org-wide Cursor rules

## Getting Started

**New service?**
1. Open a template under `templates/`
2. Copy it to `C:\dev\apps\<new-app>`
3. Run `git init` in the new app folder
4. Follow the template's README for setup

**Adding documentation?**
- See `docs/README.md` for the full knowledge base structure
- Add decisions to `docs/architecture/decisions/`
- Use `docs/gpt-summaries/_inbox/` as a holding area, then organize by topic

**Setting up infra?**
- Sandboxie configuration: `infra/sandboxie/`
- Local development stacks: `templates/*/infra/local-stack/`

## Quick Commands

**Bootstrap a new Python API:**
```powershell
Copy-Item -Recurse -Force C:\dev\templates\starter-python-api C:\dev\apps\my-new-api
cd C:\dev\apps\my-new-api
git init
cp .env.example .env
docker compose up --build
```

**Bootstrap a new Node service:**
```powershell
Copy-Item -Recurse -Force C:\dev\templates\starter-node-service C:\dev\apps\my-new-service
cd C:\dev\apps\my-new-service
git init
cp .env.example .env
docker compose up --build
```

## Workspace Setup

**Multi-root workspace** (open home + active apps together):
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
Save as `engineering-home.code-workspace` and open in Cursor.

## Polyrepo Structure

```
C:\dev\
├── engineering-home\     ← THIS REPO (standards, templates, docs)
├── apps\
│   ├── user-service\     ← separate git repo
│   ├── order-api\        ← separate git repo
│   └── ...
└── libs\
    ├── auth-sdk\         ← separate git repo
    ├── db-utils\         ← separate git repo
    └── ...
```

**Each app/library is its own repo.** This repo is the shared foundation.

## Philosophy

**This repo IS:**
- Your top-level playbook & skeleton
- A place new projects start from
- A hub that links out to each app/library repo

**This repo ISN'T:**
- A monorepo for all your services
- Where you store secrets (only `.env.example` files)
- A place for project-specific docs (those go in each project repo)

## Related Resources

- Knowledge base guide: `docs/README.md`
- Quick start: `docs/QUICK_START.md`
- Git workflow: `docs/standards/git-workflow.md`
- Sandboxie integration: `infra/sandboxie/docs/SANDBOXIE_INTEGRATION.md`

---

**Created:** 2025-10-26  
**Last Updated:** 2025-10-26

