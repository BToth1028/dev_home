# C4 Architecture Model

This directory contains our system architecture modeled using [Structurizr DSL](https://structurizr.com/).

## Viewing the Model

**Local:**
```powershell
.\scripts\up.ps1 -structurizr
# Open http://localhost:8081
```

**Files:**
- `workspace.dsl` – Main architecture model

## C4 Model Levels

1. **System Context** – How our system fits in the world
2. **Container** – High-level tech choices (apps, databases, etc.)
3. **Component** – Internal structure of containers
4. **Code** – Class diagrams (optional)

## Editing

Edit `workspace.dsl` directly. Structurizr Lite auto-reloads on save.

## Best Practices

- Keep the model up to date with reality
- Use meaningful names and descriptions
- Group related systems
- Document relationships with clear labels
- Commit changes to Git

## Examples

```dsl
workspace "My System" {
  model {
    user = person "User"
    system = softwareSystem "My System" {
      webapp = container "Web App" "React"
      api = container "API" "FastAPI"
      db = container "Database" "PostgreSQL"
    }
    user -> webapp "Uses"
    webapp -> api "Calls"
    api -> db "Reads/Writes"
  }
  views {
    systemContext system {
      include *
      autoLayout
    }
    container system {
      include *
      autoLayout
    }
  }
}
```

## Related

- [Architecture Overview](../README.md)
- [Decisions](../decisions/README.md)
