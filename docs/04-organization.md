<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 04-organization
Project: aikcloud/docs
Last update: 2025-12-23
Status: Draft
Reviewer: royaurelien
-->

# Project Organization

<mark> Status: Draft — Pending Review and Approval </mark>

> This document defines how every Odoo project is organized at Apik —
> from repository structure and module layout to **submodules**, **symlinks**, permissions, and update management.
> Its purpose is to ensure **consistency, maintainability, and reproducibility** across all environments.


## General Principles

Each client project lives in a **dedicated Git repository** on GitHub.
The repository contains the project's custom code and a **catalog of third‑party modules as Git submodules**
(OCA, vendors, and **Apik’s generic modules** via the `apikcloud/apik-addons` repository).

We keep a strict separation between:
- **Custom code** — project‑specific addons kept at repository root,
- **Third‑party code** — OCA, vendors, and **`apik-addons`** tracked as **submodules** under `.third-party/`.

No code duplication. No vendor code copied into the repo.

All new projects **must** use the template **[`odoo-repository-template`](https://github.com/apikcloud/odoo-repository-template)**.  
For existing projects, conformance is enforced by the [Update repository](https://github.com/apikcloud/workflows/actions/workflows/update.yml) workflow
([`.github/workflows/update.yml`](https://github.com/apikcloud/workflows)).  
Any drift (missing files, wrong paths, CI gaps) must be fixed on the `main` branch before the next release.



## Structure Overview

**General rules:**

- **Custom modules** live at the **repository root**.
- **Third‑party modules** (including **apikcloud/apik-addons**) live under 
  `.third-party/...` and are **never copied** elsewhere.
- Activation is done via **symlinks at repository root** pointing to submodule module paths.
- Do **not** vendor‑copy external code. Use the **submodule + symlink** pattern.

> Everything present at the repository root is available to Odoo.  
> Symlinks allow us to expose only what the project needs, without editing `addons_path`.


### Main Folders

| Path | Purpose |
|------|--------|
| `/` | Root directory; contains **custom modules**, symlinks, and configuration. |
| `/.third-party` | **Git submodules only** (OCA, vendors, **apikcloud/apik-addons**). |
| `/.github/workflows` | CI/CD pipelines for build, deployment, tests, and maintenance. |
| `/.devcontainer` | Development container configuration. |

**Note on `apik-addons`**  
Apik’s generic modules live in a **separate repository** and are included **as a submodule**
under `.third-party/apikcloud/apik-addons` (same rule as other third‑party sources).

### Required Files (Template Compliance)

The following files are **mandatory** in every project. They come from the template and must not be removed.

| File | Purpose | Owner | Update rule |
|------|--------|-------|-------------|
| `requirements.txt` | Python pip dependencies | Developer | Keep minimal; pin via constraints when needed |
| `packages.txt` | System packages (APT) required at build/runtime | DevOps/Developer | Add only when strictly necessary |
| `odoo_version.txt` | Odoo **major** version (`16.0`, `17.0`, `18.0`, …) used by tooling/CI | Technical Referent | Update only when planning a major upgrade |
| `README.md` | Project purpose, environments, quickstart, links to docs | Developer | Keep concise and current |
| `CHANGELOG.md` | Human‑written release notes (Keep a Changelog) | Developer / Technical Referent | Update on every release |
| `MIGRATIONS.md` | Documented migration steps per release (if any) | Developer / Technical Referent | Update before each release with the necessary instructions |
| `.pre-commit-config.yaml` | Pre‑commit hooks (lint/format/security) | Quality Team | Inherit from template; extend per project if needed |
| `.ruff.toml` / `.flake8` / `.pylintrc` | Static analysis configuration | Quality Team | Don’t relax rules without approval |
| `.gitmodules` | Catalog of third‑party submodules | Developer | Keep aligned with `.third-party/` |
| `.gitignore` / `.dockerignore` | Ignore rules for Git/Docker builds | Developer | Keep noise and secrets out of images |
| `migrate.sh` | Migration helper script | Developer | Update before each release with the necessary commands (installation, module updates, etc.) |

**Examples**

`odoo_version.txt` (single line):
```
apik/odoo:18.0-<release-date>-<enterprise>
```

`packages.txt` (one package per line):
```
xmlsec1
```

`requirements.txt` (one package per line):
```
pysaml2
```

---

## Submodule Management

All external code (OCA, vendors, **apikcloud/apik-addons**) must be referenced as **Git submodules**
inside `.third-party/` for traceability and reproducibility.

> Private repositories must be added via SSH URLs to avoid credential prompts. A good practice is to use for all submodules the same access method to prevent authentication issues.

A repository containing submodules must be initialised with:
```bash
git submodule update --init (--jobs 4)
```

### Adding a Submodule

**Rules**
- Place submodules under `.third-party/<owner>/<repository>`.
- Name the submodule according to the following rule: `<owner>/<repository>`
- Target the **correct Odoo branch** (e.g. `18.0`, `19.0`).
- Always use the **SSH scheme**.
- **Pin to a commit** (no floating HEAD) to guarantee deterministic builds.
- Create **symlinks at repository root** to expose only the modules required by the project.

**Examples**

*OCA example*
```bash
# Add a submodule
git submodule add --name OCA/account-financial-reporting -b 18.0 git@github.com:OCA/account-financial-reporting.git .third-party/OCA/account-financial-reporting

# Add your first module
ln -s .third-party/OCA/account-financial-reporting/some_module ./some_module
```
*Apik generic modules, treated like any third party*
```bash
# Add the repository
git submodule add --name apikcloud/apik-addons -b 18.0 git@github.com:apikcloud/apik-addons.git .third-party/apikcloud/apik-addons

# Then, add your first module
ln -s .third-party/apikcloud/apik-addons/apik_generic_module ./apik_generic_module
```
The best practice is to make a dedicated (technical) commit when adding the submodule and the first symlink(s).
Modifying requirements, updating the README, or editing the changelog can be done in another commit.

The commit message can be supplemented with a description in its long version:

```bash
git commit -m "chore(submodules): add submodule <submodule name>
- url: <url>
- branch: <branch>
- path: <path>
- created symlinks: <symlinks>
"
```

### Using Pull Requests as Submodule Sources

In some cases, for example, when a new version of Odoo is released, you may need to include a module from a **pull request** (not yet merged).  
To do this, you must use the branch and the original repository of the PR (the fork in the case of the OCA).  

The rule is, 
* for the name: `PRs/<owner>/<repository>/<addon>`  
* for the path: `.third-party/PRs/<owner>/<repository>/<addon>`  

Where `<addon>` is the name of the first module you are adding.  
In the case of OCA, most PRs contain only one module.

```bash
# Example for adding the project_key module from the PR https://github.com/OCA/project/pull/1623
git submodule add --name PRs/jdidderen/project/project_key -b 19.0-mig-project_key git@github.com:jdidderen/project.git .third-party/PRs/jdidderen/project/project_key
ln -s .third-party/PRs/jdidderen/project/project_key ./project_key
```

### Updating Submodules

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

### Removing Submodules

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

### Troubleshooting 

We know that submodules can sometimes be... temperamental.  
If you encounter any issues, particularly when changing branches, the trick is to delete the entire directory and restart the initialisation of the submodules.

```bash
rm -rf .third-party
git submodule update --init
```


## Odoo.sh Specific Cases

Odoo.sh **supports Git submodules in a hidden folder and symbolic links**. The same approach should be used, rather than the interface provided by the platform. This prevents build failures due to requirements present in submodules that are not automatically satisfied.


## Repository Compliance

This configuration may evolve; check the template regularly to ensure compliance.

**Rule**: Any developer contributing to the project must keep this structure intact and required files up to date.  
Divergences must be corrected through a **pull request** and will be reviewed by the Quality team.


## Access and Responsibilities

| Role | Responsibility |
|------|----------------|
| **Developer** | Maintains repository structure, submodule state, and symlinks. |
| **Technical Referent** | Validates structural consistency and module organization. |
| **Quality Team** | Ensures compliance with the repository template. |
| **DevOps Team** | Manages permissions, deployment automation. |
| **Project Manager (PM)** | Coordinates functional validation and client communication. |

All contributors — internal or external — must adhere to the same structure and validation pipeline.
