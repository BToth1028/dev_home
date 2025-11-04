# Engineering Home

Welcome to the **Project Context OS** – your complete engineering workspace portal.

## 🎯 What is This?

A durable, enterprise-grade system that gives you full visibility across all repos, services, docs, and decisions.

## 🚀 Quick Access

### Core Systems

- **[Developer Portal (Backstage)](http://localhost:7007)** – Service catalog, ownership, health
- **[Code Search (Sourcegraph)](http://localhost:7080)** – Cross-repo code intelligence
- **[Architecture (Structurizr)](http://localhost:8081)** – Live C4 diagrams
- **[Documentation (MkDocs)](http://localhost:8000)** – This site

### Key Documentation

- [Quick Start Guide](QUICK_START.md) – Get up and running
- [Complete System Guide](guides/complete-system-guide.md) – Comprehensive 60+ page guide
- [Implementation Checklist](guides/implementation-checklist.md) – Step-by-step setup
- [Quick Reference](guides/quick-reference.md) – URLs, commands, common tasks
- [Architecture Overview](architecture/README.md) – System design and patterns
- [Decision Log](architecture/decisions/README.md) – All ADRs
- [Reference Guides](reference/README.md) – Command cheat sheets
- [Standards](standards/README.md) – How we do things

## 📁 Workspace Structure

```
C:\DEV\
├── backstage/          Developer portal
├── sourcegraph/        Code search engine
├── services/           Sample/template services
├── apps/               Your applications (separate repos)
├── libs/               Shared libraries (separate repos)
├── templates/          Starter templates
├── infra/              Infrastructure tools
├── docs/               Documentation (you are here)
└── tools/              Development tools
```

## 🔍 Find Anything

### Search Code
Use [Sourcegraph](http://localhost:7080) to search across all your repos instantly.

### Search Docs
Use the search bar at the top of this page, or press `/` to focus.

### Find a Service
Check [Backstage catalog](http://localhost:7007/catalog) for all services, owners, and status.

## 📊 System Status

### Health Checks
- Status API: [http://localhost:5050/health](http://localhost:5050/health)
- Status Node: [http://localhost:5051/health](http://localhost:5051/health)

### Smoke Test
```powershell
.\scripts\smoke.ps1
```

## 🛠️ Common Tasks

### Create a New ADR
```powershell
.\scripts\new-adr.ps1 "Decision title"
```

### Generate Dependency Graphs
```powershell
.\scripts\gen-ts-deps.ps1
.\scripts\gen-py-deps.ps1
```

### Start All Systems
```powershell
.\scripts\up.ps1 -docs -structurizr -backstage -sourcegraph
```

### Backup Sourcegraph
```powershell
.\scripts\backup-sourcegraph.ps1
```

## 📚 Knowledge Base

Our documentation is organized into:

- **[Guides](guides/README.md)** – Comprehensive step-by-step guides
- **[Reference](reference/README.md)** – Quick lookups and cheat sheets
- **[Research](research/README.md)** – Deep dives and comparisons
- **[Standards](standards/README.md)** – Team conventions
- **[GPT Summaries](gpt-summaries/README.md)** – AI-generated insights
- **[Architecture](architecture/README.md)** – System design, ADRs, and integrations
- **[Meetings](meetings/README.md)** – Meeting notes and decisions

## 🎓 Getting Started

New to this workspace?

1. Read the [Quick Start Guide](QUICK_START.md)
2. Review [Architecture Overview](architecture/README.md)
3. Check out [Standards](standards/README.md)
4. Explore the [Backstage catalog](http://localhost:7007/catalog)

## 🔐 Security

All tools require OIDC authentication in production:
- Backstage: SSO via OIDC
- Sourcegraph: SSO via OIDC
- MkDocs: Behind reverse proxy with auth

Local development uses simplified auth.

## 📞 Support

- Architecture questions: Check [architecture/decisions/](architecture/decisions/)
- Code patterns: Search [gpt-summaries/coding-patterns/](gpt-summaries/coding-patterns/)
- Infra issues: See [infra/](../infra/)
- Template questions: Check [templates/](../templates/)

---

**Last Updated:** 2025-10-27
**Maintained By:** Engineering Team
