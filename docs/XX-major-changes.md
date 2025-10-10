# Odoo Major Version Changes

This document summarizes **key technical and functional changes** introduced in major Odoo versions.  
It is designed to help developers, integrators, and Technical Referents anticipate migration impacts and adjust their codebase accordingly.

Official Odoo changelogs: [https://www.odoo.com/page/changelog](https://www.odoo.com/page/changelog)

---

## 1. General Principles

- Odoo releases a **major version every year**, typically in October.
- Each version is supported for **three years** under Odoo Enterprise.
- Upgrades between major versions may require **database migration**, **code adaptation**, and **infrastructure updates**.
- Minor releases (e.g. `v18.0 → v18.1`) are backward-compatible and primarily include bug fixes or small enhancements.

---

## 2. Evolution Summary

| Version | Year | Key Technical Changes | Key Functional Changes |
|----------|------|-----------------------|-------------------------|
| **v15 → v16** | 2022 | - ORM performance overhaul<br>- New “models.Command” syntax for relational fields<br>- Removal of legacy API decorators<br>- Mass refactor of list and kanban views<br>- Switch to OWL 2 framework for frontend | - Accounting refactor (no longer a community module)<br>- Improved POS and Inventory<br>- Consolidated settings UI |
| **v16 → v17** | 2023 | - OWL 2 adoption completed (100% frontend)<br>- New JavaScript module loader (ESM)<br>- RPC and webclient refactored<br>- Removal of jQuery and legacy JS framework<br>- New testing utilities for JS<br>- Split of web modules (web, web_editor, mail, spreadsheet) | - New interface design (modern theme)<br>- Unified search and navigation bar<br>- Improved CRM and sales flow<br>- Better Excel import/export |
| **v17 → v18** | 2024 | - OWL 3 (hooks, stores, and reactive components)<br>- New asset bundling with `rollup`<br>- Backend actions refactor (async jobs)<br>- Changes to mail/thread models (new chatter API)<br>- Refactored ORM caches and environment handling<br>- Base HTTP routing simplified | - Major UX simplifications<br>- New Kanban view editor<br>- Improved Studio compatibility<br>- Enhanced website & ecommerce flows |
| **v18 → v19** | 2025 (expected) | - Introduction of async ORM methods<br>- Refactor of Odoo’s internal CLI and test runner<br>- Removal of `api.multi` remnants<br>- PostgreSQL 15+ requirement<br>- Stricter manifest validation and metadata structure | - Modernized UI (single-page feel)<br>- Multi-company refinements<br>- Extended data migration tooling |
| **v19 → v20** | TBD | - Potential split between Odoo server core and frontend bundles<br>- Further separation of Odoo Framework vs. Odoo Apps<br>- New async mail queue subsystem | TBD |

---

## 3. Common Migration Impacts

### 3.1 ORM and Python API
- Legacy `@api.one`, `@api.multi`, and `@api.depends('...')` usage must be checked each version.
- Methods returning commands (create/update/write) must follow the new `models.Command` format.
- Deprecated model attributes (e.g. `store=True` defaults, `track_visibility`) often require migration scripts.

### 3.2 JavaScript / OWL Framework
- Each major version brings breaking changes to the frontend:
  - OWL 1 → OWL 2: class-based → reactive hooks.
  - OWL 2 → OWL 3: global store, async rendering, and new event model.
- Custom views, widgets, or web modules must be reviewed every major upgrade.
- Avoid monkey-patching core components; use official extension points instead.

### 3.3 Assets & Web Bundles
- From v17 onward, assets are bundled via **Rollup** instead of Webpack.
- CSS/JS loading changed; module manifests may require `assets` keys updates.
- Ensure consistent version of NodeJS when rebuilding Odoo images.

### 3.4 Mail & Chatter System
- Mail models (`mail.thread`, `mail.message`) frequently change internal structure.
- v18 introduces new “Message Bus” and “Thread API” — breaking custom chatter extensions.

### 3.5 Infrastructure
- Docker base images evolve:
  - Python 3.10 → 3.11 (v18)
  - PostgreSQL 13 → 15 (v19)
- Rebuild your custom images after migration.
- Check compatibility of dependencies (wkhtmltopdf, Redis, node, etc.).

---

## 4. Migration Recommendations

- Always migrate **one major version at a time** (no jumps).
- Run `--stop-after-init -u all` on a cloned DB to detect model or field errors.
- Use `MIGRATIONS.md` for manual SQL and module steps.
- Validate **mail, chatter, and automated actions** — they often break silently.
- Avoid `@api.model_create_multi` or low-level overrides unless necessary.

---

## 5. Useful Tools and References

| Tool | Purpose |
|------|----------|
| [Odoo Upgrade Platform](https://upgrade.odoo.com) | Official migration tool for Enterprise |
| [OpenUpgrade](https://github.com/OCA/OpenUpgrade) | Open-source framework for community migrations |
| `odoo-bin scaffold` | Create base structure for migrated addons |
| `--stop-after-init` | Safe DB schema upgrade test |
| `--update=module` | Targeted module reinstallation |

---

## 6. Migration Difficulty Overview

| From → To | Difficulty | Notes |
|------------|-------------|-------|
| 14 → 15 | ★★☆☆☆ | ORM stable; minor refactors |
| 15 → 16 | ★★★☆☆ | Major ORM rewrite; accounting consolidation |
| 16 → 17 | ★★★★☆ | Full JS/OWL shift; major frontend breakage |
| 17 → 18 | ★★★☆☆ | Mail refactor and asset changes |
| 18 → 19 | ★★★☆☆ | Expected ORM & async changes |

---

## 7. Maintenance Tips

- Keep your modules **clean and declarative** to ease future upgrades.
- Avoid overriding Odoo core files or private methods (`_method` with underscore).
- Track upcoming changes early through the Odoo master branch and release notes.
- Maintain a test DB per major version in your infrastructure for early validation.

---

_Last updated: 2025-10-12_
