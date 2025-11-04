# C:\DEV Complete Structure

**Generated:** 2025-10-27
**Purpose:** Definitive map of the entire engineering workspace

---

## 📊 Overview

This is the **source of truth** for C:\DEV structure. Auto-generated and kept current via `scripts\gen-structure.ps1`.

---

## 🗂️ Top-Level Structure

```
C:\DEV\
├── .cursor/              Cursor AI rules and context
├── .github/              GitHub templates and workflows
├── .vscode/              VS Code settings
├── apps/                 Your applications (separate repos)
├── archive/              Archived projects
├── backstage/            Developer portal (Backstage)
├── data/                 Development data and exports
├── docs/                 Documentation and knowledge base
├── infra/                Infrastructure tools and configs
├── libs/                 Shared libraries (separate repos)
├── scratch/              Temporary workspace
├── scripts/              Automation scripts
├── services/             Sample/template services
├── sourcegraph/          Code search engine config
├── templates/            Starter templates
└── tools/                Development tools
```

---

## 📁 Core Directories

### .cursor/
Cursor AI rules and context management.

```
.cursor/
├── rules/
│   ├── project-context-os-enterprise.mdc
│   ├── project-standards.mdc
│   └── context-hot.mdc
```

**Purpose:** Org-wide Cursor AI rules and context

---

### docs/
Complete engineering knowledge base and documentation.

```
docs/
├── index.md                      Portal homepage
├── README.md                     Docs overview
├── QUICK_START.md                Getting started guide
├── NEXT_STEPS.md                 Roadmap
├── _CREATED_TODAY.md             Activity log
├── GPT_CUSTOM_INSTRUCTIONS.txt   AI context
│
├── architecture/                 System architecture
│   ├── README.md
│   ├── c4/                       C4 models (Structurizr)
│   │   ├── README.md
│   │   └── workspace.dsl
│   ├── diagrams/                 Visual diagrams
│   └── decisions/                ADRs (Architecture Decision Records)
│       ├── README.md
│       ├── YYYY-MM-DD_template.md
│       └── [dated decision files]
│
├── reference/                    Quick reference guides
│   ├── README.md
│   ├── git-commands.md
│   └── docker-commands.md
│
├── research/                     Deep dives and investigations
│   ├── README.md
│   ├── api-frameworks/
│   ├── cursor-best-practices/
│   ├── database-comparison/
│   └── template-architecture/
│
├── gpt-summaries/                AI-generated insights
│   ├── README.md
│   ├── _TEMPLATE.md
│   ├── _inbox/                   Holding area
│   ├── architecture/
│   ├── coding-patterns/
│   └── devops/
│
├── standards/                    Team conventions
│   ├── README.md
│   └── git-workflow.md
│
└── meetings/                     Meeting notes
    └── README.md
```

**Purpose:** Single source of truth for all engineering knowledge

---

### templates/
Production-ready starter templates for new services.

```
templates/
├── README.md
│
├── starter-node-service/         TypeScript + Express + PostgreSQL
│   ├── .cursor/rules/
│   ├── .devcontainer/
│   ├── .github/workflows/
│   ├── .husky/
│   ├── src/
│   ├── tests/
│   ├── docs/adr/
│   ├── compose.yml
│   ├── Dockerfile
│   ├── package.json
│   ├── tsconfig.json
│   └── README.md
│
└── starter-python-api/           FastAPI + PostgreSQL
    ├── .cursor/rules/
    ├── .devcontainer/
    ├── .github/workflows/
    ├── src/
    ├── tests/
    ├── docs/adr/
    ├── compose.yml
    ├── Dockerfile
    ├── requirements.txt
    └── README.md
```

**Purpose:** Bootstrap new services with best practices baked in

---

### infra/
Infrastructure-as-code and development tooling.

