<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 09-commits
Project: apikcloud/docs
Last update: 2026-10-05
Status: Draft
Reviewer: 
-->

# Commit Guidelines

<mark> Status: Draft — Pending Review and Approval </mark>

> Commits are the smallest meaningful unit of change.
> They tell *why* the code exists, not just *what* changed.

We follow **[Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)**.
Any commit not following this convention will be rejected.

## Format

```
<type>(<scope>): <summary> [#task]

[optional body]
```

**Example**

```
feat(account): add invoice merge wizard [#123456]

Allows users to merge multiple draft invoices into a single one.
```

**Rules**

- Lowercase only, except acronyms and code names (`UI`, `DKIM`, `API`).
- No trailing period, no trailing whitespace.
- First line under **72 characters**.
- Task reference between brackets, preceded by a hash: `[#123456]`.
  Required for `feat` and `fix`. Not used for `chore`: maintenance has no task, and a release
  can bundle several features. For other types, add it when a task exists.

## Types

As a developer, you'll mostly use `feat`, `fix` and `chore`.

| Type         | Use for                                                     | Example                                                         |
| ------------ | ----------------------------------------------------------- | --------------------------------------------------------------- |
| **feat**     | New feature or performance improvement                      | `feat(account): optimize reconciliation lookup [#12345]`        |
| **fix**      | Bug fix                                                     | `fix(project): avoid crash on archived tasks [#12345]`          |
| **chore**    | Releases, formatting, style, maintenance, any change with no functional impact | `chore: release v1.2.0`                      |
| **refactor** | Internal code change without behavior change                | `refactor(base): simplify partner search domain`                |
| **test**     | Add or update tests                                         | `test(project): add regression test for task stages`            |
| **docs**     | Documentation only                                          | `docs: add deployment workflow diagram`                         |
| **ci**       | CI/CD, build system, dependencies, Docker                   | `ci(docker): bump Python base image`                            |
| **revert**   | Revert a previous commit                                    | `revert: fix(account): wrong domain in partner search [#12345]` |

### Releases

A release (version bump, changelog, release notes) is a `chore` commit, without task reference
since it can contain several features:

```
chore: release vX.Y.Z
```

### Formatting and other non-functional changes

Formatting, code style, linting fixes, submodule URLs and similar changes are also `chore`:

```
chore(account): reformat import wizard
chore: update pre-commit hooks
chore(submodules): fix submodule URLs
```

## Scopes

The scope is **optional** but recommended. On Odoo projects, use the module technical name
(`account`, `project`, `mail`, `mrp`, `helpdesk`, `crm`) or the technical area (`ci`, `docker`, `infra`, `tests`).

If you don't know which scope to use, leave it out.

## Content

- One logical change per commit (**atomic commits**).
- Avoid vague messages: "update", "fix issue", "minor change", "final".
- Use the body to explain *why* when it isn't obvious, and to highlight technical details useful to other developers.
- Before merging, **squash or rebase** to keep a linear history.

Consistency is more valuable than perfection: readable history means faster reviews,
clearer changelogs and easier troubleshooting.
