<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 99-examples/01-odoo-examples/01-orm-python
Project: apikcloud/docs
Last update: 2026-03-02
Status: Draft
Reviewer: 
-->

# ORM and Python logic

Each example shows a **Bad** and a **Good** pattern with a brief rationale.

## 1. ORM: avoid raw SQL when ORM suffices

**Don't**

```python
self.env.cr.execute("UPDATE sale_order SET state='done' WHERE id=%s", order.id)
```

**Do**

```python
order.write({"state": "done"})
```

**Why:**  
ORM handles metadata, audits, computed fields, and access rules. Raw SQL bypasses
them. [Ref: Coding Guidelines, ORM API]

## 2. Fields naming in compute methods: use `record` or `records`, not `sales`, `partners`, etc.

**Don't**

```python
def _compute_total(self):
    for sale in self:
        sale.total = sum(line.price_total for line in sale.line_ids)
```

**Do**

```python
def _compute_total(self):
    for record in self:
        record.total = sum(line.price_total for line in record.line_ids)
```

**Why:**  
Generic names avoid confusion in reused code. [Ref: Coding Guidelines]

## 3. Computed fields: declare dependencies and store when needed

**Don't**

```python
total = fields.Monetary(
    compute="_compute_total",
)


def _compute_total(self):
    for record in self:
        record.total = sum(line.price_total for line in record.line_ids)
```

**Do**

```python
total = fields.Monetary(
    compute="_compute_total",
    store=True,
)


@api.depends("line_ids.price_total")
def _compute_total(self):
    for record in self:
        record.total = sum(record.line_ids.mapped("price_total"))
```

**Why:**  
`@api.depends` ensures correct recompute; `store=True` if used in search/sort. [Ref: ORM API]

## 4. Context and defaults: avoid globals, use lambdas with env

**Don't**

```python
company_id = fields.Many2one(
    comodel_name="res.company",
    default=self.env.company.id,
)
```

**Do**

```python
company_id = fields.Many2one(
    comodel_name="res.company",
    default=lambda self: self.env.company.id,
)
```

**Why:**  
Defaults must be callables to get the *current* env and user/company. [Ref: ORM API]

## 5. Precision for monetary/float comparisons: use helpers

**Don't**

```python
if record.amount_total == 0.0:
    ...
```

**Do**

```python
from odoo.tools.float_utils import float_is_zero

if float_is_zero(record.amount_total, precision_rounding=record.currency_id.rounding):
    ...
```

**Why:**  
Respect currency precision; avoid equality on floats. [Ref: ORM API / tools]

## 6. Translations: use `_()` and avoid string concatenation

**Don't**

```python
raise UserError("Order " + self.name + " is invalid")
```

**Do**

```python
# For Odoo < 19.0
from odoo import _

raise UserError(_("Order %(name) is invalid", name=self.name))

# For Odoo >= 19.0
raise UserError(self.env._("Order %(name)s is invalid", name=self.name))
```

**Why:**  
Mark strings for i18n; avoid concatenation to keep messages translatable. [Ref: Coding Guidelines]

## 7. API decorators: match the method’s calling convention

**Don't**

```python
def create(vals):
    ...
```

**Do**

```python
@api.model_create_multi
def create(self, vals):
    return super().create(vals)
```

**Why:**  
Decorators (`@api.model`, `@api.depends`, etc.) declare expectations and enable framework features. [Ref: ORM API]
