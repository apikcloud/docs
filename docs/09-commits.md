<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 09-commits
Project: apikcloud/docs
Last update: 2026-02-05
Status: Draft
Reviewer: 
-->

# Commit Guidelines

<mark> Status: Draft — Pending Review and Approval </mark>

> Commits are the smallest and most meaningful unit of change.  
> They tell *why* the code exists, not just *what* was changed.

## Message Convention

We follow the **[Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)** specification to keep
messages consistent and automatable.

### Syntax

```
<type>(optional scope): <short summary> [#task]

[optional body]
```

**Example**

```
feat(account): add invoice merge wizard [#123456]

This introduces a new wizard allowing users to merge multiple draft invoices.
```

A commit does not have uppercase, no dot (.) at the end, and no trailing whitespace. Plus, the task identifier should
be written between brackets and preceded by a hash (#).  
Any commit not following this convention will be rejected.

The only exception is when you use acronyms or code names, which should be written in uppercase. For example:

```
chore(submodules) fix submodules URLs

feat: add new UI for the project dashboard [#123456]
```

## Types

The main types you should use are listed below. As developer, you'll mostly use the following: `feat`, `fix`, `release`.

| Type         | Meaning                                             | Example                                                         |
|--------------|-----------------------------------------------------|-----------------------------------------------------------------|
| **feat**     | New feature                                         | `feat(mail): support DKIM signature [#12345]`                   |
| **fix**      | Bug fix                                             | `fix(project): avoid crash on archived tasks [#12345]`          |
| **release**  | Prepare for a new release                           | `release: v1.2.0 [#12345]`                                      |
| **style**    | Code style, formatting, missing commas, etc.        | `style(account): reformat import wizard [#12345]`               |
| **revert**   | Revert a previous commit                            | `revert: fix(account): wrong domain in partner search [#12345]` |
| **test**     | Add or update tests                                 | `test(project): add regression test for task stages [#12345]`   |
| **refactor** | Internal code change without changing behavior      | `refactor(base): simplify partner search domain [#12345]`       |
| **docs**     | Documentation change                                | `docs: add deployment workflow diagram [#12345]`                |
| **chore**    | Maintenance or tooling                              | `chore(ci): upgrade pre-commit hooks [#12345]`                  |
| **ci**       | CI/CD config or scripts                             | `ci(github): parallelize test workflow [#12345]`                |
| **perf**     | Performance improvement                             | `perf(account): optimize reconciliation lookup [#12345]`        |
| **build**    | Changes to build system, dependencies, Docker, etc. | `build(docker): bump Python base image [#12345]`                |

## Scopes

The **scope** indicates which part of the system is affected — it's **optional** but highly recommended as it is useful when:

- The project is large or modular (ex: Odoo addons, CI, Docker, infra).
- You want to filter commits by area.

> **Note**: In case you don't know what scope to use, prefer **not** to use one.

**Typical scopes**

```
account, project, mail, mrp, helpdesk, crm, ci, infra, docker, tests, docs
```

## Content Rules

- One logical change per commit (**atomic commits**).
- Keep the first line under **72 characters**.
- Explain *why* when the reason isn’t obvious.
- Highlight important technical details when it is needed.
- Avoid vague messages like “update”, “fix issue”, “stuff”.
- Reference the related task if applicable:
  ```
  feat: add mail alias sync [#12345]
  ```
- Before merging, **squash or rebase** to keep a clean linear history.

## Tips

- Keep the summary short and clear.
- Use the body to describe context or motivation if needed.
- Use the body to highlight technical details that could help other developers.
- Avoid meaningless messages (“update”, “minor change”, “final”).
- Consistency is more valuable than perfection.

## Why It Matters

Readable history = faster reviews, clearer changelogs,  
and easier troubleshooting.  
Every commit is a breadcrumb for future developers — leave them useful ones.
