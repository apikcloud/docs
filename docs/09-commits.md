# Commit Guidelines

<mark> Status: Draft — Pending Review and Approval </mark>

> Commits are the smallest and most meaningful unit of change.  
> They tell *why* the code exists, not just *what* was changed.

## Message Convention

We follow the **[Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)** specification to keep
messages consistent and automatable.

### Syntax

```
<type>(optional scope): <short summary>

[optional body]

[optional footer(s)]
```

**Example**

```
feat(account): add invoice merge wizard

This introduces a new wizard allowing users to merge multiple draft invoices.
Closes #1234
```

## Types

| Type         | Meaning                                             | Example                                                |
|--------------|-----------------------------------------------------|--------------------------------------------------------|
| **feat**     | New feature                                         | `feat(mail): support DKIM signature`                   |
| **fix**      | Bug fix                                             | `fix(project): avoid crash on archived tasks`          |
| **refactor** | Internal code change without changing behavior      | `refactor(base): simplify partner search domain`       |
| **docs**     | Documentation change                                | `docs: add deployment workflow diagram`                |
| **style**    | Code style, formatting, missing commas, etc.        | `style(account): reformat import wizard`               |
| **test**     | Add or update tests                                 | `test(project): add regression test for task stages`   |
| **chore**    | Maintenance or tooling                              | `chore(ci): upgrade pre-commit hooks`                  |
| **build**    | Changes to build system, dependencies, Docker, etc. | `build(docker): bump Python base image`                |
| **perf**     | Performance improvement                             | `perf(account): optimize reconciliation lookup`        |
| **ci**       | CI/CD config or scripts                             | `ci(github): parallelize test workflow`                |
| **revert**   | Revert a previous commit                            | `revert: fix(account): wrong domain in partner search` |
| **release**  | Prepare for a new release                           | `release: v1.2.0`                                      |

## Scopes

The **scope** indicates which part of the system is affected — it’s optional but useful when:

- The project is large or modular (ex: Odoo addons, CI, Docker, infra).
- You want to filter commits in changelogs by area.

**Typical scopes**

```
account, project, mail, base, docker, ci, infra, tests, docs
```

## Content Rules

- One logical change per commit (**atomic commits**).
- Keep the first line under **72 characters**.
- Explain *why* when the reason isn’t obvious.
- Avoid vague messages like “update”, “fix issue”, “stuff”.
- Reference the related ticket if applicable:
  ```
  feat: add mail alias sync [#1234]
  ```
- Before merging, **squash or rebase** to keep a clean linear history.

## Tips

- Keep the summary short and clear.
- Use the body to describe context or motivation if needed.
- Reference issues or tickets with `Closes #1234` or `[AP-456]`.
- Avoid meaningless messages (“update”, “minor change”, “final”).
- Consistency is more valuable than perfection.

## Why It Matters

Readable history = faster reviews, clearer changelogs,  
and easier troubleshooting.  
Every commit is a breadcrumb for future developers — leave them useful ones.
