<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 11-migrations
Project: apikcloud/docs
Last update: 2026-10-05
Status: Draft
Reviewer: 
-->

# Migrations Guide

<mark> Status: Draft — Pending Review and Approval </mark>

> This document defines how we document and execute **migrations** between releases at Apik.  
>
> Migrations are critical transitions — they must be **predictable, reversible, and auditable**.


## Purpose & Scope

This guide covers:
- data structure changes between releases,
- dependency updates (Python, addons, Docker image, etc.),
- and post-deployment operations affecting production data.

It does **not** replace the technical SOPs for backups or CI/CD execution,  
but documents the *functional and technical steps* required to ensure a safe transition.



## Principles

- **One migration = one documented process.**
- **Reproducibility first:** every step must be executable on preproduction before production.
- **No hidden logic:** if it’s not in the changelog or in `migrate.sh`, it doesn’t exist.
- **Automation when possible**, documentation always.
- **Rollback ready:** any destructive action must include a rollback or safety note.



## When to Document a Migration

A migration must be documented when:
- the **data model** changes (fields, constraints, model rename),
- a **manual SQL or server action** is needed,
- a **module rename, merge, or removal** occurs,
- a **new dependency** or **external service** is introduced,
- **environment variables** or **server parameters** change,
- or **functional testing** is required before reactivation.

A migration is documented in two places:

| Where | What |
| --- | --- |
| `CHANGELOG.md` — **Migration Notes** of the release | What changes, why, and the manual or functional steps (see [Changelog](./10-changelog.md)) |
| `migrate.sh` (project root) | The commands to run, in order, including manual SQL |


## Migration Notes (CHANGELOG)

Developers draft Migration Notes under `## [Unreleased]` during development, like any other changelog entry.
They follow the changelog [writing rules](./10-changelog.md): one line per item, short and explicit.

Write in Migration Notes:
- what changes and why (e.g. field renamed, module removed, new server parameter),
- manual steps that cannot be scripted (configuration, server action to run, data to check),
- functional tests required before reactivation,
- rollback or safety notes for destructive actions.

Example:

```markdown
### Migration Notes
- Update `sale_custom` and `stock_custom` (commands in `migrate.sh`).
- Set the new system parameter `sale_custom.max_discount` (default: 20) after the update.
- Destructive: archived delivery methods are deleted; backup required before running `migrate.sh`.
```


## Migration Command Script (`migrate.sh`)

Each release with a migration must include an executable `migrate.sh` script at the project root,
containing the list of commands to be used, most often the installation or update of modules.
This script acts as the canonical reference for what has been executed in preproduction and production.

These commands are intentionally **human-maintained**, not generated automatically.

`migrate.sh` only contains the commands of the **next release**:
- The commands of a release stay in the script after the release tag, so the tagged version is deployable.
- The first developer who adds a command for the next release replaces the previous commands instead of appending:
  if `migrate.sh` has not changed since the last release tag (`git diff <last tag> -- migrate.sh` is empty),
  its commands belong to the previous release.
- The commands of each release remain available in its tag.

Example template:

```bash
#!/usr/bin/env bash
# MIGRATION COMMANDS — run sequentially on preproduction, then on production.

odoo --stop-after-init --no-http -i <module_x>
odoo --stop-after-init --no-http --i18n-overwrite -u <module_y>,<module_z>
```

Guidelines:
- Always include the exact commands used for **preproduction** and **production** runs.
- Each command should be **copy-paste ready** and executable in the deployment environment.
- Use the `--stop-after-init` and `--no-http` flags to prevent server startup during upgrades.
- Prefer one command per module for clarity and rollback tracking.
- Manual SQL also goes in `migrate.sh`, as copy-paste ready commands, with a comment explaining why.
- Validate the same command sequence in preproduction before applying it to production.


## Migration Procedure

Applies to every release that contains a migration.

### Pre-migration Checklist
- [ ] Backup verified
- [ ] Preproduction updated and validated
- [ ] Rollback plan defined
- [ ] Required modules available
- [ ] Communication with PM scheduled

### Execution
1. Stop cron jobs on the instance.
2. Run `migrate.sh` (preproduction first, then production).
3. Apply the manual steps listed in the Migration Notes.
4. Clear caches and restart Odoo.

### Post-migration Actions
- [ ] Rebuild mail index
- [ ] Reassign activities
- [ ] Revalidate scheduled actions
- [ ] Test core features (as listed in the Migration Notes)

### Rollback Procedure
Restore from backup or undo a partial migration, following the rollback notes of the Migration Notes.

### Validation
The migration is considered complete when:
- Data integrity is verified,
- No blocking errors remain in logs,
- Functional tests have passed,
- The **Technical Referent** validates the release.


## Roles

| Role                     | Responsibility                                          |
| ------------------------ | ------------------------------------------------------- |
| **Developer**            | Writes and tests migration steps and commands locally   |
| **Technical Referent**   | Reviews and approves the migration procedure            |
| **Project Manager (CP)** | Validates functional readiness and client communication |
| **Hosting Team**         | Executes migrations on staging and production           |


## Tips for Odoo Projects

- Always test migrations on a **copy of the production database**.
- Use `--stop-after-init` to perform schema upgrades safely.
- For large data updates, prefer **server actions or SQL batches** with commit checkpoints.
- If custom addons modify `ir.model.fields`, export before migration.
- Record migration duration and anomalies in an internal note.
