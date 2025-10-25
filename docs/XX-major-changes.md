# Odoo Major Version Changes

<mark> Status: Draft — Pending Review and Approval </mark>

> This document summarizes **key technical and functional changes** introduced in major Odoo versions.  
> It is designed to help developers, integrators, and Technical Referents anticipate migration impacts and adjust their codebase accordingly.

[Official Odoo changelogs](https://www.odoo.com/documentation/19.0/fr/developer/reference/backend/orm/changelog.html#)



## General Principles

- Odoo releases a **major version every year**, typically in October.
- Each version is supported for **three years** under Odoo Enterprise.
- Upgrades between major versions may require **database migration**, **code adaptation**, and **infrastructure updates**.
- Minor releases are backward-compatible and primarily include bug fixes or small enhancements.



## Evolution Summary

| Version | Year | Key Technical Changes | Key Functional Changes |
|----------|------|-----------------------|-------------------------|
| **v15 → v16** | 2022 | - ORM performance overhaul<br>- New “models.Command” syntax for relational fields<br>- Removal of legacy API decorators<br>- Mass refactor of list and kanban views<br>- Switch to OWL 2 framework for frontend | - Accounting refactor (no longer a community module)<br>- Improved POS and Inventory<br>- Consolidated settings UI |
| **v16 → v17** | 2023 | - OWL 2 adoption completed (100% frontend)<br>- New JavaScript module loader (ESM)<br>- RPC and webclient refactored<br>- Removal of jQuery and legacy JS framework<br>- New testing utilities for JS<br>- Split of web modules (web, web_editor, mail, spreadsheet) | - New interface design (modern theme)<br>- Unified search and navigation bar<br>- Improved CRM and sales flow<br>- Better Excel import/export |
| **v17 → v18** | 2024 | - OWL 3 (hooks, stores, and reactive components)<br>- New asset bundling with `rollup`<br>- Backend actions refactor (async jobs)<br>- Changes to mail/thread models (new chatter API)<br>- Refactored ORM caches and environment handling<br>- Base HTTP routing simplified | - Major UX simplifications<br>- New Kanban view editor<br>- Improved Studio compatibility<br>- Enhanced website & ecommerce flows |
| **v18 → v19** | 2025 | - Introduction of async ORM methods<br>- Refactor of Odoo’s internal CLI and test runner<br>- Removal of `api.multi` remnants<br>- PostgreSQL 15+ requirement<br>- Stricter manifest validation and metadata structure | - Modernized UI (single-page feel)<br>- Multi-company refinements<br>- Extended data migration tooling |

## 19.0

> [Odoo 19 Release Notes](https://www.odoo.com/fr_FR/odoo-19-release-notes)

### SQL constraints

Old way:
```python
_sql_constraints = [
        (
            "product_uniq",
            "unique(parent_product_id, product_id)",
            "Product must be only once on a pack!",
        ),
    ]
 
```

New way:
```python
_product_uniq = models.Constraint(
        "unique(parent_product_id, product_id)",
        "Product must be only once on a pack!",
    )
```