```
infra/
├── README.md
└── windows/
    └── sandboxie-integration/    Sandboxie v1.0 (production)
        ├── README.md
        ├── USAGE_EXAMPLES.md
        ├── V1.0_RELEASE_NOTES.md
        ├── docs/
        ├── sandboxie/boxes/
        ├── scripts/windows/
        ├── TEST_SUITE.ps1
        └── RUN_TESTS.cmd
```

**Purpose:** Dev environment security and isolation

---

### scripts/
Automation scripts for the workspace.

```
scripts/
├── new-service.ps1               Scaffold new service from template
├── scaffold-repo.ps1             Create new repo structure
├── new-adr.ps1                   Create new ADR from template
├── gen-ts-deps.ps1               Generate TypeScript dependency graph
├── gen-py-deps.ps1               Generate Python dependency graph
├── gen-structure.ps1             Regenerate this file (STRUCTURE.md)
├── up.ps1                        Start Context OS systems
├── down.ps1                      Stop Context OS systems
├── smoke.ps1                     Health check all services
└── backup-sourcegraph.ps1        Backup Sourcegraph data
```

**Purpose:** Workflow automation

---

### backstage/
Developer portal configuration and catalog.

```
backstage/
├── app-config.local.yaml         Backstage config
├── catalog-info.yaml             Self-registration
└── (Backstage app files after npx create-app)
```

**Purpose:** Service catalog, ownership, docs, and health dashboard

---

### sourcegraph/
Code search and intelligence platform.

```
sourcegraph/
└── docker-compose.yaml           Sourcegraph local setup
```

**Purpose:** Cross-repo code search and navigation

---

### services/
Sample services demonstrating health endpoints and patterns.

```
services/
├── status-api/                   Python health service
│   ├── app.py
│   ├── wsgi.py
│   └── requirements.txt
│
└── status-node/                  Node health service
    ├── server.js
    └── package.json
```

**Purpose:** Reference implementations for service patterns

---

### tools/
Development tools and utilities.

```
tools/
└── context-builder/              Vector context management
    ├── README.md
    ├── build_context.py
    ├── settings.yaml
    ├── requirements.txt
    └── compose.yml
```

**Purpose:** Dev tooling and productivity enhancers

---

### apps/
Your application repositories (each is a separate Git repo).

```
apps/
├── README.md
└── [your services here, each in its own repo]
```

**Purpose:** Active applications

---

### libs/
Shared library repositories (each is a separate Git repo).

```
libs/
├── README.md
└── [your libraries here, each in its own repo]
```

**Purpose:** Reusable code

---

## 🚀 Quick Start

### Start the Context OS
```powershell
# Start all systems
.\scripts\up.ps1 -docs -structurizr -backstage -sourcegraph

# Or individually
.\scripts\up.ps1 -docs          # MkDocs on :8000
.\scripts\up.ps1 -structurizr   # C4 diagrams on :8081
```

### Create a New Service
```powershell
.\scripts\new-service.ps1 -name my-api -template python
```

### Create a New ADR
```powershell
.\scripts\new-adr.ps1 "Use PostgreSQL for all services"
```

### Health Check Everything
```powershell
.\scripts\smoke.ps1
```

---

## 🎯 Key Files

| File | Purpose |
|------|---------|
| `STRUCTURE.md` | This file - complete workspace map |
| `README.md` | High-level workspace overview |
| `mkdocs.yml` | Documentation site configuration |
| `package.json` | Node dependencies (dependency-cruiser) |
| `.env.example` | Configuration template |
| `engineering-home.code-workspace` | VS Code multi-root workspace |

---

## 🔄 Keeping This Updated

**Manual:**
```powershell
.\scripts\gen-structure.ps1
```

**Automatic:**
- CI workflow runs on every push to main
- Commits updated STRUCTURE.md automatically

---

## 📚 Related Documentation

- [Engineering Home README](README.md)
- [Documentation Portal](docs/index.md)
- [Quick Start Guide](docs/QUICK_START.md)
- [Architecture Overview](docs/architecture/README.md)
- [Decision Log](docs/architecture/decisions/README.md)

---

**This is your workspace bible.** Keep it current, reference it often.
