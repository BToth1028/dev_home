# Sourcegraph Documentation

Local code search and intelligence platform for the C:\DEV engineering workspace.

## Quick Start

```powershell
# Start Sourcegraph
cd C:\DEV\sourcegraph
docker compose up -d

# Access UI
# Open: http://localhost:7080

# View logs
docker logs sourcegraph -f
```

## Documentation

- **[Quick Start Guide](QUICK_START_GUIDE.md)** - Complete walkthrough for first-time users
- **[README](../../sourcegraph/README.md)** - Deployment documentation and troubleshooting

## Architecture Decisions

- **[Deployment Strategy](../decisions/2025-10-27_sourcegraph-deployment.md)** - Why all-in-one image
- **[DNS Fix](2025-10-27_gitserver-dns-fix.md)** - Resolved gitserver-0 lookup errors

## What is Sourcegraph?

Sourcegraph provides powerful code search across all your repositories:

### Core Features
- **Cross-repository search** - Find code across all your projects
- **Code intelligence** - Go-to-definition, find references across repos
- **Symbol search** - Find functions, classes, interfaces directly
- **Regex support** - Advanced pattern matching
- **Language-aware** - TypeScript, Python, Go, Java, and more

### Use Cases for C:\DEV

1. **Find all usages** - Where is this function used across all services?
2. **Security audit** - Search for hardcoded secrets or patterns
3. **Learn patterns** - How do we handle errors in other services?
4. **Navigate codebases** - Jump to definitions across repo boundaries
5. **Refactoring** - Find all references before making changes

## Access

- **URL:** http://localhost:7080
- **First user becomes admin**
- **Default port:** 7080

## File Structure

```
sourcegraph/
├── docker-compose.yaml    # Deployment configuration
└── README.md             # Operations guide

docs/architecture/sourcegraph/
├── README.md                           # This file
├── QUICK_START_GUIDE.md               # User walkthrough
└── 2025-10-27_gitserver-dns-fix.md   # Technical implementation

docs/architecture/decisions/
└── 2025-10-27_sourcegraph-deployment.md  # ADR
```

## Resources

- **Official Docs:** https://docs.sourcegraph.com
- **Search Syntax:** https://docs.sourcegraph.com/code_search/reference/queries
- **Docker Deployment:** https://docs.sourcegraph.com/admin/deploy/docker-single-container

---

**Ready to start?** Follow the [Quick Start Guide](QUICK_START_GUIDE.md) →
