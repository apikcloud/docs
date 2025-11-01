# 10. Module Guidelines

<mark> Status: Draft — Pending Review and Approval </mark>

> This section covers guidelines specific to Odoo addons developed by Apik. It includes naming conventions, module structure, manifest requirements, model definitions, field usage, and method implementations.

## 1. Naming Conventions

### Rules

- **Addon names**: `apik_` prefix for all Apik-specific addons (e.g., `apik_brand`, `apik_filter`)
- **File headers**: All files include copyright header: `# Copyright 2025 apik (https://apik.cloud).`

## 2. Structure Pattern

All addons follow standard Odoo structure with Apik-specific conventions:
```
addon_name/
├── __init__.py           # Import models, controllers, wizards
├── __manifest__.py       # Standard Odoo manifest with Apik metadata
├── controllers/          # HTTP controllers (website addons)
├── i18n/                 # Translation files
├── models/               # Business logic models
├── security/             # ir.model.access.csv, security groups
└── static/               # Assets: JS, CSS, images
    └── src/js/           # JavaScript modules using @odoo-module
├── views/                # XML view definitions  
├── wizards/              # Transient models for wizards
```

## 3. Manifest Guidelines

### Manifest Structure
Follow this pattern for `__manifest__.py` in all Apik addons:
```python
# Copyright 2025 apik (https://apik.cloud).
# License LGPL-3.0 or later (https://www.gnu.org/licenses/lgpl).

{
    "name": "Descriptive Name",
    "summary": "A brief summary of the module's purpose",
    "version": "18.0.1.0.0",
    "category": "Category/Subcategory", 
    "author": "Apik",
    "maintainers": ["<github_username>"],
    "website": "https://apik.cloud",
    "depends": [
        "base", 
        "other_modules",
    ],
    "data": [
        # Order alphabetically, if possible.
        # Data
        # Reports  
        # Security
        "security/ir.model.access.csv",
        # Templates
        # Wizards, before views because views can depend on wizards.
        # Views
        "views/model_name.xml",
        # Menus, after all other elements as menu links mostly depend on them.
    ],
    "assets": {
        "web.assets_frontend": [
            "addon_name/static/src/js/file.js"
        ]
    },
    "installable": True,
    "auto_install": False,
    "application": False,
    "license": "LGPL-3",
}
```

**Rules:**
- The `name` field must be unique across all addons.
- The `summary` field should provide a concise description of the module's functionality.
- The `version` field must follow the semantic versioning format (MAJOR.MINOR.PATCH).
- The `category` field should accurately reflect the module's purpose and functionality.
- The `author` field must be set to "Apik".
- The `maintainers` field must include the GitHub usernames of all maintainers.
- The `website` field must point to the official Apik website.
- The `depends` field must list all required modules, including `base`.
- The `data` field must include all necessary XML files, ordered alphabetically.
- The `assets` field must include all required JavaScript files.
- The `installable`, `auto_install`, `application`, and `license` fields must be set as shown in the example.


- **License**: All addons use `LGPL-3` license

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
## 5. Fields

This document defines how to **design, name, and configure fields** in Odoo addons.  
It complements the pages on **Models** and **Methods**.

---

### 5.1. Field Types (quick map)

| Category | Types | Notes |
|---------|------|-------|
| **Basic** | `Char`, `Text`, `Html`, `Boolean`, `Integer`, `Float`, `Date`, `Datetime`, `Binary` | Prefer `Char(index=True)` for searchable short strings |
| **Money & Numbers** | `Monetary`, `Float`, `Integer` | `Monetary` requires `currency_field` |
| **Relational** | `Many2one`, `One2many`, `Many2many` | Always set `comodel_name`; define `ondelete` for `Many2one` |
| **Selection** | `Selection` | Keep choices stable; use constants |
| **Specialized** | `Json`, `Reference` | Use sparingly; document the schema clearly |

---

### 5.2. Naming & Labels

