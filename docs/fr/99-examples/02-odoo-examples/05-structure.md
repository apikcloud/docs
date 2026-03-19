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

Chaque point montre un exemple **Mauvais** et **Bon**, accompagnés d'une brève explication.

## 1. Trier les importations par ordre alphabétique

**Ne pas faire**

```python
from odoo import models, fields, api
```

**Faire**

```python
from odoo import api, fields, models
```

**Pourquoi:**<br> Nous suivons la convention isort, qui est la convention par défaut pour Python.

## 2. Trier les champs Odoo par ordre alphabétique

**Ne pas faire**

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

**Faire**

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

**Pourquoi:**<br> Le tri alphabétique des champs facilite la recherche d'un champ spécifique dans le code et évite les champs en double.
