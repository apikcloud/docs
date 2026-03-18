<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 99-examples/02-odoo-examples/04-views
Project: apikcloud/docs
Last update: 2026-03-02
Status: Draft
Reviewer: 
-->

# Views

Each example shows a **Bad** and a **Good** pattern with a brief rationale.

## 1. Views: use XML inheritance (`xpath`) rather than copy-pasting entire views

**Don't**

```xml
<record id="view_partner_form" model="ir.ui.view">
    <field name="name" ref="view.partner.form"/>
    <field name="arch" type="xml">
        <!-- Copied full form view here -->
    </field>
</record>
```

**Do**

```xml
<record id="view_partner_form" model="ir.ui.view">
    <field name="name" ref="view.partner.form"/>
    <field name="inherit_id" ref="base.view_partner_form"/>
    <field name="arch" type="xml">
        <xpath expr="//group[@name='contact']" position="inside">
            <field name="trust_score"/>
        </xpath>
    </field>
</record>
```

**Why:**  
Inheritance is robust to upstream changes and reduces churn. [Ref: Views / View records]

## 2. External IDs & data files: stable `xml_id`, `noupdate`, and references

**Don't**

```XML
<odoo>
    <record id="partner_tag_vip" model="res.partner.category">
        <field name="name">VIP</field>
    </record>
</odoo>
```

**Do**

```XML
<odoo noupdate="1">
    <record id="partner_tag_vip" model="res.partner.category">
        <field name="name">VIP</field>
    </record>
</odoo>
```

**Why:**  
Stable `xml_id` and `noupdate="1"` prevent accidental updates on re-install; makes refs with `env.ref()`
reliable. [Ref: Developer docs]
