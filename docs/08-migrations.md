# 8. Migrations Guide

<mark> Status: Draft — Pending Review and Approval </mark>

> This document defines how we document and execute **migrations** between releases at Apik.  
>
> Migrations are critical transitions — they must be **predictable, reversible, and auditable**.


## 1. Purpose & Scope

This guide covers:
- data structure changes between releases,
- dependency updates (Python, addons, Docker image, etc.),
- and post-deployment operations affecting production data.

It does **not** replace the technical SOPs for backups or CI/CD execution,  
but documents the *functional and technical steps* required to ensure a safe transition.



## 2. Principles

- **One migration = one documented process.**
- **Reproducibility first:** every step must be executable on preproduction before production.
- **No hidden logic:** if it’s not written here, it doesn’t exist.
- **Automation when possible**, documentation always.
- **Rollback ready:** any destructive action must include a rollback or safety note.



## 3. When to Document a Migration

A `MIGRATION.md` entry is required when:
- the **data model** changes (fields, constraints, model rename),
- a **manual SQL or server action** is needed,
- a **module rename, merge, or removal** occurs,
- a **new dependency** or **external service** is introduced,
- **environment variables** or **server parameters** change,
- or **functional testing** is required before reactivation.


## 4. Structure of a Migration Entry

Each migration is grouped by target version:

```markdown
## [vX.Y.Z] — YYYY-MM-DD

### Summary
Short overview of what the migration does and why it exists.

### Pre-migration Checklist
- [ ] Backup verified
- [ ] Preproduction updated and validated
- [ ] Rollback plan defined
- [ ] Required modules available
- [ ] Communication with PM scheduled

### Steps
1. Stop cron jobs on the instance.
2. Upgrade affected modules in order:
   - account
   - stock
   - sale
   - custom_module
   
3. Run manual SQL commands:

   UPDATE account_move SET state='draft' WHERE ...;
   
4. Clear caches and restart Odoo.
```

### Migration Command Script

Each migration must include an executable `migrate.sh` script containing the list of commands to be used, most often the installation or update of modules.
This script acts as the canonical reference for what has been executed in preproduction and production.

These commands are intentionally **human-maintained**, not generated automatically.

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
- Validate the same command sequence in preproduction before applying it to production.

### Post-migration Actions
- [ ] Rebuild mail index
- [ ] Reassign activities
- [ ] Revalidate scheduled actions
- [ ] Test core features (list them)

### Rollback Procedure
Explain how to restore from backup or undo a partial migration.

### Validation
The migration is considered complete when:
- Data integrity is verified,
- No blocking errors remain in logs,
- Functional tests have passed,
- The **Technical Referent** validates the release.


## 5. Roles

| Role | Responsibility |
|------|----------------|
| **Developer** | Writes and tests migration steps locally |
| **Technical Referent** | Reviews and approves the migration procedure |
| **Project Manager (CP)** | Validates functional readiness and client communication |
| **Hosting Team** | Executes migrations on staging and production |


## 6. Location and Versioning

- The file `MIGRATION.md` lives at the project root.  
- Each release with a migration must include its own section.
- Never rewrite or delete a past migration — add a new one instead.
- The changelog links to this file when migration steps are required.

Example in `CHANGELOG.md`:
```markdown
### Migration Notes
See detailed steps in [MIGRATION.md](./MIGRATION.md) for v1.5.0.
```


## 7. Tips for Odoo Projects

- Always test migrations on a **copy of the production database**.
- Use `--stop-after-init` to perform schema upgrades safely.
- For large data updates, prefer **server actions or SQL batches** with commit checkpoints.
- If custom addons modify `ir.model.fields`, export before migration.
- Record migration duration and anomalies in an internal note.
