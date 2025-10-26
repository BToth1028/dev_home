# COMPREHENSIVE CONTEXT: CODING FILE SYSTEM BEST PRACTICES
## For PC Development Workspace & Cursor AI Editor

**Date:** 2025-10-24
**Purpose:** Complete reference document for optimal coding workspace organization
**Sources:** Industry research, Cursor-specific documentation, developer community practices

---

## EXECUTIVE SUMMARY

This document consolidates best practices for organizing a developer workspace on PC, with emphasis on AI-assisted development using Cursor. Key principles:

- **Separation of concerns** at PC level (apps/libs/infra/templates)
- **Consistent structure** within each repository
- **AI-friendly organization** with proper ignore files and context management
- **Automation-first** approach (DevContainers, CI/CD, Docker)

---

## PART 1: PC-LEVEL WORKSPACE ORGANIZATION

### 1.1 Recommended Top-Level Structure

```
C:\dev\  (or ~/dev/ on Linux/Mac)
  ├── apps\         # Product/service repositories (one folder = one deployable app)
  ├── libs\         # Shared libraries and packages
  ├── infra\        # Infrastructure-as-code repositories
  ├── templates\    # Starter templates/boilerplates for cloning
  ├── scratch\      # Disposable experiments and learning projects
  ├── archive\      # Frozen/retired projects
  └── docs\         # Cross-project documentation, diagrams, ADRs
```

**Rationale:**
- Clear separation by purpose
- Easy to navigate and find projects
- Scales from solo dev to team environments
- Compatible with monorepo or polyrepo approaches

**Sources:** Community consensus from algocademy.com, iteratorshq.com, developer toolkit surveys

### 1.2 Alternative Structures

**Option A: Language-Based**
```
C:\dev\
  ├── python\
  ├── node\
  ├── go\
  └── rust\
```
**Pros:** Easy to apply language-specific tooling
**Cons:** Harder to see full-stack projects, doesn't scale well

**Option B: Client/Project-Based**
```
C:\dev\
  ├── client-acme\
  ├── client-beta\
  └── personal\
```
**Pros:** Good for freelancers/agencies
**Cons:** Duplicates shared code, harder to reuse components

**Recommendation:** Stick with **purpose-based** (apps/libs/infra/templates) unless you have specific needs.

---

## PART 2: REPOSITORY-LEVEL STRUCTURE

### 2.1 Standard Repository Layout

```
<repo-name>\
  ├── .devcontainer\        # DevContainer configuration for reproducible environments
  ├── .github\
  │   ├── workflows\        # CI/CD pipeline definitions
  │   ├── CODEOWNERS        # Code ownership mapping
  │   └── PULL_REQUEST_TEMPLATE.md
  ├── .cursor\
  │   └── rules\            # Cursor-specific AI instructions (.mdc files)
  ├── src\                  # Main source code
  │   ├── components\       # (Web) UI components
  │   ├── services\         # Business logic, API clients
  │   ├── utils\            # Helper functions
  │   ├── models\           # Data models/schemas
  │   └── config\           # Runtime configuration
  ├── tests\                # All test files
  │   ├── unit\
  │   ├── integration\
  │   └── e2e\
  ├── scripts\              # Build, deployment, maintenance scripts
  ├── configs\              # Static configuration files (not runtime)
  ├── docs\
  │   ├── adr\              # Architecture Decision Records
  │   ├── diagrams\         # Architecture diagrams
  │   └── api\              # API documentation
  ├── .editorconfig         # Editor formatting rules
  ├── .gitignore
  ├── .cursorignore         # Files to exclude from AI context
  ├── .env.example          # Environment variable template
  ├── README.md             # Project overview and quickstart
  ├── compose.yml           # Docker Compose for local dev
  ├── Dockerfile
  └── <lang-specific files> # package.json, requirements.txt, go.mod, etc.
```

**Key Principles:**
1. **Predictability:** Developers should know where to find things
2. **Separation:** Source code, tests, docs, and configs in separate directories
3. **Automation:** Include all tooling configs (linters, formatters, CI)
4. **Documentation:** Co-locate docs with code they describe

**Sources:** algocademy.com, Google's Style Guides, Microsoft's DevOps practices

### 2.2 Language-Specific Variations

