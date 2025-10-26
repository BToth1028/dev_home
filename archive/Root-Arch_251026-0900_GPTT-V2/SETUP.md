# Setup Guide: Root-Arch V2 Templates

## Quick Start

### 1. Create the recommended PC directory structure:

```bash
mkdir -p C:\dev\apps
mkdir -p C:\dev\libs
mkdir -p C:\dev\infra
mkdir -p C:\dev\templates
mkdir -p C:\dev\scratch
mkdir -p C:\dev\archive
mkdir -p C:\dev\docs
```

### 2. Move this template package to the templates directory:

```bash
# Current location: C:\DEV\templates\Root-Arch_[251026-0900_GPTT]_V2
# Recommended: C:\dev\templates\gold-standard

# Or keep it where it is and use as-is
```

### 3. Create .env.example files (blocked by gitignore, create manually):

**For `starter-node-service/.env.example`:**
```env
# App Configuration
APP_PORT=3000

# Database
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/postgres

# Data Directories (optional - will use OS defaults if not set)
# APP_DATA_DIR=
# APP_LOG_DIR=
# APP_CACHE_DIR=
```

**For `starter-python-api/.env.example`:**
```env
# App Configuration
APP_PORT=8000

# Database
DATABASE_URL=postgresql://postgres:postgres@db:5432/postgres

# Data Directories (optional - will use OS defaults if not set)
# APP_DATA_DIR=
# APP_LOG_DIR=
# APP_CACHE_DIR=
```

## Using a Template

### Node/TypeScript Service

```bash
# Clone the template
cp -r templates/starter-node-service ../apps/my-new-service
cd ../apps/my-new-service

# Setup environment
cp .env.example .env

# Start with Docker
docker compose up --build

# Or develop locally
npm ci
npm run dev

# Test
npm test
```

### Python/FastAPI Service

```bash
# Clone the template
cp -r templates/starter-python-api ../apps/my-new-api
cd ../apps/my-new-api

# Setup environment
cp .env.example .env

# Start with Docker
docker compose up --build

# Or develop locally
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn src.app:app --reload

# Test
pytest -q
```

## Verification Checklist

After setting up a new project from template:

- [ ] `.env` file created from `.env.example`
- [ ] Docker Compose starts successfully (`docker compose up`)
- [ ] Health endpoint responds (`http://localhost:3000/health` or `http://localhost:8000/health`)
- [ ] DB ping endpoint works (`/db/ping`)
- [ ] Tests pass (`npm test` or `pytest`)
- [ ] Linter runs (`npm run lint` or `pre-commit run -a`)
- [ ] Git initialized (`git init`)
- [ ] Initial commit made
- [ ] Update README with project-specific info
- [ ] Update `package.json` name (Node) or `setup.py` metadata (Python)

## Template Maintenance

To keep templates up-to-date:

1. Dependabot will create PRs for dependency updates
2. Review and merge Dependabot PRs weekly
3. Test templates after major updates
4. Update ADRs when making architectural changes
5. Version templates using git tags (`v1.0.0`, `v1.1.0`)

## Troubleshooting

**Docker Compose fails:**
- Ensure Docker Desktop is running
- Check ports 3000/8000/5432 aren't already in use
- Run `docker compose down -v` to clean up

**DevContainer issues:**
- Rebuild container: Cmd+Shift+P > "Dev Containers: Rebuild Container"
- Check `.env` file exists
- Verify Docker has enough resources allocated

**Pre-commit hooks fail:**
- Run `pre-commit install` (Python)
- Run `npm run prepare` (Node/Husky)
- Check file formatting matches `.editorconfig`

## Next Steps

1. Review `docs/COMPREHENSIVE_FILESYSTEM_BEST_PRACTICES.md` (upload your source)
2. Customize `.cursor/rules/` for your coding standards
3. Add project-specific scripts to `scripts/`
4. Update `CODEOWNERS` and `CONTRIBUTING.md`
5. Set up CI/CD secrets in GitHub Settings
