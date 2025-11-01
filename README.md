
:::conflict{variant=a}
:::

:::conflict{variant=d}
<p align="center">
  <img src="https://raw.githubusercontent.com/apikcloud/docs/main/docs/_media/logo.png" alt="Apik Logo" width="180">
</p>
:::


:::conflict{variant=a}
:::conflict{variant=a}
# Documentation développeur
:::
:::

:::conflict{variant=d}
<p align="center">
  <img src="https://raw.githubusercontent.com/apikcloud/docs/main/docs/_media/compass.png" alt="Compass" width="500">
</p>
:::


:::conflict{variant=a}
:::conflict{variant=d}
# Apik Engineering Documentation
:::
:::

:::conflict{variant=d}
<p align="center">
  <a href="https://github.com/apikcloud/docs/actions"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/apikcloud/docs/ci.yml?label=CI"></a>
  <a href="./LICENSE"><img alt="License" src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
  <a href="./docs"><img alt="Docs" src="https://img.shields.io/badge/docs-available-brightgreen"></a>
</p>
:::


:::conflict{variant=a}
All engineering documentation for Apik lives in `/docs`. This README is a concise entry point.
:::

:::conflict{variant=d}
---
:::


:::conflict{variant=a}
> **Working language:** All code, comments, commit messages, and documentation are written in **English**.
:::

:::conflict{variant=d}
## Overview
:::


:::conflict{variant=a}
<p align="left">
  <a href="https://github.com/apikcloud/docs/actions"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/apikcloud/docs/ci.yml?label=CI"></a>
  <a href="./LICENSE"><img alt="License" src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
  <a href="./docs"><img alt="Docs" src="https://img.shields.io/badge/docs-available-brightgreen"></a>
</p>
:::

:::conflict{variant=d}
This repository hosts **Apik’s internal engineering documentation** — our shared technical foundation for all teams.  
It defines our **development standards**, **workflows**, **tooling**, and **infrastructure guidelines**, ensuring coherence and quality across projects.
:::


:::conflict{variant=a}
---
:::

