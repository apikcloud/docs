<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 09-commits
Project: aikcloud/docs
Last update: 2025-12-08
Status: Draft
Reviewer:
-->

# Directives pour commit

<mark> Status: Draft — Pending Review and Approval </mark>

> Les commits constituent l'unité de changement la plus petite et la plus significative.<br> Ils expliquent *pourquoi* le code existe, et pas seulement *ce qui* a été modifié.

## Message Convention

We follow the **[Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)** specification to keep messages consistent and automatable.

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

Type | Meaning | Example
--- | --- | ---
**feat** | New feature | `feat(mail): support DKIM signature`
**fix** | Bug fix | `fix(project): avoid crash on archived tasks`
**refactor** | Modification interne du code sans changement de comportement | `refactor(base): simplify partner search domain`
**docs** | Documentation change | `docs: add deployment workflow diagram`
**style** | Code style, formatting, missing commas, etc. | `style(account): reformat import wizard`
**test** | Add or update tests | `test(project): add regression test for task stages`
**chore** | Maintenance or tooling | `chore(ci): upgrade pre-commit hooks`
**build** | Modifications apportées au système de build, aux dépendances, à Docker, etc. | `build(docker): bump Python base image`
**perf** | Performance improvement | `perf(account): optimize reconciliation lookup`
**ci** | CI/CD config or scripts | `ci(github): parallelize test workflow`
**revert** | Revert a previous commit | `revert: fix(account): wrong domain in partner search`
**release** | Préparer une nouvelle release | `release: v1.2.0`

## Champ d'application

The **scope** indicates which part of the system is affected — it’s optional but useful when:

- Le projet est vaste ou modulaire (ex : modules Odoo, CI, Docker, infrastructure).
- Vous souhaitez filtrer les commits dans les changelogs par domaine.

**Portées typiques**

```
account, project, mail, base, docker, ci, infra, tests, docs
```

## Content Rules

- Une modification logique par commit (**commits atomiques**).
- Keep the first line under **72 characters**.
- Explain *why* when the reason isn’t obvious.
- Évitez les messages vagues comme « update », « fix issue », « stuff ».
- Reference the related ticket if applicable:
    ```
    feat: add mail alias sync [#1234]
    ```
- Before merging, **squash or rebase** to keep a clean linear history.

## Tips

- Keep the summary short and clear.
- Use the body to describe context or motivation if needed.
- Reference issues or tickets with `Closes #1234` or `[AP-456]`.
- Évitez les messages sans signification (« update », « minor change », « final »).
- La constance est plus importante que la perfection.

## Why It Matters

Un historique lisible = des reviews plus rapides, des changelogs plus clairs et un dépannage plus facile.<br>Chaque commit est un fil conducteur pour les futurs développeurs — faites-en des utiles.
