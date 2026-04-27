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

# Vues

Chaque point montre un exemple **Mauvais** et **Bon**, accompagnés d'une brève explication.

## 1. Vues : utilisez l’héritage XML (`xpath`) plutôt que de copier-coller des vues entières.

**Ne pas faire**

```xml
<record id="view_partner_form" model="ir.ui.view">
    <field name="name" ref="view.partner.form"/>
    <field name="arch" type="xml">
        <!-- Copied full form view here -->
    </field>
</record>
```

**Faire**

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

**Pourquoi :**<br> L'héritage est robuste face aux modifications en amont et réduit le taux de renouvellement. [Réf. : Vues / Consulter les enregistrements]

## 2. Identifiants externes et fichiers de données : stable `xml_id`, `noupdate` et références

**Ne pas faire**

```XML
<odoo>
    <record id="partner_tag_vip" model="res.partner.category">
        <field name="name">VIP</field>
    </record>
</odoo>
```

**Faire**

```XML
<odoo noupdate="1">
    <record id="partner_tag_vip" model="res.partner.category">
        <field name="name">VIP</field>
    </record>
</odoo>
```

**Pourquoi :**<br> L'utilisation `xml_id` stable et `noupdate="1"` empêche les mises à jour accidentelles lors d'une réinstallation ; elle rend les références avec `env.ref()` fiables. [Réf. : Documentation pour les développeurs]
