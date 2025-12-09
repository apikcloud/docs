<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 04-models
Project: aikcloud/docs
Last update: 2025-12-08
Status: Draft
Reviewer: 
-->

## 4. Models

This document defines **how to design, name, and organize models** in Odoo addons.  
It complements the pages on **Methods** and **Fields**.

---

### 1. Model Types (and when to use them)

| Type | Base Class | Purpose | Typical Use |
|------|------------|---------|-------------|
| **Persistent** | `models.Model` | Stored business data | Partners, orders, invoices |
| **Transient** | `models.TransientModel` | Ephemeral wizards; auto‑cleaned | Assistants, import/export dialogs |
| **Abstract** | `models.AbstractModel` | Share behavior via inheritance (no table) | Mixins, reusable behaviors, e.g. `mail.thread`, `mail.activity.mixin`, `portal.mixin` |


**Rules**
- Use **TransientModel** if data should **not** survive garbage collection.
- Use **AbstractModel** for **behavior reuse**, not for storing data.
- Prefer **mixins** over re‑implementing generic features (mail, portal, sequence, rating).

---

### 2. Naming Conventions

#### 2.1 Technical Model Name (`_name`)

- Use **namespace prefix** of your addon: `your_addon.model_name`.
- Use **singular nouns** for entities (`sale.order`, `account.move`, `product.brand`).
- Keep it **short and descriptive** (under ~40 chars).

**Examples**
```python
_name = "product.brand"
_name = "move.chatter.history"
```

#### 2.2 Python Class Name

- Use **CapWords** (PEP 8): `Contract`, `SalesSubscription`.

~~When inheriting existing models via `_inherit`, keep the class name meaningful, not necessarily identical to `_name`.~~

#### 2.3 Display Name and Ordering

- Set `_rec_name` if the default `name` is not the correct label.
- Set `_order` for deterministic listing (avoid slow expressions).

**Example**
```python
_rec_name = "display_name"
_order = "date_start desc, id desc"
```

---

### 3. Inheritance Models

#### 3.1 Classical Inheritance (`_inherit`)

Extends an existing model (same table).  
Use to add fields/behavior without changing identity.

```python
class ResPartner(models.Model):
    _inherit = "res.partner"

    loyalty_points = fields.Integer(default=0)
```

**Rules**
- Keep overrides **thin**; delegate logic to helpers.
- Document functional intent in a short class docstring.

#### 3.2 Delegation Inheritance (`_inherits`)

Composes another model via foreign key (separate tables).  
Use when your model **is‑a** + **has‑a** relationship is required.

```python
class LibraryMember(models.Model):
    _name = "library.member"
    _inherits = {"res.partner": "partner_id"}

    partner_id = fields.Many2one("res.partner", required=True, ondelete="cascade")
```

**Rules**
- Choose `_inherits` when you need partner fields **and** your own identity/table.
- Keep FK field names explicit: `<model>_id` (e.g., `partner_id`).

#### 3.3 Abstract Models

Provide behavior and constraints without a table.

```python
class Exportable(models.AbstractModel):
    _name = "apik.exportable"
    _description = "Export helpers"
```

**Rules**
- No stored fields except computed helpers without storage.
- Keep API **stable**; treat like a public contract for your addon.

---

### 4. Class Layout (ordering & sections)

Keep a **consistent block order** inside every model class:

1. **Meta**: `_name`, `_description`, `_inherit`/`_inherits`, `_rec_name`, `_order`  
2. **Defaults**: default values for fields  
3. **Fields**: simple → relational → computed  
4. **SQL constraints**: `_sql_constraints`  
5. **Methods**: all methods, see **XX-Methods** for details

**Example skeleton**
```python
class Contract(models.Model):
    _name = "apik_contract.contract"
    _description = "Contract"

    # 2) Fields
    name = fields.Char(required=True, index=True)
    partner_id = fields.Many2one("res.partner", required=True, ondelete="restrict")
    date_start = fields.Date(required=True)
    date_end = fields.Date()
    amount_total = fields.Monetary(currency_field="currency_id")
    currency_id = fields.Many2one("res.currency", required=True)
    state = fields.Selection([("draft","Draft"),("active","Active"),("closed","Closed")], default="draft")

    # 3) SQL constraints
    _sql_constraints = [
        ("date_range_ok", "CHECK(date_end IS NULL OR date_end >= date_start)", "End date must be after start date."),
        ("name_unique_partner", "unique(name, partner_id)", "Contract name must be unique per partner."),
    ]

    # 4) Python constraints
    @api.constrains("date_start", "date_end")
    def _check_dates(self):
        for rec in self:
            if rec.date_end and rec.date_end < rec.date_start:
                raise ValidationError("End date must be after start date.")

    # 5) Compute
    @api.depends("line_ids.amount")
    def _compute_amount_total(self):
        for rec in self:
            rec.amount_total = sum(rec.line_ids.mapped("amount"))

    # 7) Business methods
    def action_activate(self):
        self.filtered(lambda r: r.state == "draft").write({"state": "active"})
        return True

    # 8) Overrides
    def write(self, vals):
        res = super().write(vals)
        self._log_state_change(vals)
        return res

    # 9) Helpers
    def _log_state_change(self, vals):
        if "state" in vals:
            _logger.info("Contract %s changed to %s", self.ids, vals["state"])
```

---

### 5. Data Integrity & Constraints

- Prefer **SQL constraints** for invariants that must hold at DB level (uniqueness, date logic).  
- Use `@api.constrains` for Python‑level checks needing record context.  
- Use **ondelete policies** (`restrict`, `cascade`, `set null`) explicitly on relational fields.  
- Avoid storing denormalized values unless justified (and document why).

---

### 6. Security & Access (high‑level)

- Define `ir.model.access.csv` for create/read/write/unlink rules per role.  
- Use **record rules** for domain‑based access; keep them **as simple as possible**.  
- Never filter security entirely in Python — **enforce in ACLs and rules**.

---

### 7. Internationalization

- Use `_(...)` for all user‑visible strings (labels, errors).  
- Keep field help/tooltips concise and actionable.

---

### 8. Performance Considerations

- Avoid per‑record loops in computed fields — batch with `mapped()` or set comprehensions.  
- Prefetch relations and use `read_group` for aggregates.  
- Index frequently searched fields (`index=True`).  
- Avoid large `@api.depends` lists; depend only on what’s necessary.

---

### 9. Do & Don’t

**Do**
- Keep model names clear and stable.  
- Document non‑obvious design choices in a class docstring.  
- Choose `_inherits` for composition scenarios.  
- Keep overrides thin; delegate to helpers.

**Don’t**
- Don’t overload models with unrelated concerns — split into separate addons.  
- Don’t store transient UI state on persistent models.  
- Don’t hide cross‑module dependencies; declare them in `__manifest__.py`.  
- Don’t rely on implicit defaults; be explicit.

---
