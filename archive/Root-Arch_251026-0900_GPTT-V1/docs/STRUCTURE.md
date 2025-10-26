# Folder Structure Gold Standard

## PC-level
```
dev/
  apps/       # product/service repos (one repo per folder)
  libs/       # shared libraries repos
  infra/      # infra-as-code repos
  templates/  # starter repos you clone from
  scratch/    # disposable experiments
  archive/    # frozen/retired repos
  docs/       # cross-project notes/diagrams
```

## Inside each repo
```
<repo>/
  src/
  tests/
  scripts/
  configs/
  docs/
    adr/
    diagrams/
  .devcontainer/
  .github/workflows/
  .editorconfig
  .gitignore
  .env.example
  README.md
  compose.yml
  Dockerfile
```

## Non-code data (keep out of git)
- Use env vars to point to OS-native dirs: `APP_DATA_DIR`, `APP_LOG_DIR`, `APP_CACHE_DIR`.
- macOS/Linux: `~/.config/<app>`, `~/.local/share/<app>`, `~/.cache/<app>`
- Windows: `%APPDATA%\<app>`, `%LOCALAPPDATA%\<app>\Cache`, `%PROGRAMDATA%\<app>`
