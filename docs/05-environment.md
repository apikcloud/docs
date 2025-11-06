# Environment Setup

<mark> Status: Draft — Pending Review and Approval </mark>

> This document provides guidelines for setting up the development environment for Apik projects.

## Getting Started (Developers)

### Prerequisites
- Git ≥ 2.40 with submodule support
- Docker / Docker Compose
- Python 3.11 (for tooling), `pip`
- (Optional) VS Code + Dev Containers extension

### Clone & bootstrap
```bash
# Clone the project
git clone git@github.com:apikcloud/client-repo.git
cd client-repo

# Pull third‑party code
git submodule update --init --recursive

# Install pre-commit hooks
pip install -U pre-commit
pre-commit install
```

### Dev container (recommended)
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
- Conventional Commits; see [`docs/06-commits.md`](./docs/06-commits.md)
- One PR per feature; code review required; see [`docs/XX-code-review.md`](./docs/XX-code-review.md)
- Keep changelog human‑written; see [`docs/07-changelog.md`](./docs/07-changelog.md)

