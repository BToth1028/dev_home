# Apps

**Purpose:** Your deployable applications (one repo per app)

---

## Structure

Each application gets its own directory, typically cloned from a template:

```
apps/
├── user-service/
├── payment-api/
├── admin-dashboard/
└── notification-worker/
```

---

## Creating a New App

### Option 1: Use Helper Script
```powershell
C:\dev\scripts\new-service.ps1 -Template starter-python-api -Name my-new-service
cd C:\dev\apps\my-new-service
cp .env.example .env
docker compose up --build
```

### Option 2: Manual Clone
```powershell
cp -r C:\dev\templates\starter-node-service C:\dev\apps\my-app
cd C:\dev\apps\my-app
rm -rf .git
git init
cp .env.example .env
docker compose up --build
```

---

## Guidelines

- **One app = one directory** - Keep repos independent
- **Follow template patterns** - Use starter templates as base
- **Name descriptively** - `user-service`, not `app1`
- **Keep .env local** - Never commit `.env` files
- **Use Docker** - All apps should have `compose.yml`

---

**Status:** Ready for your first app! 🚀
