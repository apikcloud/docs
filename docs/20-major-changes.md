<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 20-major-changes
Project: apikcloud/docs
Last update: 2025-12-08
Status: Draft
Reviewer: 
-->

# Odoo Major Version Changes

> This document summarizes **key technical and functional changes** introduced in major Odoo versions.  
> It is designed to help developers, integrators, and Technical Referents anticipate migration impacts and adjust their
> codebase accordingly.

## General Principles

- Odoo releases a **major version every year**, typically in October.
- Each version is supported for **three years** under Odoo Enterprise.
- Upgrades between major versions may require **database migration**, **code adaptation**, and **infrastructure
  updates**.
- Minor releases are backward-compatible and primarily include bug fixes or small enhancements.

> See [Supported Versions](https://www.odoo.com/documentation/19.0/administration/supported_versions.html) for more
> details on version support timelines.

## Evolution Summary

| Version  | Year | Key Technical Changes                                                                                    | Key Functional Changes                                                 | OCA Migration Guide                                                                       | End of support           |
|----------|------|----------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|--------------------------|
| **20.0** | 2026 | [ORM Changelog](https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html#) | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-20-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-20.0) | September 2029 (planned) |
| **19.0** | 2025 | [ORM Changelog](https://www.odoo.com/documentation/19.0/developer/reference/backend/orm/changelog.html#) | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-19-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-19.0) | September 2028 (planned) |
| **18.0** | 2024 | [ORM Changelog](https://www.odoo.com/documentation/18.0/developer/reference/backend/orm/changelog.html#) | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-18-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-18.0) | September 2027 (planned) |
| **17.0** | 2023 | [ORM Changelog](https://www.odoo.com/documentation/17.0/developer/reference/backend/orm/changelog.html#) | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-17-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-17.0) | September 2026 (planned) |
| **16.0** | 2022 | [ORM Changelog](https://www.odoo.com/documentation/16.0/developer/reference/backend/orm/changelog.html#) | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-16-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-16.0) | September 2025           |
| **15.0** | 2021 | --                                                                                                       | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-15-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-15.0) | October 2024             |
| **14.0** | 2020 | --                                                                                                       | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-14-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-14.0) | Before 2024              |
| **13.0** | 2019 | --                                                                                                       | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-13-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-13.0) | Before 2024              |
| **12.0** | 2018 | --                                                                                                       | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-12-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-12.0) | Before 2024              |
| **11.0** | 2017 | --                                                                                                       | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-11-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-11.0) | Before 2024              |
| **10.0** | 2016 | --                                                                                                       | [Odoo Release Notes](https://www.odoo.com/fr_FR/odoo-10-release-notes) | [Migration Guide](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-10.0) | Before 2024              |

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

### Public widgets & Interaction

Public widgets are replaced by Interaction, a new little "framework" similar to OWL.

**Old way:**

```javascript
/** @odoo-module **/

import publicWidget from "@web/legacy/js/public/public_widget";

publicWidget.registry.multirangePriceSelector = publicWidget.Widget.extend({
    selector: '.o_wsale_products_page',
    events: {
        'newRangeValue #o_wsale_price_range_option input[type="range"]': '_onPriceRangeSelected',
    },

    // Functions
});
```

**New way:**

```javascript
import {Interaction} from '@web/public/interaction';
import {registry} from '@web/core/registry';

export class PriceRange extends Interaction {
    static selector = '#o_wsale_price_range_option';
    dynamicContent = {
        'input[type="range"]': {'t-on-newRangeValue': this.onPriceRangeSelected},
    };

    // Functions
}

registry
    .category('public.interactions')
    .add('website_sale.price_range', PriceRange);
```

## 20.0

### Security

`ir.model.access` and `ir.rule` have been merged in a new model `ir.access`.

**New ir.access.csv**

```
id,name,model_id,group_id/id,operation,domain
access_sale_order,access_sale_order,sale.order,my_module.my_group,crud,
access_my_model,access_my_model,my.model,my_module.my_group,r,"[('company_id', 'in', company_ids + [False])]"
```

### OWL

Odoo now uses OWL v3.

#### useState and proxy

`useState` doesn't exist anymore, and is replaced by `proxy` / `signal` / `computed`.

#### useProps

`props` and `defaultProps` are replaced by `useProps`.

```javascript
class AComponent extends Component {
    // Some stuff...

    // v2
    static props = {
        name: String,
        visible: {type: Boolean, optional: true},
        leaveDuration: {type: Number, optional: true},
        onLeave: {type: Function, optional: true},
        slots: Object,
    };
    static defaultProps = {
        leaveDuration: 100,
    };

    // v3
    props = useProps({
        name: t.string(),
        visible: t.boolean().optional(),
        leaveDuration: t.number().optional(100),
        onLeave: t.function().optional(),
    });

    // Some stuff...
}
```
