# Odoo Major Version Changes

<mark> Status: Draft — Pending Review and Approval </mark>

> This document summarizes **key technical and functional changes** introduced in major Odoo versions.  
> It is designed to help developers, integrators, and Technical Referents anticipate migration impacts and adjust their codebase accordingly.


## General Principles

- Odoo releases a **major version every year**, typically in October.
- Each version is supported for **three years** under Odoo Enterprise.
- Upgrades between major versions may require **database migration**, **code adaptation**, and **infrastructure updates**.
- Minor releases are backward-compatible and primarily include bug fixes or small enhancements.



## Evolution Summary

| Version | Year | Key Technical Changes | Key Functional Changes | OCA Migration Guide |
|----------|------|-----------------------|-------------------------|------------------|
| **19.0** | 2025 | [ORM Changelog](https://www.odoo.com/documentation/19.0/developer/reference/backend/orm/changelog.html#) | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-19-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-19.0) |
| **18.0** | 2024 | [ORM Changelog](https://www.odoo.com/documentation/18.0/developer/reference/backend/orm/changelog.html#) | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-18-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-18.0) |
| **17.0** | 2023 | [ORM Changelog](https://www.odoo.com/documentation/17.0/developer/reference/backend/orm/changelog.html#) | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-17-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-17.0) |
| **16.0** | 2022 | [ORM Changelog](https://www.odoo.com/documentation/16.0/developer/reference/backend/orm/changelog.html#) | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-16-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-16.0) |
| **15.0** | 2021 | -- | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-15-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-15.0) |
| **14.0** | 2020 | -- | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-14-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-14.0) |
| **13.0** | 2019 | -- | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-13-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-13.0) |
| **12.0** | 2018 | -- | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-12-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-12.0) |
| **11.0** | 2017 | -- | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-11-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-11.0) |
| **10.0** | 2016 | -- | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-10-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-10.0) |


## 19.0

### SQL constraints

**Old way:**
```python
_sql_constraints = [
        (
            "product_uniq",
            "unique(parent_product_id, product_id)",
            "Product must be only once on a pack!",
        ),
    ]
 
```

**New way:**
```python
_product_uniq = models.Constraint(
        "unique(parent_product_id, product_id)",
        "Product must be only once on a pack!",
    )
```
