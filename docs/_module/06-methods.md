## 6. Methods

This document defines **how to design, name, and order methods** in Odoo modules.  
It applies to both business logic and framework-level code.

---

### 6.1. Method Types in Odoo

#### Business Methods
These implement the functional logic of your module (invoicing, validation, etc.).  
They are typically **called by actions, buttons, or cron jobs**.

**Example**
```python
def action_validate(self):
    """Validate the invoice and trigger posting logic."""
    self.ensure_one()
    self._check_invoice_balanced()
    self.state = "posted"
    self._post_account_move()
```

**Rules**
- Use descriptive verbs (`action_`, `generate_`, `export_`, `import_`).
- Must be **idempotent** when possible (safe to call twice).
- Should **not mix UI and logic** (no `raise UserError` unless in final layer).

---

#### Framework Hooks
Methods used by Odoo internals or extending base models.  
Examples: `create`, `write`, `unlink`, `copy`, `name_get`, `default_get`, `_compute_*`, `_inverse_*`, `_search_*`.

**Rules**
- Always call `super()` unless you explicitly want to block parent logic.
- Keep overrides **thin**: delegate real logic to private helpers.
- Document every override with purpose and constraints.

**Example**
```python
def write(self, vals):
    """Override to log partner updates."""
    res = super().write(vals)
    self._log_partner_update(vals)
    return res
```

---

#### Technical Helpers
Internal helpers meant for reuse inside the same model or module.  
They start with an underscore.

**Rules**
- Never used from XML actions or external modules.
- Contain small, composable logic.
- Must not rely on transient UI context (`self.env.context` is acceptable).

**Example**
```python
def _compute_due_date(self):
    self.due_date = self.invoice_date + timedelta(days=self.payment_term_days)
```

---

#### API Decorators
Odoo provides several decorators to clarify method scope.

| Decorator | Usage | Example |
|----------|-------|---------|
| `@api.model` | No recordset required | setup helpers, `create_from_ui` |
| `@api.model_create_multi` | Accepts multiple vals at once | `create` |
| `@api.depends` | Compute fields dependencies | `_compute_total` |
| `@api.onchange` | Form onchange logic | `_onchange_partner_id` |
| `@api.constrains` | Validation constraints | `_check_amount_positive` |
| `@api.autovacuum` | Periodic cleanup tasks | `_gc_old_records` |

**Rule of thumb:** use the decorator that best represents the logical **scope**, not the easiest to code with.

---

### 6.2. Method Naming Conventions

#### Prefixes by Purpose
| Prefix | Meaning | Example |
|--------|---------|---------|
| `action_` | Triggered by user or button | `action_validate`, `action_send_email` |
| `_compute_` | Field computation | `_compute_amount_total` |
| `_inverse_` | Inverse of computed field | `_inverse_amount_total` |
| `_check_` | Internal validation | `_check_dates_coherence` |
| `_prepare_` | Returns a dict or data structure | `_prepare_invoice_vals` |
| `_get_` | Fetches or resolves something | `_get_partner_data` |
| `_set_` | Assigns something | `_set_state_draft` |
| `_sync_` | Synchronization with external system | `_sync_customer_data` |
| `_run_` | Executed by scheduler or batch | `_run_invoice_auto_post` |

#### Naming Rules
- Use **snake_case**, no camelCase.
- Avoid abbreviations unless common (`qty`, `uom`).
- Use **verbs first**, then objects (`_compute_total`, not `_total_compute`).
- Keep names under **40 characters**.

---

### 6.3. Method Ordering in Classes

Follow a predictable, consistent order in every model:

1. **Default** (`_default_...` methods)
2. **Compute / inverse / constrain methods**
3. **Onchange methods**
4. **Private helpers** (`_prepare_`, `_get_`, `_check_`, `_run_`)
5. **API / integration utilities**
6. **Autovacuum / cron tasks**
7. **Public business methods** (`action_...`)
8. **ORM** (`create`, `write`, `unlink`, etc.)


**Example**
```python
class SaleOrder(models.Model):
    _name = "sale.order"

    ## 1. Defaults
    @api.model
    def _default_partner_id(self): ... 

    ... fields declaration ...

    ## 2. Computed fields
    @api.depends("order_line.price_total")
    def _compute_amount_total(self): ...

    ## 3. Onchange
    @api.onchange("partner_id")
    def _onchange_partner_id(self): ...

    ## 4. Helpers
    def _prepare_invoice_vals(self): ...

    ## 4. Public business methods
    def action_confirm(self): ...

    ## 5. ORM
    def write(self, vals): ...    
```

---

### 6.4. Documentation and Typing

- Always include **docstrings** for public and override methods.  
- Use **type hints** when readability benefits (optional, but encouraged).  
- Private helpers may skip docstring if self-explanatory.

**Example**
```python
def _prepare_invoice_vals(self) -> dict:
    """Prepare the values to create the related invoice."""
    self.ensure_one()
    return {
        "partner_id": self.partner_id.id,
        "invoice_origin": self.name,
    }
```

---

### 6.5. What Not to Do

- Don’t name methods ambiguously (`do_stuff`, `process_data`).  
- Don’t hide side effects behind helper names (`_prepare_` should never write).  
- Don’t use `@api.model` for methods that depend on record state.  
- Don’t put user interaction (`UserError`, `raise`) inside technical helpers.

---
