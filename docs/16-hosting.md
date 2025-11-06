# Hosting Solutions Overview

<mark> Status: Draft — Pending Review and Approval </mark>

> This page introduces the **execution platforms** supported at Apik and how our methodology adapts to each.
> It is an entry point only — detailed procedures live in dedicated pages (CI/CD, releases, workflow, odoo.sh specifics).

---

## Supported Platforms (at a glance)

| Platform | Who operates | How we ship | Where code runs | Image build | Trunk-based notes |
|---------|---------------|-------------|-----------------|-------------|-------------------|
| **Apikcloud (managed)** | Apik | Docker image per project | Kubernetes/containers | **Yes** (CI builds client image) | Standard trunk-based |
| **On‑premise (customer)** | Customer (with Apik support) | Docker image per project, delivered as artifact | Customer’s infra (VM, Docker host, k8s) | **Yes** (same as Cloud) | Standard trunk-based |
| **Odoo.sh** | Odoo | Git repository only | Odoo.sh platform | **No** (platform builds & runs) | Slight adaptation (detailed elsewhere) |

---

## Image Strategy (Cloud & On‑Premise)

For **Apik Cloud** and **on‑premise** deployments, we ship a **self‑contained Docker image** per project:

- The **base Odoo image** is selected by `odoo_version.txt` (major version, e.g. `18.0`).
- CI builds the **client image** by layering project code and third‑party modules on top of the selected base.
- The resulting image is **tagged by version** and promoted from staging → preproduction → production.
- We keep build logs and image digests for **traceability and rollback**.

**Key benefits**
- Identical artifact for staging and production (**reproducibility**).
- Zero dependency on external networks at deploy time (**reliability**).
- Clear separation between base Odoo and project code (**maintainability**).
- Binaries and Python dependencies are included in the image (**stability**).

> The same image build process is used for **on‑premise**. We provide the Docker image (and compose/k8s manifests if needed), the customer deploys it in their environment.

---

## Base Image Selection

`odoo_version.txt` drives the **base Odoo version** used by CI:

```
apik/odoo:18.0-<release-date>-<enterprise>
```

- This value pins the **base image line** (e.g., `apik/odoo:18.0-20251015-enterprise`).
- Major upgrades are handled like migrations: update `odoo_version.txt`, run validations, and follow `MIGRATIONS.md`.
- Security updates to the base image are published regularly; projects **inherit** them on rebuild.



## CI/CD Overview (Cloud & On‑Premise)

1. **Build**: assemble the client image (install Python requirements, vendor third‑party code via submodules/symlinks).
2. **Test**: run lint, unit/integration tests, basic Odoo startup with `--stop-after-init`.
3. **Tag & Push**: tag image with `vX.Y.Z` and Git SHA; push to registry.
4. **Deploy**: staging auto‑deploy from `main`; preprod/prod deploys from **tags** (see `RELEASES.md`).
5. **Promote**: same image digest flows across environments.

**Image naming (example)**
```
apik/odoo-{client project}:main
apik/odoo-{client project}:v1.5.0
```



## Odoo.sh Specifics (high‑level)

On **Odoo.sh**, we do **not build Docker images**. The platform pulls the repository and builds/runs the code internally.

Methodology adjustments (details in the dedicated Odoo.sh page):
- **No image artifact**: validation relies on Odoo.sh pipelines and environments.
- **Submodules & symlinks**: supported, but must be resolvable at build time; keep the `/.third-party` + symlink pattern.
- **Trunk‑based adaptation**: shorter‑lived branches, explicit promotion (dev → staging → production) using the platform’s tools.
- **Release notes & migrations**: still mandatory (`CHANGELOG.md`, `MIGRATIONS.md`), but deployment is triggered on the platform.

> The engineering principles remain the same (review, changelog, migrations). Only the **delivery mechanism** differs.



## Responsibilities

| Role | Cloud / On‑Prem | Odoo.sh |
|------|------------------|---------|
| **Developer** | Builds run locally, fixes CI, maintains submodules/symlinks | Same; ensure Odoo.sh build passes |
| **Technical Referent** | Validates image readiness; approves release promotion | Validates branch readiness; approves platform promotion |
| **Quality Team** | Ensures template compliance, tests, and standards | Same |
| **DevOps / Hosting** | Operates registry, deploys/stabilizes environments | N/A (platform operated by Odoo) |
| **Project Manager** | Requests release, defines scope, coordinates delivery | Same |



## Policy Summary

- **One artifact per release** (Cloud/On‑Premise): the Docker image is the unit of delivery.
- **`odoo_version.txt` is the source of truth** for the base image line.
- **Trunk‑based workflow applies everywhere**; on Odoo.sh it is **lightly adapted** but still requires review, changelog, and release discipline.
- **Documentation is mandatory**: `CHANGELOG.md`, `MIGRATIONS.md`, and release approval by the **Technical Referent**.
