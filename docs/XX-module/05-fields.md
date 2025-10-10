# Fields

This document defines how to **design, name, and configure fields** in Odoo addons.  
It complements the pages on **Models** and **Methods**.

---

## 1. Field Types (quick map)

| Category | Types | Notes |
|---------|------|-------|
| **Basic** | `Char`, `Text`, `Html`, `Boolean`, `Integer`, `Float`, `Date`, `Datetime`, `Binary` | Prefer `Char(index=True)` for searchable short strings |
| **Money & Numbers** | `Monetary`, `Float`, `Integer` | `Monetary` requires `currency_field` |
| **Relational** | `Many2one`, `One2many`, `Many2many` | Always set `comodel_name`; define `ondelete` for `Many2one` |
| **Selection** | `Selection` | Keep choices stable; use constants |
| **Specialized** | `Json`, `Reference` | Use sparingly; document the schema clearly |

---

## 2. Naming & Labels

- **Technical name**: `snake_case`, short, descriptive (`amount_total`, `partner_ref`).  
- **String/label**: concise, user‑facing, **translated** (`string="Amount Total"`).  
- **Help**: add `help="..."` for non‑obvious fields; short and actionable.  
- **Copy**: set `copy=False` for fields that should not duplicate on record copy (e.g., states, numbers).

**Example**
```python
amount_total = fields.Monetary(string="Total", currency_field="currency_id", help="Computed total in order currency.")
```

---

## 3. Relational Fields

### 3.1 Many2one
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

### 3.2 One2many
```python
line_ids = fields.One2many(comodel_name="apik_contract.line", copy=True, inverse_name="contract_id", string="Lines")
```
**Rules**
- `inverse_name` must exist and be indexed if used in domains/aggregations.  
- Avoid massive onchanges triggered by large O2M; prefer explicit buttons or batches.

### 3.3 Many2many
```python
tag_ids = fields.Many2many("apik_contract.tag", string="Tags")
```
**Rules**
- Avoid M2M for data that needs ordering or extra attributes → use **O2M with detail model**.  
- When performance matters, ensure joins are selective (domains, indices on comodel).

---

## 4. Computed, Inverse, and Related

### 4.1 Computed
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

### 4.2 Inverse
Provide an inverse when users can edit a computed field and you need to **persist** that edit.
```python
rate = fields.Float(compute="_compute_rate", inverse="_inverse_rate", store=True)
def _inverse_rate(self): ...
```

### 4.3 Related
```python
company_currency_id = fields.Many2one(related="company_id.currency_id", store=True)
```
**Rules**
- Use `related` for 1‑to‑1 derivations; add `store=True` if used in search/sort.  
- Do not chain long `related` paths; compute with a helper instead.

---

## 5. Selections & Enums

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

## 6. Money, Currency, and Precision

```python
currency_id = fields.Many2one("res.currency", string="Currency", required=True, ondelete="restrict")
amount_total = fields.Monetary(currency_field="currency_id", string="Total", digits="Product Price")
```
**Rules**
- Always provide `currency_field` for `Monetary`.  
- Use **named precisions** (`digits="Product Price"`) where business rules require it.  
- Avoid storing both **unit price** and **total** without justification; derive when possible.

---

## 7. Defaults, Readonly, Copy, Tracking

- `default=...` for safe defaults (functions allowed).  
- `readonly=True` for values users must not edit; pair with `states={...}` if needed.  
- `copy=False` for identifiers/sequences or transient state.  
- `tracking=True` on important business fields; use sparingly to avoid log noise.

---

## 8. Indexing & Searchability

- Add `index=True` on fields frequently used in domains or joins.  
- For text search, combine `index=True` on `Char` + a **search** helper if needed.  
- Use `read_group` for aggregations; avoid scanning large tables via Python.

---

## 9. Security & Multicompany

- Do **not** rely on Python to enforce access; define **ACLs** and **record rules**.  
- For multicompany fields, consider `company_dependent=True` or explicit company FK.  
- Validate cross‑company relations in `@api.constrains` when relevant.

---

## 10. Internationalization

- All `string`, `help`, and selection labels must be **translatable**.  
- Keep messages short and clear; avoid jargon in user‑facing labels.

---

## 11. Migrations & Stability

- Renaming a field breaks stable APIs; prefer **new field + migration** over renames.  
- When deprecating, keep the old field read‑only for a version and provide a data script.  
- Document all changes in `MIGRATIONS.md` and reference them in the changelog.

---

## 12. Do & Don’t

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