**Python Projects:**
```
src\
  └── <package_name>\
      ├── __init__.py
      ├── api\
      ├── models\
      └── utils\
tests\
  └── <package_name>\
requirements.txt
setup.py or pyproject.toml
```

**Node/TypeScript Projects:**
```
src\
  ├── index.ts
  ├── routes\
  ├── controllers\
  ├── middleware\
  └── types\
tests\
  └── *.test.ts
package.json
tsconfig.json
```

**Go Projects:**
```
cmd\
  └── <app-name>\
      └── main.go
internal\
  ├── handlers\
  ├── models\
  └── services\
pkg\               # Exportable packages
go.mod
go.sum
```

---

## PART 3: CURSOR-SPECIFIC BEST PRACTICES

### 3.1 Essential Cursor Files

#### `.cursorignore`
Exclude files/folders from AI context to improve performance and relevance.

**Example:**
```
# Dependencies
node_modules/
.venv/
__pycache__/
vendor/

# Build artifacts
dist/
build/
*.pyc
*.o

# Large data files
*.csv
*.parquet
data/
logs/

# Sensitive
.env
.env.local
secrets/
*.key
*.pem

# Legacy code
legacy/
deprecated/

# Generated files
*.generated.*
migrations/
```

**Sources:** github.com/digitalchild/cursor-best-practices, developertoolkit.ai

#### `.cursor/rules/*.mdc`
Define project-specific AI instructions. These are markdown files that Cursor reads to understand your project.

**Example: `.cursor/rules/coding-standards.mdc`**
```markdown
# Coding Standards

## General
- Use TypeScript strict mode
- Prefer functional programming patterns
- No default exports, only named exports
- All functions must have return types

## Testing
- Write tests alongside code (TDD)
- Use descriptive test names: "should do X when Y"
- Aim for 80%+ coverage

## Error Handling
- Always use typed errors
- Log errors with context
- Never swallow exceptions silently
```

**Hierarchical Rules:**
- Root level: Project-wide standards
- Subdirectories: Module-specific rules (e.g., `frontend/.cursor/rules/`, `backend/.cursor/rules/`)

**Sources:** developertoolkit.ai, cursor.fan

### 3.2 Cursor Composer Best Practices

1. **Keep Sessions Short:** Avoid long Composer sessions (>20 messages) to prevent UI slowdown
2. **Use Checkpoints:** Save working states frequently to return to if AI veers off course
3. **Request Plans First:** Ask "What's the plan?" before implementing large changes
4. **Maintain Context Notes:** Keep a project specification note in Composer context
5. **Leverage TDD:** Ask AI to write tests first, then implementation
6. **Multi-Root Workspaces:** Open related repos in same window for cross-repo features

**Sources:** cursor.fan/tutorial/HowTo/idiots-guide-to-bigger-projects, instructa.ai

### 3.3 Context Management Strategies

**Break Down Large Files:**
- Files >500 lines should be refactored into smaller modules
- AI works better with focused, single-responsibility files

**Co-locate Documentation:**
- Place `README.md` inside complex modules
- Use inline JSDoc/docstrings for AI to understand intent

**Ignore Properly:**
- Don't let AI see test snapshots, lock files, or generated code
- Use both `.gitignore` and `.cursorignore` (they serve different purposes)

---

## PART 4: VERSION CONTROL & COLLABORATION

### 4.1 Git Best Practices

**Branch Strategy:**
```
main               # Production-ready code
├── develop        # Integration branch (optional, for GitFlow)
├── feature/*      # New features
├── fix/*          # Bug fixes
└── chore/*        # Maintenance tasks
```

**Commit Conventions:**
```
feat: add user authentication
fix: resolve null pointer in payment flow
docs: update API endpoints in README
chore: upgrade dependencies
test: add unit tests for order service
refactor: simplify error handling logic
```

**Sources:** Conventional Commits, Git branching models

### 4.2 Code Review Practices

1. **Pull Request Template:** Include summary, why, how to test, breaking changes
2. **CODEOWNERS:** Define who reviews what (e.g., `/src/ @backend-team`)
3. **Automated Checks:** Require passing tests, linting, and build before merge
4. **Small PRs:** Aim for <400 lines changed per PR for easier review

---

## PART 5: DEVCONTAINER & DOCKER

### 5.1 DevContainer Structure