- **Technical name**: `snake_case`, short, descriptive (`amount_total`, `partner_ref`).  
- **String/label**: concise, user‑facing, **translated** (`string="Amount Total"`).  
- **Help**: add `help="..."` for non‑obvious fields; short and actionable.  
- **Copy**: set `copy=False` for fields that should not duplicate on record copy (e.g., states, numbers).

**Example**
```python
amount_total = fields.Monetary(string="Total", currency_field="currency_id", help="Computed total in order currency.")
```

---

### 5.3. Relational Fields

#### Many2one
```python
partner_id = fields.Many2one(
    comodel_name="res.partner",
    index=True,
    ondelete="restrict",
    required=True,
    string="Customer",
)
```
**Rules**
- Always specify `ondelete`: choose among `restrict`, `set null`, `cascade` (be explicit).  
- Add `index=True` on frequently searched relations.  
- Use meaningful names: `<model>_id` (e.g., `company_id`, `currency_id`).

#### One2many
```python
line_ids = fields.One2many(comodel_name="apik_contract.line", copy=True, inverse_name="contract_id", string="Lines")
```
**Rules**
- `inverse_name` must exist and be indexed if used in domains/aggregations.  
- Avoid massive onchanges triggered by large O2M; prefer explicit buttons or batches.

#### Many2many
```python
tag_ids = fields.Many2many("apik_contract.tag", string="Tags")
```
**Rules**
- Avoid M2M for data that needs ordering or extra attributes → use **O2M with detail model**.  
- When performance matters, ensure joins are selective (domains, indices on comodel).

---

### 5.4. Computed, Inverse, and Related

#### Computed
```python
amount_total = fields.Monetary(compute="_compute_amount", store=True, currency_field="currency_id")

@api.depends("line_ids.amount", "currency_id")
def _compute_amount(self): ...
```
**Rules**
- Use `store=True` for values frequently used in searches/aggregations or displayed in lists.  
- Keep `@api.depends(...)` **minimal and accurate** to reduce invalidations.  
- Prefer **batch computation**; avoid per‑record loops.  
- Use `compute_sudo=True` only if strictly necessary and documented.

#### Inverse
Provide an inverse when users can edit a computed field and you need to **persist** that edit.
```python
rate = fields.Float(compute="_compute_rate", inverse="_inverse_rate", store=True)
def _inverse_rate(self): ...
```

#### Related
```python
company_currency_id = fields.Many2one(related="company_id.currency_id", store=True)
```
**Rules**
- Use `related` for 1‑to‑1 derivations; add `store=True` if used in search/sort.  
- Do not chain long `related` paths; compute with a helper instead.

---

### 5.5. Selections & Enums

```python
STATE = [
    ("draft", "Draft"),
    ("active", "Active"),
    ("closed", "Closed"),
]

state = fields.Selection(
    selection=STATE,
    string="Status",
    default="draft",
    tracking=True,
    index=True,
    required=True,
)
```
**Rules**
- Keep choices **stable** (changing keys breaks data/migrations).  
- Centralize options as **module‑level constants**.  
- Use `tracking=True` for user‑visible lifecycle fields.

---

### 5.6. Money, Currency, and Precision

```python
currency_id = fields.Many2one("res.currency", string="Currency", required=True, ondelete="restrict")
amount_total = fields.Monetary(currency_field="currency_id", string="Total", digits="Product Price")
```
**Rules**
- Always provide `currency_field` for `Monetary`.  
- Use **named precisions** (`digits="Product Price"`) where business rules require it.  
- Avoid storing both **unit price** and **total** without justification; derive when possible.

---

### 5.7. Defaults, Readonly, Copy, Tracking

- `default=...` for safe defaults (functions allowed).  
- `readonly=True` for values users must not edit; pair with `states={...}` if needed.  
- `copy=False` for identifiers/sequences or transient state.  
- `tracking=True` on important business fields; use sparingly to avoid log noise.

