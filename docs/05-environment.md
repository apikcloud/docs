<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 05-environment
Project: aikcloud/docs
Last update: 2025-12-08
Status: Draft
Reviewer: 
-->

# Environment Setup

<mark> Status: Draft — Pending Review and Approval </mark>

> This document provides guidelines for setting up the development environment for Apik projects.

## Getting Started (Developers)

### Prerequisites
- Git ≥ 2.40 with submodule support
- Docker / Docker Compose
- Python 3.11 (for tooling), `pip`
- (Optional) VS Code + Dev Containers extension


### Startkit

A starterkit repository is available to quickly bootstrap the development environment: https://github.com/apikcloud/starterkit.

### Clone & bootstrap
```bash
# Clone the project
git clone git@github.com:apikcloud/<repo>.git <path>
cd <path>

# Pull third‑party code
git submodule update --init --recursive

# Install pre-commit hooks
pip install -U pre-commit
pre-commit install
```

### Dev container (upcoming)
Open the folder in VS Code and **Reopen in Container**. Tooling and linters are preconfigured.

### Run Odoo locally (minimal)
Use the project’s Docker compose or helper scripts if provided. Example:
```bash
# Example only — adjust to your project scripts
docker compose up -d
docker compose logs -f odoo
```

> Third‑party addons are included as **submodules** in `/.third-party` and exposed via **symlinks at the repository root**. Anything at the root is visible to Odoo; no need to edit `addons_path`.

### Commit rules (must‑read)
- Conventional Commits; see [`docs/09-commits.md`](./docs/09-commits.md)
- One PR per feature; code review required; see [`docs/12-code-review.md`](./docs/12-code-review.md)
- Keep changelog human‑written; see [`docs/10-changelog.md`](./docs/10-changelog.md)

