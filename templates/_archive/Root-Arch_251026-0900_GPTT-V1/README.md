# Gold Standard Dev Package (for Cursor)

This package gives you **ready-to-clone templates** for Python and TypeScript services,
plus shared local infrastructure and copy‑paste AI context packets.

## What’s inside
- `templates/starter-python-api` — FastAPI + pytest + devcontainer + Docker Compose + CI + pre-commit
- `templates/starter-node-service` — Express + TypeScript + Vitest + devcontainer + Docker Compose + CI + ESLint/Prettier
- `infra/local-stack` — docker-compose for shared services (e.g., Postgres, Redis)
- `docs/` — folder structure guide and AI context packets

## Quick use
1. Open Cursor → **Open Folder** → select either template folder (or copy it to your desired location first).
2. If using Dev Containers: open the repo and **Reopen in Container**.
3. Copy env file: `cp .env.example .env`
4. Run: `docker compose up --build`
5. Tests: Python `pytest -q`, Node `npm test`

## Recommended PC-level layout (create on your machine)
```
C:\dev\
  apps\
  libs\
  infra\
  templates\
  scratch\
  archive\
  docs\
```