---

### 5.8. Indexing & Searchability

- Add `index=True` on fields frequently used in domains or joins.  
- For text search, combine `index=True` on `Char` + a **search** helper if needed.  
- Use `read_group` for aggregations; avoid scanning large tables via Python.

---

### 5.9. Security & Multicompany

- Do **not** rely on Python to enforce access; define **ACLs** and **record rules**.  
- For multicompany fields, consider `company_dependent=True` or explicit company FK.  
- Validate cross‑company relations in `@api.constrains` when relevant.

---

### 5.10. Internationalization

- All `string`, `help`, and selection labels must be **translatable**.  
- Keep messages short and clear; avoid jargon in user‑facing labels.

---

### 5.11. Migrations & Stability

- Renaming a field breaks stable APIs; prefer **new field + migration** over renames.  
- When deprecating, keep the old field read‑only for a version and provide a data script.  
- Document all changes in `MIGRATIONS.md` and reference them in the changelog.

---

### 5.12. Do & Don’t

**Do**
- Use explicit `ondelete` on `Many2one`.  
- Batch compute; keep `@api.depends` minimal.  
- Track important lifecycle fields with `tracking=True`.  
- Centralize selections in constants.

**Don’t**
- Don’t use `Json` as a shortcut for unmodeled data when relations suffice.  
- Don’t overuse `related` with long chains — compute instead.  
- Don’t store redundant denormalized data without justification.  
- Don’t hide business logic in field defaults.

---

**Examples (balanced pattern)**
```python
class PartnerContract(models.Model):
    _name = "partner.contract"
    _description = "Partner Contract"

    name = fields.Char(index=True, required=True, string="Name")
    partner_id = fields.Many2one("res.partner", string="Customer", required=True, index=True, ondelete="restrict")
    currency_id = fields.Many2one("res.currency", string="Currency", required=True, ondelete="restrict")

    line_ids = fields.One2many(comodel_name="partner.contract.line", inverse_name="contract_id", copy=True)

    amount_total = fields.Monetary(string="Total", currency_field="currency_id", compute="_compute_amount", store=True)
    state = fields.Selection(selection=STATE, string="Status", default="draft", tracking=True, index=True, required=True)

    @api.depends("line_ids.amount")
    def _compute_amount(self):
        for record in self:
            record.amount_total = sum(record.line_ids.mapped("amount"))
```

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
## XX. Assets, OWL and JavaScript

*Content to be written: static structure, OWL 2.0, JS, accessibility.*

## XX. Module Checklist

### XX.1. General

- [ ] Ensure module follows naming conventions.
- [ ] Include a README file with module description and usage instructions.
- [ ] Add necessary documentation (docstrings, comments).

### XX.2. Code Quality

- [ ] Run linters and fix any issues.
- [ ] Write unit tests for all new features.
- [ ] Ensure all tests pass before merging.

### XX.3. Dependencies

- [ ] Declare all dependencies in `requirements.txt`.
- [ ] Ensure compatibility with supported Odoo versions.

### XX.4. Security

- [ ] Review code for security vulnerabilities.
- [ ] Follow best practices for handling sensitive data.

### XX.5. Performance

- [ ] Optimize code for performance where applicable.
- [ ] Include performance benchmarks if relevant.

### XX.6. Compliance

- [ ] Ensure compliance with Apik's development guidelines.
- [ ] Obtain necessary approvals before merging.

## XX. References

*Content to be written: external links to odoo documentation, OCA guidelines, other references.*


## XX. Security and Access Control

*Content to be written: groups, access files, rules, exceptions.*

See also: [Security](https://www.odoo.com/documentation/19.0/developer/reference/backend/security.html)


## XX. Translations

*Content to be written: how to translate, what to translate, best practices.*


## XX. UI/UX Guidelines

*Content to be written: design principles, user research, accessibility, best practices.*


## XX. Views

*Content to be written: structure, view names, widgets, usability.*