# 4. Project Organization

This document defines how every Odoo project is organized at Apik —
from repository structure and module layout to **submodules**, **symlinks**, permissions, and update management.
Its purpose is to ensure **consistency, maintainability, and reproducibility** across all environments.

---

## 4.1. General Principles

Each client project lives in a **dedicated Git repository** on GitHub.
The repository contains the project's custom code and a **catalog of third‑party modules as Git submodules**
(OCA, vendors, and **Apik’s generic modules** via the `apikcloud/apik-addons` repository).

We keep a strict separation between:
- **Custom code** — project‑specific addons kept at repository root,
- **Third‑party code** — OCA, vendors, and **`apik-addons`** tracked as **submodules** under `/.third-party`.

No code duplication. No vendor code copied into the repo.

### Template Repository

All new projects **must** use the template **[`odoo-repository-template`](https://github.com/apikcloud/odoo-repository-template)**.  
For existing projects, conformance is enforced by the **Update repository** workflow
([`.github/workflows/update.yml`](https://github.com/apikcloud/workflows)).

**Template usage policy**
- **Create new**: use GitHub **Use this template**; do **not** fork.
- **Adopt template**: open a PR titled `chore(repo): adopt odoo-repository-template` and run the Update job.
- Any drift (missing files, wrong paths, CI gaps) must be fixed **via PR** before the next release.

---

## 4.2. Structure Overview

### 4.2.1 Main Folders

| Path | Purpose |
|------|--------|
| `/` | Root directory; contains **custom modules**, symlinks, and configuration. |
| `/.third-party` | **Git submodules only** (OCA, vendors, **apikcloud/apik-addons**). |
| `/.github/workflows` | CI/CD pipelines for build, deployment, tests, and maintenance. |
| `/.devcontainer` | Development container configuration. |
| `/scripts` | Utility scripts for CI/CD, deployment, and maintenance. |
| `/apikcloud` | Deployment configuration and Kubernetes manifests when applicable. |

**Note on `apik-addons`**  
Apik’s generic modules live in a **separate repository** and are included **as a submodule**
under `/.third-party/apikcloud/apik-addons` (same rule as other third‑party sources).

### 4.2.2 Required Files (Template Compliance)

The following files are **mandatory** in every project. They come from the
[`odoo-repository-template`](https://github.com/apikcloud/odoo-repository-template) and must not be removed.

| File | Purpose | Owner | Update rule |
|------|--------|-------|-------------|
| `requirements.txt` | Python pip dependencies | Developer | Keep minimal; pin via constraints when needed |
| `packages.txt` | System packages (APT) required at build/runtime | DevOps/Developer | Add only when strictly necessary |
| `odoo_version.txt` | Odoo **major** version (`16.0`, `17.0`, `18.0`, …) used by tooling/CI | Technical Referent | Update only when planning a major upgrade |
| `README.md` | Project purpose, environments, quickstart, links to docs | Developer | Keep concise and current |
| `CHANGELOG.md` | Human‑written release notes (Keep a Changelog) | Developer / Technical Referent | Update on every release |
| `MIGRATIONS.md` | Documented migration steps per release (if any) | Developer / Technical Referent | Update when migrations exist |
| `.pre-commit-config.yaml` | Pre‑commit hooks (lint/format/security) | Quality Team | Inherit from template; extend per project if needed |
| `.ruff.toml` / `.flake8` / `.pylintrc` | Static analysis configuration | Quality Team | Don’t relax rules without approval |
| `.gitmodules` | Catalog of third‑party submodules | Developer | Keep aligned with `/.third-party` |
| `.gitignore` / `.dockerignore` | Ignore rules for Git/Docker builds | Developer | Keep noise and secrets out of images |

**Examples**

`odoo_version.txt` (single line):
```
18.0
```

`packages.txt` (one package per line, minimal set):
```
postgresql-client
wkhtmltopdf
fonts-dejavu
```

---

## 4.3. Submodule Management

All external code (OCA, vendors, **apikcloud/apik-addons**) must be referenced as **Git submodules**
inside `/.third-party` for traceability and reproducibility.

### 4.3.1 Adding a Submodule (rules & commit policy)

**Rules**
- Place submodules under `/.third-party/<organization>/<repo>`.
- Target the **correct Odoo branch** (e.g. `18.0`, `19.0`).  
- **Pin to a commit** (no floating HEAD) to guarantee deterministic builds.
- Create **symlinks at repository root** to expose only the modules required by the project.
- Commit `.gitmodules`, the submodule path, and the symlinks **together**.

**Examples**
```bash
# OCA example
git submodule add -b 18.0 https://github.com/OCA/account-financial-reporting.git   .third-party/OCA/account-financial-reporting
ln -s ../.third-party/OCA/account-financial-reporting/some_module ./some_module
git add .gitmodules .third-party/OCA/account-financial-reporting ./some_module
git commit -m "chore(submodule): add OCA/account-financial-reporting@18.0 (+ symlink)"

# Apik generic modules (apik-addons) — treated like any third party
git submodule add -b 18.0 https://github.com/apikcloud/apik-addons.git   .third-party/apikcloud/apik-addons
ln -s ../.third-party/apikcloud/apik-addons/apik_generic_module ./apik_generic_module
git add .gitmodules .third-party/apikcloud/apik-addons ./apik_generic_module
git commit -m "chore(submodule): add apikcloud/apik-addons@18.0 (+ symlink)"
```

### 4.3.2 Updating Submodules

**Rules**
- Update intentionally; avoid uncontrolled drifts.
- Prefer updating **before a tag** or during maintenance windows.
- Always **pin** the resulting commit (Git records the SHA automatically).

**Examples**
```bash
# Update a single submodule to its remote branch tip
git submodule update --remote --merge .third-party/OCA/account-financial-reporting
git commit -m "chore(submodule): bump OCA/account-financial-reporting"

# Update all submodules following their configured branches
git submodule update --remote --merge
git commit -m "chore(submodules): bump all third-party modules"
```

### 4.3.3 Removing Submodules

**Rules**
- Deinit first, then remove from index, then commit.
- **Remove the symlinks** you created at root, in the same PR.

**Example**
```bash
git submodule deinit -f .third-party/OCA/l10n-france
git rm -f .third-party/OCA/l10n-france
git rm -f ./l10n_fr_account  # remove linked module at root
git commit -m "chore(submodule): remove OCA/l10n-france (+ symlink)"
```

### 4.3.4 Submodules in Pull Requests (policy & review)

**Author requirements**
- PR title MUST include `submodule` when touching submodules.  
  Example: `chore(submodule): bump OCA/l10n-france to 18.0-<sha>`
- Include a short **changelog** in the PR body (what changed, why, impact).  
- Ensure `.gitmodules`, the submodule path, and the **symlinks** are staged and committed together.
- Provide a link to upstream commits or release notes when available.

**Reviewer checklist**
- Submodule points to the **intended branch** and a **specific commit**.  
- Only **necessary modules** are symlinked at root (no mass‑activation).  
- CI passes (lint, build, tests).  
- No unrelated changes piggybacked.

**CI expectations**
- Build checks the availability of requirements from submodules.  
- Repository compliance verifies submodule placement under `/.third-party` and that symlinks target valid module paths.

---

## 4.4. Module Placement & Activation (Symlinks)

- **Custom modules** live at the **repository root**.
- **Third‑party modules** (including **apikcloud/apik-addons**) live under `/.third-party/...` and are **never copied** elsewhere.
- Activation is done via **symlinks at repository root** pointing to submodule module paths.

> Everything present at the repository root is available to Odoo.  
> Symlinks allow us to expose only what the project needs, without editing `addons_path`.

Do **not** vendor‑copy external code. Use the **submodule + symlink** pattern.

---

## 4.5. Odoo.sh Specific Cases

Odoo.sh **supports Git submodules in a hidden folder and symbolic links**. The same approach should be used, rather than the interface provided by the platform. This prevents build failures due to requirements present in submodules that are not automatically satisfied.

---

## 4.6. Repository Compliance

This configuration may evolve; check the template regularly to ensure compliance.

**Rule**: Any developer contributing to the project must keep this structure intact and required files up to date.  
Divergences must be corrected through a **pull request** and will be reviewed by the Quality team.

---

## 4.7. Access and Responsibilities

| Role | Responsibility |
|------|----------------|
| **Developer** | Maintains repository structure, submodule state, and symlinks. |
| **Technical Referent** | Validates structural consistency and module organization. |
| **Quality Team** | Ensures compliance with the repository template. |
| **DevOps Team** | Manages permissions, deployment automation, and backups. |
| **Project Manager (PM)** | Coordinates functional validation and client communication. |

All contributors — internal or external — must adhere to the same structure and validation pipeline.

---
[← Back to Home](README.md) | [Next → Workflow](05-workflow.md)