**`.devcontainer/devcontainer.json`**
```json
{
  "name": "Project Dev Environment",
  "image": "mcr.microsoft.com/devcontainers/...",
  "features": {},
  "postCreateCommand": "npm install",
  "customizations": {
    "vscode": {
      "extensions": ["dbaeumer.vscode-eslint", "esbenp.prettier-vscode"]
    }
  },
  "runArgs": ["--env-file", ".env"]
}
```

**Benefits:**
- Consistent dev environment across team
- No "works on my machine" issues
- Easy onboarding for new developers
- Cursor fully supports DevContainers

**Sources:** Microsoft DevContainer specification, containers.dev

### 5.2 Docker Compose for Local Dev

**`compose.yml`**
```yaml
services:
  app:
    build: .
    ports: ["3000:3000"]
    env_file: .env
    volumes: [".:/workspace"]
    depends_on: [db, cache]

  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: postgres
    volumes: ["pgdata:/var/lib/postgresql/data"]

  cache:
    image: redis:7
    ports: ["6379:6379"]

volumes:
  pgdata:
```

**Best Practices:**
- Use specific image tags (not `latest`)
- Externalize secrets via `.env` or secrets management
- Use volumes for data persistence
- Define health checks for dependent services

---

## PART 6: TESTING & CI/CD

### 6.1 Testing Structure

```
tests\
  ├── unit\           # Pure function tests, no I/O
  ├── integration\    # Tests with real DB, APIs
  ├── e2e\            # Full user flow tests
  ├── fixtures\       # Test data
  └── helpers\        # Test utilities
```

**Guidelines:**
- Tests mirror `src/` structure
- Test files named `<module>.test.<ext>` or `test_<module>.<ext>`
- Use descriptive test names: `test_user_login_with_invalid_credentials`

### 6.2 CI/CD Pipeline Example

**`.github/workflows/ci.yml`**
```yaml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm test
      - run: npm run lint
      - run: npm run build
```

**Key Elements:**
- Run on every push and PR
- Fail fast (stop on first error)
- Cache dependencies for speed
- Run linting, tests, and build

---

## PART 7: DOCUMENTATION

### 7.1 README Structure

```markdown
# Project Name

One-line description of what this does.

## Prerequisites
- Node 20+
- Docker & Docker Compose

## Quick Start
1. `cp .env.example .env`
2. `docker compose up --build`
3. Visit http://localhost:3000

## Development
- `npm run dev` - Start dev server
- `npm test` - Run tests
- `npm run lint` - Lint code

## Project Structure
Brief overview of folders.

## Contributing
Link to CONTRIBUTING.md

## License
```

### 7.2 Architecture Decision Records (ADR)

**Template: `docs/adr/NNNN-<title>.md`**
```markdown
# ADR NNNN: Use PostgreSQL

Date: 2025-10-24
Status: Accepted | Rejected | Deprecated | Superseded by ADR-XXXX

## Context
What problem are we solving? What constraints do we have?

## Decision
What did we decide to do?

## Consequences
### Positive
- Benefit 1
- Benefit 2

### Negative
- Tradeoff 1
- Tradeoff 2

## Alternatives Considered
- Option A: Why rejected
- Option B: Why rejected
```

**Rationale:** ADRs create a decision history for future reference, especially useful for AI context.

---

## PART 8: TEMPLATES & STARTER KITS

### 8.1 What Makes a Good Template?

1. **Complete but Minimal:** Everything needed, nothing extra
2. **Well-Documented:** Clear README with setup steps
3. **Pre-configured Tooling:** Linters, formatters, CI already set up
4. **DevContainer Support:** Ready for containerized dev
5. **Testing Setup:** Framework installed and example test included
6. **Environment Variables:** `.env.example` provided
7. **Docker Ready:** Dockerfile and compose.yml included

### 8.2 Template Maintenance

- Keep templates up-to-date with latest best practices
- Version dependencies explicitly (no `^` or `~` in templates)
- Include a CHANGELOG in template repo
- Tag releases (e.g., `v1.0.0`, `v1.1.0`)

---

## PART 9: SPECIAL CONSIDERATIONS

### 9.1 Windows-Specific Tips

**Path Handling:**
- Use forward slashes in configs when possible (e.g., `"src/**/*.ts"`)
- Be aware of case sensitivity differences (Git is case-sensitive, NTFS is not)
- Use WSL2 for better Linux tool compatibility

