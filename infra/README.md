# Infrastructure & DevOps

Shared infrastructure configurations, scripts, and tooling that span multiple projects.

## Contents

### `sandboxie/`
Windows Sandboxie Plus configuration for isolated development environments.

**What it does:**
- Isolates browser downloads and untrusted executables
- Provides sandboxed environments for git operations and repo tooling
- Protects your main system from potentially harmful files

**Documentation:**
- Full guide: `sandboxie/SANDBOXIE_INTEGRATION.md`
- Usage examples: `sandboxie/USAGE_EXAMPLES.md`

**Quick start:**
```powershell
# Install Sandboxie Plus first from https://sandboxie-plus.com/
cd C:\dev\infra\sandboxie\scripts\windows
.\install-sandboxie-config.ps1
```

---

## Future Infrastructure

As your infrastructure grows, add folders here for:

**`terraform/`** – Infrastructure as Code
- Cloud resource definitions
- Shared modules
- State management configs

**`kubernetes/`** – Container orchestration
- Base manifests
- Helm charts
- Kustomize overlays

**`ci-cd/`** – Shared CI/CD templates
- GitHub Actions workflows
- GitLab CI templates
- Jenkins pipelines

**`monitoring/`** – Observability stack
- Prometheus configs
- Grafana dashboards
- Alert rules

**`networking/`** – Network configurations
- VPN setups
- DNS configs
- Load balancer rules

**`local-dev/`** – Local development infrastructure
- Shared Docker Compose stacks
- Local K8s configs
- Development databases

---

## Guidelines

**DO:**
- ✅ Version control everything (Infrastructure as Code)
- ✅ Use `.example` files for configurations with secrets
- ✅ Document prerequisites and setup steps
- ✅ Test configurations before committing
- ✅ Add ADRs for infrastructure decisions in `docs/architecture/decisions/`

**DON'T:**
- ❌ Commit secrets, API keys, or passwords
- ❌ Put project-specific infra here (that goes in the project repo)
- ❌ Make breaking changes without documenting migration path
- ❌ Skip testing on a clean environment

---

**Last Updated:** 2025-10-26

