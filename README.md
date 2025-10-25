<p align="center">
  <img src="https://raw.githubusercontent.com/apikcloud/docs/main/docs/_media/logo.png" alt="Apik Logo" width="180">
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/apikcloud/docs/main/docs/_media/compass.png" alt="Compass" width="500">
</p>

<p align="center">
  <a href="https://github.com/apikcloud/docs/actions"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/apikcloud/docs/ci.yml?label=CI"></a>
  <a href="./LICENSE"><img alt="License" src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
  <a href="./docs"><img alt="Docs" src="https://img.shields.io/badge/docs-available-brightgreen"></a>
</p>

---

## Overview

This repository hosts **Apik’s internal engineering documentation** — our shared technical foundation for all teams.  
It defines our **development standards**, **workflows**, **tooling**, and **infrastructure guidelines**, ensuring coherence and quality across projects.

The full documentation lives in the `/docs` directory and is automatically deployed to GitHub Pages at:  
👉 [https://apikcloud.github.io/docs/](https://apikcloud.github.io/docs/)

---

## Philosophy

Every developer should be able to understand, extend, or debug any Apik project without friction.  
This documentation captures our collective know-how and evolves continuously through collaboration.

---

## Working Language

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
| **Aggregate** | Builds a single Markdown file for offline use. |

---

## Contributing

This documentation is a **living reference**.  
All contributions must go through **Pull Request** review by the **Quality Team** and, when applicable, the **Technical Referent**.

**Guidelines:**
- Keep edits **concise**, **consistent**, and **in English**.  
- Reference related tickets or discussions in commit messages.  


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