**Line Endings:**
- Set `core.autocrlf=true` in Git config
- Use `.editorconfig` to enforce `end_of_line = lf`

### 9.2 Working with Large Codebases

1. **Modular Architecture:** Break into smaller, independent modules
2. **Clear Boundaries:** Define interfaces between modules
3. **Incremental Adoption:** Don't refactor everything at once
4. **Feature Flags:** Use flags to gradually roll out changes
5. **Multi-Root Workspace:** Open only relevant parts of monorepo in Cursor

**Sources:** instructa.ai/blog/how-to-use-cursor-with-a-large-codebase

### 9.3 Monorepo vs Polyrepo

**Monorepo (Single repo, multiple projects):**
- **Pros:** Shared tooling, atomic commits across projects, easier refactoring
- **Cons:** Larger repo size, more complex CI, potential for tight coupling
- **Tools:** Nx, Turborepo, Lerna

**Polyrepo (One repo per project):**
- **Pros:** Clear ownership, independent versioning, simpler CI per project
- **Cons:** Code duplication, harder to coordinate changes, version management complexity
- **Tools:** Git submodules, package registries (npm, PyPI)

**Recommendation:** Use polyrepo by default; switch to monorepo if you have >5 tightly-coupled projects.

---

## PART 10: CONTEXT PACKETS (AI-FRIENDLY DOCS)

### 10.1 Why Context Packets?

- **Concise:** 5-10 lines, easy to paste into AI chats
- **Structured:** Consistent format, easy to parse
- **Actionable:** Provides exactly what AI needs to help

### 10.2 Standard Packet Types

**ADR Prep Packet:**
```
PROBLEM: <one line>
OPTIONS: <A/B/C>
EVIDENCE: <links or rationale>
TRADEOFFS: <bullets>
RECOMMEND: <pick one>
DATE: 2025-10-24
```

**Change Request Packet:**
```
WHAT: <feature/fix, user story>
WHY: <reason or ADR ref>
DONE WHEN:
- <acceptance criteria>
CONSTRAINTS:
- API compatible? (yes/no)
- Performance budget: <e.g., <50ms p95>
- Security/privacy: <notes>
```

**Debug Context Packet:**
```
SYMPTOM: <error message or behavior>
REPRO STEPS: <numbered>
EXPECTED vs ACTUAL: <1-2 lines>
LOG/TRACE SNIPPET: <short, relevant>
LAST CHANGES: <commit or PR #>
ENV: <devcontainer/docker/local venv, os>
```

**Project Snapshot Packet:**
```
PROJECT: <name>
GOAL (this week): <plain english>
REPO STRUCTURE:
- src/: <languages, major modules>
- tests/: <framework>
- configs/: <env vars or config files used>
- docs/adr/: <list of latest ADR titles>
RUNTIME:
- Start: <command>
- Services: <db/cache/queues, ports>
KNOWN PAIN POINTS:
- <short bullets>
ASK:
- <the exact thing you want>
```

---

## PART 11: STARTER TEMPLATE CHECKLIST

Use this checklist when creating or reviewing a starter template:

### Repository Basics
- [ ] Clear, descriptive README with quickstart instructions
- [ ] LICENSE file (if open source)
- [ ] .gitignore for language/framework
- [ ] .editorconfig for consistent formatting
- [ ] .env.example with all required variables documented

### Development Environment
- [ ] DevContainer configuration (.devcontainer/)
- [ ] Dockerfile for containerized development
- [ ] compose.yml for local services (DB, cache, etc.)
- [ ] Setup script (scripts/setup.sh or setup.ps1)

### Code Quality
- [ ] Linter configured (ESLint, Flake8, Golint, etc.)
- [ ] Formatter configured (Prettier, Black, gofmt, etc.)
- [ ] Pre-commit hooks (.pre-commit-config.yaml or Husky)
- [ ] Type checking (TypeScript, mypy, etc.)

### Testing
- [ ] Testing framework installed
- [ ] Example/smoke test included
- [ ] Test script in package.json/Makefile
- [ ] Coverage reporting configured

### CI/CD
- [ ] GitHub Actions workflow (or GitLab CI, etc.)
- [ ] Runs tests on every push/PR
- [ ] Runs linter on every push/PR
- [ ] (Optional) Automated deployment to staging

