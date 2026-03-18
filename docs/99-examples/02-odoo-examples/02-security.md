<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 99-examples/02-odoo-examples/02-security
Project: apikcloud/docs
Last update: 2026-03-02
Status: Draft
Reviewer: 
-->

# Security

Each example shows a **Bad** and a **Good** pattern with a brief rationale.

## 1. Security: don’t use `sudo()` casually

**Don't**

```python
records = self.sudo().search([("partner_id", "=", partner.id)])
```

**Do**

```python
records = self.search([("partner_id", "=", partner.id)])
# If you *must* elevate, narrow scope and document why:
secure_records = self.sudo().browse(safe_ids)
```

**Why:**  
`sudo()` bypasses ACLs/record rules; restrict it to minimal scope.

## 2. Constraints: use `_check_*` or SQL constraints over `onchange` for data integrity

**Don't**

```python
@api.onchange("qty")
def _onchange_qty(self):
    if self.qty < 0:
        self.qty = 0
```

**Do**

```python
qty = fields.Float()
# Using SQL constraint in Odoo < 19.0.
_sql_constraints = [("qty_positive", "CHECK(qty >= 0)", "Quantity must be positive.")]
# Or SQL constraint in Odoo >= 19.0.
models.Constraint("CHECK(qty >= 0)", "Quantity must be positive.")

# Or Python constraint (works in all versions).
@api.constrains("qty")
def _constrains_qty(self):
    if any(record.qty < 0 for record in self):
        raise ValidationError("Quantity must be positive.")
```

**Why:**  
Onchange is UI-only; constraints protect data server-side.

## 3. Access rules over custom code

**Don't**

```python
def _is_visible(self):
    if self.env.user.login.endswith("@vip.com"):  # brittle
        return True
    return False
```

**Do**

```text
# security/ir.model.access.csv + record rules on the model
```

**Why:**  
Use ACLs and record rules for data access; keeps security declarative and reviewable.
