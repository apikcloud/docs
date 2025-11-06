# Release Management Guidelines

<mark> Status: Draft — Pending Review and Approval </mark>

> This document defines **when and how we create, validate, and deliver releases** across environments.  
> It complements workflow, code review, and migrations.
> 
> Releases are the formal milestones of a project — they ensure traceability, stability, and reproducibility.


## Purpose

The goal of the release process is to:
- deliver new features and fixes **safely and predictably**,
- maintain full **traceability** between code, tickets, and deployments,
- provide clear **versioning** for each environment (staging, preproduction, production),
- ensure that the **Technical Referent** has validated every release before delivery,
- allow **controlled inclusion or exclusion** of features requested by the Project Manager.


## Release Strategy

### Branching Model
We follow a **trunk-based workflow**:
- All validated features are merged into `main`.
- The `main` branch is continuously deployable to **staging**.
- Each release is a **Git tag** on `main`:
  - `vX.Y.Z` (semantic versioning)
  - Example: `v1.4.0`

### Environments
| Environment | Source | Purpose |
|--------------|---------|----------|
| **Staging** | `main` branch (auto-deployed) | Internal validation of merged work |
| **Preproduction** | Tagged release | Validation before client delivery |
| **Production** | Tagged release (validated in preprod) | Live system |


## Release Frequency

Releases are created:
- **On demand**, when a Project Manager requests delivery.
- **After validation** of all merged features by the Technical Referent.
- Optionally, **periodically** (e.g. monthly) for maintenance projects.

Rules of thumb:
- Let staging stabilize for at least one validation cycle before tagging.
- One release per day maximum per project to keep history traceable and reversible.


## Selective or Partial Releases

Sometimes, a Project Manager may request to:
- **Exclude specific features** that are not yet functionally validated, or
- **Delay** part of the work while still delivering other features.

### During Preproduction Delivery
When preparing the release:
- The Technical Referent identifies the list of features (tickets) to include.
- If some features must be **excluded**, they can be temporarily **reverted** or **cherry-picked out** before tagging.
- The excluded work remains in `main` but will appear in a later release once validated.

### During Production Delivery
If a feature validated in preproduction is **later refused by the client**:
- A **new release** must be created from the previous validated tag.
- Only the **validated features** are cherry-picked.
- This new tag (e.g. `v1.5.1`) becomes the **production release**, while the unvalidated work stays in staging until confirmation.

All inclusions/exclusions must be documented in:
- the **release description** (Git tag or release notes),
- the **CHANGELOG.md**, specifying which items were deferred.

Example:
```
## [v1.5.1] — Partial release
- Excluded: Partner Import Wizard (pending client validation)
- Included: Subscription price fix, Sale Order Template permissions
```


## Release Creation Process

### Step 1 — Prepare
1. Ensure the `main` branch is up to date and tests pass.
2. Review the `CHANGELOG.md`:
   - Each merged feature has an entry.
   - Migration notes are linked if needed.
3. Validate `MIGRATIONS.md` and command scripts if applicable.
4. Confirm with the Project Manager which tickets are to be included.

### Step 2 — Tag
From the local repo (Technical Referent or release manager):

```bash
git checkout main
git pull
git tag -a v1.5.0 -m "Release v1.5.0 — October 2025"
git push origin v1.5.0
```

For a selective release (excluding some commits):
```bash
git checkout -b release/v1.5.1
git cherry-pick <commit1> <commit2> <commit3>
git tag -a v1.5.1 -m "Release v1.5.1 — selective release"
git push origin v1.5.1
```


## Preproduction and Production Delivery

### Preproduction
- Deploy the tagged image to the preproduction environment.
- Run regression and acceptance tests.
- Validate key use cases with the Project Manager or QA.

### Production
- Deploy **only after approval** by both:
  - **Technical Referent** (technical readiness)
  - **Project Manager** (functional readiness)
- The same tag must be deployed; no untagged code should ever reach production.


## Rollback Policy

If a release causes a regression:
- Rollback to the previous tag:
  ```bash
  git checkout v1.4.0
  ```
- Redeploy the corresponding Docker image or container version.
- Document the issue and resolution in the next changelog.

Rollback safety depends on consistent use of backups and `MIGRATIONS.md` documentation.


## Tagging Rules

| Type | Example | Meaning |
|------|----------|----------|
| **Major** | `v2.0.0` | Incompatible or structural change |
| **Minor** | `v1.5.0` | Backward-compatible new features |
| **Patch** | `v1.5.1` | Fix or partial release (subset of features) |

Guidelines:
- Increment **minor** for functional additions.
- Increment **patch** for fixes or partial deliveries.
- Increment **major** after coordinated agreement across teams.


## Responsibilities

| Role | Responsibility |
|------|----------------|
| **Developer** | Updates changelog and migrations during development |
| **Technical Referent** | Validates code, builds the release, creates and pushes tags |
| **Project Manager (CP)** | Requests release, defines included/excluded scope, validates delivery |
| **Hosting Team** | Deploys preproduction and production environments |
| **QA (optional)** | Performs functional validation |


## Release Checklist

- [ ] All features merged and reviewed.
- [ ] Tests pass on staging.
- [ ] `CHANGELOG.md` and `MIGRATIONS.md` are complete.
- [ ] Scope of release confirmed with Project Manager.
- [ ] Tag created and pushed (`vX.Y.Z`).
- [ ] Preproduction validated.
- [ ] Technical and functional approval received.
- [ ] Production deployment executed.
- [ ] Any exclusions documented in the release note.


## Post-Release Actions

- Monitor logs and alerts for 48h post-deployment.
- Communicate the release summary internally.
- Create follow-up tickets for deferred features.
- Archive release artifacts and backups.