### Documentation
- [ ] Project structure explained in README
- [ ] API documentation (if applicable)
- [ ] ADR folder structure (docs/adr/)
- [ ] CONTRIBUTING.md (if accepting contributions)

### Cursor-Specific
- [ ] .cursorignore file
- [ ] .cursor/rules/ directory with initial coding standards
- [ ] Context packet templates in docs/

### Dependency Management
- [ ] Lockfile committed (package-lock.json, poetry.lock, go.sum)
- [ ] Dependency versions pinned (no wildcards in templates)
- [ ] Vulnerability scanning configured (Dependabot, Renovate)

---

## PART 12: EVALUATION OF CURRENT TEMP_SETUP

### Strengths of Your Current Setup ✅

1. **Clean Separation:** `docs/`, `infra/`, `templates/` is clear
2. **Context Packets:** Excellent addition, very AI-friendly
3. **Two Languages:** Python + Node covers most use cases
4. **DevContainer Ready:** Both templates have `.devcontainer/`
5. **Docker First:** All templates use Docker Compose
6. **CI Included:** Basic GitHub Actions workflows present
7. **Path Helpers:** Smart handling of OS-native data directories

### Areas for Improvement 🔧

1. **Missing `.env.example` files:** README mentions them, but they're not in templates
2. **No `.cursorignore` files:** Should add to both templates
3. **No `.cursor/rules/` directories:** Templates would benefit from initial AI rules
4. **Limited ADR examples:** Only one ADR in Python template
5. **No pre-commit hooks in Node template:** Python has them, Node should too
6. **ESLint config mismatch:** Node template uses ESLint 9 but has `.cjs` config (might need flat config)
7. **No actual DB interaction examples:** Templates are minimal (good for starting, but could show basic query examples)
8. **Missing CONTRIBUTING.md:** Useful if templates will be community-contributed
9. **No dependency update automation:** Consider adding Dependabot config

### Quick Wins (Easy Additions)

1. Add `.env.example` to both templates:
   ```
   # Node template
   APP_PORT=3000
   APP_DATA_DIR=
   APP_LOG_DIR=
   APP_CACHE_DIR=

   # Python template
   APP_PORT=8000
   DATABASE_URL=postgresql://postgres:postgres@db:5432/app
   APP_DATA_DIR=
   APP_LOG_DIR=
   APP_CACHE_DIR=
   ```

2. Add `.cursorignore` to both:
   ```
   node_modules/
   .venv/
   __pycache__/
   dist/
   build/
   .pytest_cache/
   .coverage
   logs/
   data/
   .cache/
   ```

3. Add `.cursor/rules/coding-standards.mdc` to each template (see Part 3.1 example)

4. Add Dependabot config (`.github/dependabot.yml`):
   ```yaml
   version: 2
   updates:
     - package-ecosystem: "npm"  # or "pip"
       directory: "/"
       schedule:
         interval: "weekly"
   ```

---

## PART 13: ADDITIONAL RECOMMENDATIONS

### For Your Specific Setup (C:\DEV\TEMP_SETUP)

1. **Rename to Permanent Location:**
   - Move `TEMP_SETUP` to `C:\dev\templates\gold-standard` or similar
   - Update README paths accordingly

2. **Create Companion CLI Tool (Optional):**
   ```bash
   # Script to clone and initialize template
   npx degit your-repo/templates/starter-node-service my-new-project
   cd my-new-project
   ./scripts/setup.sh
   ```

3. **Version Your Templates:**
   - Tag releases: `v1.0.0`, `v1.1.0`
   - Document changes in CHANGELOG.md
   - Allow users to specify version when cloning

4. **Add More Templates (Future):**
   - `starter-react-app` (Vite + React + TypeScript)
   - `starter-python-ml` (Jupyter + pandas + scikit-learn)
   - `starter-go-api` (Gin + GORM + PostgreSQL)

5. **Shared Configs:**
   - Consider a `shared-configs/` directory with reusable:
     - `.editorconfig`
     - `.prettierrc`
     - ESLint configs
     - DevContainer base images

---

## PART 14: TOOLS & RESOURCES

### Essential Tools

**Version Control:**
- Git (required)
- GitHub Desktop or GitKraken (GUI options)

