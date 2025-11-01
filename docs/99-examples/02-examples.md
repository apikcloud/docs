# Odoo Code Quality Examples (Bad vs Good)

Each example shows a **Bad** and a **Good** pattern with a brief rationale.



## 1. ORM: avoid raw SQL when ORM suffices
 **Don't**
```python
self.env.cr.execute("UPDATE sale_order SET state='done' WHERE id=%s", (order.id,))
```
 **Do**
```python
order.write({"state": "done"})
```
**Why:** ORM handles metadata, audits, computed fields, and access rules. Raw SQL bypasses them. [Ref: Coding Guidelines, ORM API]



## 2. Computed fields: declare dependencies and store when needed
 **Don't**
```python
total = fields.Monetary(compute="_compute_total")

def _compute_total(self):
    for rec in self:
        rec.total = sum(l.price_total for l in rec.line_ids)
```
 **Do**
```python
total = fields.Monetary(compute="_compute_total", store=True)
@api.depends("line_ids.price_total")
def _compute_total(self):
    for record in self:
        record.total = sum(record.line_ids.mapped("price_total"))
```
**Why:** `@api.depends` ensures correct recompute; `store=True` if used in search/sort. [Ref: ORM API]



## 3. Fields naming in compute methods: use `record` or `records`, not `sales`, `partners`, etc.
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
**Why:** Generic names avoid confusion in reused code. [Ref: Coding Guidelines]

## 3. Security: don’t use `sudo()` casually
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
**Why:** `sudo()` bypasses ACLs/record rules; restrict it to minimal scope. [Ref: Security]



## 4. Constraints: use `_check_*` or SQL constraints over `onchange` for data integrity
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
_sql_constraints = [("qty_nonneg", "CHECK(qty >= 0)", "Quantity must be non-negative.")]
@api.constrains("qty")
def _check_qty(self):
    if any(r.qty < 0 for r in self):
        raise ValidationError("Quantity must be non-negative.")
```
**Why:** Onchange is UI-only; constraints protect data server-side. [Ref: ORM API]



## 5. Views: use XML inheritance (`xpath`) rather than copy-pasting entire views
 **Don't**
```xml
<record id="view_form_partner_custom" model="ir.ui.view">
  <field name="arch" type="xml">
    <!-- Copied full form view here -->
  </field>
</record>
```
 **Do**
```xml
<record id="view_form_partner_inherit_custom" model="ir.ui.view">
  <field name="inherit_id" ref="base.view_partner_form"/>
  <field name="arch" type="xml">
    <xpath expr="//group[@name='contact']" position="inside">
      <field name="x_trust_score"/>
    </xpath>
  </field>
</record>
```
**Why:** Inheritance is robust to upstream changes and reduces churn. [Ref: Views / View records]



## 6. External IDs & data files: stable `xml_id`, `noupdate`, and references
 **Don't**
```xml
<record id="tmp_partner_tag" model="res.partner.category"> ... </record>
```
 **Do**
```xml
<!-- data/tags.xml -->
<data noupdate="1">
  <record id="partner_tag_vip" model="res.partner.category">
    <field name="name">VIP</field>
  </record>
</data>
```
**Why:** Stable `xml_id` and `noupdate="1"` prevent accidental updates on re-install; makes refs with `env.ref()` reliable. [Ref: Developer docs]


## 7. Context and defaults: avoid globals, use lambdas with env
 **Don't**
```python
default_company_id = fields.Many2one("res.company", default=self.env.company.id)
```
 **Do**
```python
company_id = fields.Many2one("res.company", default=lambda self: self.env.company.id)
```
**Why:** Defaults must be callables to get the *current* env and user/company. [Ref: ORM API]


## 8. Precision for monetary/float comparisons: use helpers
 **Don't**
```python
if rec.amount_total == 0.0:
    ...
```
 **Do**
```python
from odoo.tools.float_utils import float_is_zero
if float_is_zero(rec.amount_total, precision_rounding=rec.currency_id.rounding):
    ...
```
**Why:** Respect currency precision; avoid equality on floats. [Ref: ORM API / tools]


## 9. Domain filtering: prefer domain searches to Python filtering
 **Don't**
```python
orders = self.search([])
paid = orders.filtered(lambda o: o.state == "paid")
```
 **Do**
```python
paid = self.search([("state", "=", "paid")])
```
**Why:** Domains push work to the database; better performance and less memory. [Ref: ORM API]



## 10. Translations: use `_()` and avoid string concatenation
 **Don't**
```python
raise UserError("Order " + self.name + " is invalid")
```
 **Do**
```python
from odoo import _
raise UserError(_("Order %s is invalid") % self.name)
```
**Why:** Mark strings for i18n; avoid concatenation to keep messages translatable. [Ref: Coding Guidelines]



## 11. API decorators: match the method’s calling convention
 **Don't**
```python
def create(vals):
    ...
```
 **Do**
```python
@api.model
def create(self, vals):
    return super().create(vals)
```
**Why:** Decorators (`@api.model`, `@api.depends`, etc.) declare expectations and enable framework features. [Ref: ORM API]



## 12. Access rules over custom code
 **Don't**
```python
def _can_see(self):
    if self.env.user.login.endswith("@vip.com"):  # brittle
        return True
    return False
```
 **Do**
```text
# security/ir.model.access.csv + record rules on the model
```
**Why:** Use ACLs and record rules for data access; keeps security declarative and reviewable. [Ref: Security]
