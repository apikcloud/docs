<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 99-examples/01-odoo-examples/04-views
Project: apikcloud/docs
Last update: 2026-03-02
Status: Draft
Reviewer: 
-->

# Structure

Each example shows a **Bad** and a **Good** pattern with a brief rationale.

## 1. Sort imports alphabetically

**Don't**

```python
from odoo import models, fields, api
```

**Do**

```python
from odoo import api, fields, models
```

**Why:**  
We follow the isort convention, which is the default convention for Python.

## 2. Sort Odoo fields alphabetically

**Don't**
```python
order_id = fields.Many2one(
    comodel_name="sale.order", 
)
name = fields.Char()
active = fields.Boolean()
partner_id = fields.Many2one(
    comodel_name="res.partner",
    string="Customer",
)
```

**Do**
```python
active = fields.Boolean()
name = fields.Char()
order_id = fields.Many2one(
    comodel_name="sale.order",
)
partner_id = fields.Many2one(
    comodel_name="res.partner",
    string="Customer",
)
```

**Why:**  
Sorting fields alphabetically makes it easier to find a specific field in the code and avoids duplicate fields.
