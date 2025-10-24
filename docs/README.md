# The Apik Way

All engineering documentation for Apik lives in `/docs`. This README is a concise entry point.

> **Working language:** All code, comments, commit messages, and documentation are written in **English**.

<p align="left">
  <a href="https://github.com/apikcloud/docs/actions"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/apikcloud/docs/ci.yml?label=CI"></a>
  <a href="./LICENSE"><img alt="License" src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
  <a href="./docs"><img alt="Docs" src="https://img.shields.io/badge/docs-available-brightgreen"></a>
</p>

---

## Core Documentation

1. [`Introduction`](docs/01-introduction.md) — overall principles and expectations  
2. [`Engineering Philosophy`](docs/02-philosophy.md) — values and long‑term commitments  
3. [`Platforms`](docs/03-platforms.md) — Apik Cloud, On‑Premise, Odoo.sh overview  
4. [`Project Organization`](docs/04-organization.md) — repo layout, submodules, symlinks, required files  
5. [`Workflow`](docs/05-workflow.md) — trunk-based development, branches, merges, releases  
6. [`Commits`](docs/06-commits.md) — Conventional Commits, content rules  
7. [`Changelog`](docs/07-changelog.md) — Keep a Changelog, ticket references, structure  
8. [`Migrations`](docs/08-migrations.md) — Procedures, command script, validation & rollback  

Drafts to be finalized:  
- [`CI/CD`](docs/XX-cicd.md) — CI/CD pipelines, quality gates, release process  
- [`Code Review`](docs/XX-code-review.md) — Code review process, tools, best practices
- [`Environment Setup`](docs/XX-environment.md) — Local development environment setup instructions
- [`Major changes`](docs/XX-major-changes.md) — Handling breaking changes between Odoo versions
- [`Releases`](docs/XX-releases.md) — Release types, versioning, tagging, notes
---

## Module Guidelines

Guidance specific to Odoo addons lives under `docs/XX-module/`. Some parts are stabilized, others are still drafted.

1. [`Naming`](docs/XX-module/01-naming.md)  
2. [`Structure`](docs/XX-module/02-structure.md)  
3. [`Manifest`](docs/XX-module/03-manifest.md)  
4. [`Models`](docs/XX-module/04-models.md)  
5. [`Fields`](docs/XX-module/05-fields.md)  
6. [`Methods`](docs/XX-module/06-methods.md)  

Examples:  
- [`Example 1`](docs/XX-module/examples/01-examples.md)  
- [`Example 2`](docs/XX-module/examples/02-examples.md)

Drafts to be finalized:  
- [`Assets / JS / OWL`](docs/XX-module/XX-assets-js-owl.md)  
- [`Checklist`](docs/XX-module/XX-checklist.md)  
- [`Documentation`](docs/XX-module/XX-documentation.md)  
- [`References`](docs/XX-module/XX-references.md)  
- [`Security`](docs/XX-module/XX-security.md)  
- [`Translations`](docs/XX-module/XX-translations.md)  
- [`UI / UX`](docs/XX-module/XX-ui-ux.md)  
- [`Unit tests`](docs/XX-module/XX-unit-tests.md)  
- [`Views`](docs/XX-module/XX-views.md)

---

## Contributing

- This documentation is a **living reference**. Contributions are welcome via **Pull Request**.  
- Changes are reviewed by the **Quality team** and may involve the **Technical Referent**.  
- Keep edits **concise, consistent, and in English**. Reference tickets in commit messages when relevant.