:::conflict{variant=d}
The full documentation lives in the `/docs` directory and is automatically deployed to GitHub Pages at:  
👉 [https://apikcloud.github.io/docs/](https://apikcloud.github.io/docs/)
:::


:::conflict{variant=a}
## Core Documentation
:::

:::conflict{variant=d}
---
:::


:::conflict{variant=a}
1. [`Introduction`](docs/01-introduction.md) — overall principles and expectations  
2. [`Engineering Philosophy`](docs/02-philosophy.md) — values and long‑term commitments  
3. [`Platforms`](docs/03-platforms.md) — Apik Cloud, On‑Premise, Odoo.sh overview  
4. [`Project Organization`](docs/04-organization.md) — repo layout, submodules, symlinks, required files  
5. [`Workflow`](docs/05-workflow.md) — trunk-based development, branches, merges, releases  
6. [`Commits`](docs/06-commits.md) — Conventional Commits, content rules  
7. [`Changelog`](docs/07-changelog.md) — Keep a Changelog, ticket references, structure  
8. [`Migrations`](docs/08-migrations.md) — procedures, command script, validation & rollback  
:::

:::conflict{variant=d}
## Philosophy
:::


:::conflict{variant=a}
---
:::

:::conflict{variant=d}
Every developer should be able to understand, extend, or debug any Apik project without friction.  
This documentation captures our collective know-how and evolves continuously through collaboration.
:::


:::conflict{variant=a}
## Module Guidelines
:::

:::conflict{variant=d}
---
:::


:::conflict{variant=a}
Guidance specific to Odoo addons lives under `docs/XX-module/`. Some parts are stabilized, others are still drafted.
:::

:::conflict{variant=d}
## Working Language
:::


:::conflict{variant=a}
- **Naming** → [`docs/XX-module/01-naming.md`](docs/XX-module/01-naming.md)  
- **Structure** → [`docs/XX-module/02-structure.md`](docs/XX-module/02-structure.md)  
- **Manifest** → [`docs/XX-module/03-manifest.md`](docs/XX-module/03-manifest.md)  
- **Models** → [`docs/XX-module/04-models.md`](docs/XX-module/04-models.md)  
- **Fields** → [`docs/XX-module/05-fields.md`](docs/XX-module/05-fields.md)  
- **Methods** → [`docs/XX-module/06-methods.md`](docs/XX-module/06-methods.md)  

Examples:  
- [`docs/XX-module/examples/01-examples.md`](docs/XX-module/examples/01-examples.md)  
- [`docs/XX-module/examples/02-examples.md`](docs/XX-module/examples/02-examples.md)

Drafts to be finalized:  
- **Assets / JS / OWL** → [`docs/XX-module/XX-assets-js-owl.md`](docs/XX-module/XX-assets-js-owl.md)  
- **Checklist** → [`docs/XX-module/XX-checklist.md`](docs/XX-module/XX-checklist.md)  
- **Documentation** → [`docs/XX-module/XX-documentation.md`](docs/XX-module/XX-documentation.md)  
- **References** → [`docs/XX-module/XX-references.md`](docs/XX-module/XX-references.md)  
- **Security** → [`docs/XX-module/XX-security.md`](docs/XX-module/XX-security.md)  
- **Translations** → [`docs/XX-module/XX-translations.md`](docs/XX-module/XX-translations.md)  
- **UI / UX** → [`docs/XX-module/XX-ui-ux.md`](docs/XX-module/XX-ui-ux.md)  
- **Unit tests** → [`docs/XX-module/XX-unit-tests.md`](docs/XX-module/XX-unit-tests.md)  
- **Views** → [`docs/XX-module/XX-views.md`](docs/XX-module/XX-views.md)

---

## Contributing

- This documentation is a **living reference**. Contributions are welcome via **Pull Request**.  
- Changes are reviewed by the **Quality team** and may involve the **Technical Referent**.  
- Keep edits **concise, consistent, and in English**. Reference tickets in commit messages when relevant.

:::

:::conflict{variant=d}
All documentation, code comments, and commit messages are written in **English**.  
French versions are generated automatically for internal readability when needed.

---

## Structure

- `/docs` — Core documentation (development, workflow, CI/CD, quality, infrastructure, etc.)  
- `/docs/_media` — Shared assets (logos, diagrams, images)  
- `/docs/_sidebar.md` — Documentation sidebar structure
- `/docs/index.html` — [Docsify](https://docsify.js.org/) configuration for live rendering
- `/docs/DOCUMENTATION.md` — Aggregated documentation (auto-generated, do not edit manually)
- `/scripts` — Automation scripts for translation and aggregation
- `.github/workflows` — CI pipelines for translation, validation, and aggregation

The old `_module/` folder has been merged into a single file: `10-module.md`.

---

## Automation

Two main GitHub Actions maintain the documentation:

| Workflow | Description |
|-----------|--------------|
| **Translate** | Generates a French version from the English source. (deactivated) |
| **Aggregate** | Builds a single Markdown file for offline use. (deactivated) |
| **pages-build-deployment** | Deploys the documentation to GitHub Pages. |


---

## Contributing

This documentation is a **living reference**.  
All contributions must go through **Pull Request** review by the **Quality Team** and, when applicable, the **Technical Referent**.

**Guidelines:**
- Keep edits **concise**, **consistent**, and **in English**.  
- Reference related tickets or discussions in commit messages.  
- Keep branches short-lived: merge early, merge often.  
- Each branch should focus on a single, clear topic.  
- Avoid long-running branches or parallel document versions.
- Documentation changes are collaborative but should remain traceable and easy to review.

### Branch Naming Convention

The documentation repository follows a **trunk-based development workflow** similar to our Odoo projects, with lightweight and short-lived branches.

#### Main branch
- **`main`** is the source of truth and represents the published version of the documentation (public or internal).

#### Working branches
Branches are created for short, focused contributions and merged quickly into `main` using **squash merges**.

Use clear and thematic prefixes instead of ticket-based names:

| Prefix | Purpose | Example |
|---------|----------|----------|
| `doc/` | New documentation page or section | `doc/hooks`, `doc/migrations` |
| `fix/` | Minor fix or correction | `fix/typo`, `fix/links` |
| `rev/` | Major revision or restructuring | `rev/architecture`, `rev/sections-order` |
| `draft/` | Work in progress, not yet validated | `draft/quality-charter` |


_This convention keeps the documentation process consistent with our trunk-based philosophy while staying lightweight and contributor-friendly._

### Running Locally
```bash
make setup
make serve
```

```bash
# To aggregate and translate documentation manually
make translate
make aggregate
```

---

## Drafts and Proposals

Any unvalidated or in-progress document must begin with this badge:

```markdown
<mark>Status: Draft — Pending Review and Approval</mark>
```

This clearly indicates that the page is **provisional** and subject to review.

---

## License

This repository is distributed under the [MIT License](./LICENSE).
:::
