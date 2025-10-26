# Project Templates

Starter templates for new services and applications. Copy these to `C:\dev\apps\<project-name>` to bootstrap new projects.

## Available Templates

### `starter-python-api/`
FastAPI-based Python REST API with:
- PostgreSQL database integration
- Docker Compose setup
- pytest testing framework
- Environment-based configuration
- ADR documentation template

**Use for:** REST APIs, microservices, data processing services

**Bootstrap:**
```powershell
Copy-Item -Recurse -Force C:\dev\templates\starter-python-api C:\dev\apps\my-api
cd C:\dev\apps\my-api
git init
cp .env.example .env
docker compose up --build
```

---

### `starter-node-service/`
Node.js/TypeScript service with:
- Express.js web framework
- PostgreSQL with connection pooling
- Jest testing framework
- ESLint configuration
- Docker Compose setup
- Environment-based configuration
- ADR documentation template

**Use for:** Web services, APIs, real-time services, Node.js backends

**Bootstrap:**
```powershell
Copy-Item -Recurse -Force C:\dev\templates\starter-node-service C:\dev\apps\my-service
cd C:\dev\apps\my-service
git init
cp .env.example .env
npm install
docker compose up --build
```

---

## Template Structure

Each template includes:
- `Dockerfile` – production-ready container setup
- `compose.yml` – local development stack (app + database)
- `README.md` – setup and usage instructions
- `.env.example` – required environment variables
- `src/` – source code with examples
- `tests/` – test examples
- `docs/adr/` – Architecture Decision Records folder
- `scripts/` – utility scripts (migrations, setup, etc.)
- `configs/` – configuration files

## Customizing Templates

After copying a template:
1. Update `README.md` with your project name and description
2. Modify `compose.yml` service names if needed
3. Update `package.json` or `requirements.txt` with project-specific dependencies
4. Remove example code from `src/` and `tests/`
5. Add your first ADR in `docs/adr/0001-bootstrap.md`

## Adding New Templates

When creating a new template:
1. Base it on an existing successful project
2. Remove all project-specific code and secrets
3. Add comprehensive `.env.example` with all required variables
4. Include `README.md` with setup instructions
5. Test the bootstrap process from scratch
6. Document any prerequisites (Node version, Python version, etc.)

## Maintenance

**Monthly:** Review and update dependencies in templates
**Quarterly:** Add new best practices discovered in active projects
**When needed:** Create new templates for new technology stacks

---

## Archive

The `_archive/` folder contains old template versions for reference. Don't use these for new projects.

---

**Last Updated:** 2025-10-26

