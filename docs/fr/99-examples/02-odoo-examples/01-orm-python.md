<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 99-examples/01-odoo-examples/01-orm-python
Project: apikcloud/docs
Last update: 2026-03-04
Status: Draft
Reviewer:
-->

# ORM et logique Python

Chaque point montre un exemple **Mauvais** et **Bon**, accompagnés d'une brève explication.

## 1. ORM : évitez le SQL brut lorsque l’ORM suffit

**Ne pas faire**

```python
self.env.cr.execute("UPDATE sale_order SET state='done' WHERE id=%s", order.id)
```

**Faire**

```python
order.write({"state": "done"})
```

**Pourquoi:**<br> L'ORM gère les métadonnées, les audits, les champs calculés et les règles d'accès. Le SQL brut les ignore. [Réf. : Recommandations de codage, API ORM]

## 2. Nommage des champs dans les méthodes de calcul : utilisez `record` ou `records`, et non `sales`, `partners`, etc.

**Ne pas faire**

```python
def _compute_total(self):
    for sale in self:
        sale.total = sum(line.price_total for line in sale.line_ids)
```

**Faire**

```python
def _compute_total(self):
    for record in self:
        record.total = sum(line.price_total for line in record.line_ids)
```

**Pourquoi:**<br> Les noms génériques permettent d'éviter toute confusion dans le code réutilisé. [Réf. : Recommandations de codage]

## 3. Champs calculés : déclarez les dépendances et stockez-les si nécessaire

**Ne pas faire**

```python
total = fields.Monetary(
    compute="_compute_total",
)


def _compute_total(self):
    for record in self:
        record.total = sum(line.price_total for line in record.line_ids)
```

**Faire**

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

**Pourquoi:**<br> `@api.depends` garantit un recalcul correct ; `store=True` si utilisé dans la recherche/le tri. [Réf. : API ORM]

## 4. Contexte et valeurs par défaut : évitez les variables globales, utilisez des lambdas avec des variables d’environnement

**Ne pas faire**

```python
company_id = fields.Many2one(
    comodel_name="res.company",
    default=self.env.company.id,
)
```

**Faire**

```python
company_id = fields.Many2one(
    comodel_name="res.company",
    default=lambda self: self.env.company.id,
)
```

**Pourquoi:**<br> Les valeurs par défaut doivent être des fonctions appelables pour obtenir l'environnement *actuel* et l'utilisateur/l'entreprise. [Réf. : API ORM]

## 5. Précision des comparaisons monétaires/de taux de change flottants : utiliser des fonctions auxiliaires

**Ne pas faire**

```python
if record.amount_total == 0.0:
    ...
```

**Faire**

```python
from odoo.tools.float_utils import float_is_zero

if float_is_zero(record.amount_total, precision_rounding=record.currency_id.rounding):
    ...
```

**Pourquoi:**<br> Respectez la précision des devises ; évitez l’égalité des nombres à virgule flottante. [Réf. : API ORM / outils]

## 6. Traductions : utilisez `_()` et évitez la concaténation de chaînes

**Ne pas faire**

```python
raise UserError("Order " + self.name + " is invalid")
```

**Faire**

```python
# Pour Odoo < 19.0
from odoo import _

raise UserError(_("Order %(name)s is invalid", name=self.name))

# Pour Odoo >= 19.0
raise UserError(self.env._("Order %(name)s is invalid", name=self.name))
```

**Pourquoi:**<br> Utilisez le balisage i18n pour les chaînes de caractères ; évitez la concaténation afin de garantir la traduisibilité des messages. [Réf. : Recommandations de codage]

## 7. Décorateurs d'API : respectez la convention d'appel de la méthode

**Ne pas faire**

```python
def create(vals_list):
    ...
```

**Faire**

```python
@api.model_create_multi
def create(self, vals_list):
    return super().create(vals_list)
```

**Pourquoi:**<br> Les décorateurs (`@api.model`, `@api.depends`, etc.) définissent les attentes et activent les fonctionnalités du framework. [Réf. : API ORM]