**Containerization:**
- Docker Desktop (Windows/Mac)
- Docker Engine + Docker Compose (Linux)

**Linters & Formatters:**
- **Python:** Black, isort, Flake8, mypy
- **Node/TypeScript:** ESLint, Prettier
- **Go:** gofmt, golangci-lint
- **Multi-language:** EditorConfig

**Testing:**
- **Python:** pytest, unittest
- **Node/TypeScript:** Vitest, Jest, Mocha
- **Go:** built-in `go test`

**CI/CD:**
- GitHub Actions (easiest for GitHub repos)
- GitLab CI (for GitLab)
- CircleCI, Travis CI (alternatives)

**Documentation:**
- Mermaid (diagrams in markdown)
- Docusaurus (documentation sites)
- Swagger/OpenAPI (API docs)

### Learning Resources

**General:**
- [12-Factor App](https://12factor.net/) - Principles for cloud-native apps
- [Google Engineering Practices](https://google.github.io/eng-practices/) - Code review guidelines
- [Microsoft DevOps Best Practices](https://learn.microsoft.com/en-us/devops/)

**Cursor-Specific:**
- [Cursor Documentation](https://docs.cursor.com/)
- [cursor.fan tutorials](https://cursor.fan/tutorial/)
- [Developer Toolkit AI - Context Management](https://developertoolkit.ai/en/shared-workflows/context-management/)

**Docker & DevContainers:**
- [containers.dev](https://containers.dev/) - DevContainer spec
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

## PART 15: FINAL CHECKLIST

### When Starting a New Project

1. [ ] Choose appropriate template or start from scratch
2. [ ] Clone/copy template to correct location in workspace (e.g., `C:\dev\apps\my-project`)
3. [ ] Initialize Git repository
4. [ ] Copy `.env.example` to `.env` and fill in values
5. [ ] Update README with project-specific information
6. [ ] Configure DevContainer (if not using template)
7. [ ] Set up CI/CD pipeline
8. [ ] Create initial ADR documenting key decisions
9. [ ] Add `.cursorignore` and `.cursor/rules/` for AI assistance
10. [ ] Write first test and ensure it passes
11. [ ] Create initial commit
12. [ ] Push to remote repository
13. [ ] Set up issue tracking (GitHub Issues, Jira, etc.)
14. [ ] Document setup process for team members

---

## CONCLUSION

**Key Takeaways:**

1. **Consistency Matters:** Use the same structure across all projects
2. **Automate Everything:** CI/CD, linting, testing, deployments
3. **Document Decisions:** Use ADRs to capture "why" not just "what"
4. **AI-Friendly Organization:** Proper ignore files and context help AI assistants
5. **Developer Experience:** Invest in good templates and tooling upfront

**Your TEMP_SETUP is a strong foundation.** With minor additions (`.env.example`, `.cursorignore`, `.cursor/rules/`), it will be production-ready.

**Next Steps:**
1. Review this document with team/GPT for additional feedback
2. Implement "Quick Wins" from Part 12
3. Move to permanent location and version templates
4. Use templates for next 2-3 projects to validate and refine
5. Share with community (if open source)

---

## APPENDIX A: GLOSSARY

- **ADR:** Architecture Decision Record - document explaining a significant technical decision
- **CI/CD:** Continuous Integration / Continuous Deployment - automated testing and deployment
- **DevContainer:** A Docker container configured for development environments
- **Monorepo:** Single repository containing multiple projects
- **Polyrepo:** Multiple repositories, one per project
- **Context Packet:** Short, structured document designed for easy AI consumption

---

## APPENDIX B: SOURCES & CITATIONS

1. algocademy.com - Code organization and scalability practices
2. developertoolkit.ai - Cursor-specific context management
3. cursor.fan - Cursor tutorials and best practices
4. github.com/digitalchild/cursor-best-practices - Community-maintained Cursor guide
5. instructa.ai - Large codebase management with Cursor
6. Microsoft DevContainer Specification - containers.dev
7. Conventional Commits - conventionalcommits.org
8. 12-Factor App Methodology - 12factor.net
9. Google Engineering Practices Documentation
10. Community consensus from developer forums and surveys

---

**Document Version:** 1.0
**Last Updated:** 2025-10-24
**Maintainer:** [Your Name/Team]
**License:** CC BY 4.0 (or your preference)

