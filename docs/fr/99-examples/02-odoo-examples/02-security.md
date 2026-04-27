<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 99-examples/01-odoo-examples/02-security
Project: apikcloud/docs
Last update: 2026-03-02
Status: Draft
Reviewer:
-->

# Sécurité

Chaque point montre un exemple **Mauvais** et **Bon**, accompagnés d'une brève explication.

## 1. Sécurité : n'utilisez pas `sudo()` à la légère

**Ne pas faire**

```python
records = self.sudo().search([("partner_id", "=", partner.id)])
```

**Faire**

```python
records = self.search([("partner_id", "=", partner.id)])
# If you *must* elevate, narrow scope and document why:
secure_records = self.sudo().browse(safe_ids)
```

**Pourquoi :**<br> `sudo()` contourne les ACL/règles d'enregistrement ; limitez son utilisation à une portée minimale.

## 2. Contraintes : utilisez `_check_*` ou des contraintes SQL plutôt que `onchange` pour garantir l’intégrité des données

**Ne pas faire**

```python
@api.onchange("qty")
def _onchange_qty(self):
    if self.qty < 0:
        self.qty = 0
```

**Faire**

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

**Pourquoi :**<br> Onchange est uniquement accessible via l'interface utilisateur ; les contraintes protègent les données côté serveur.

## 3. Règles d'accès plutôt que du code personnalisé

**Ne pas faire**

```python
def _is_visible(self):
    if self.env.user.login.endswith("@vip.com"):  # brittle
        return True
    return False
```

**Faire**

```text
# security/ir.model.access.csv + record rules on the model
```

**Pourquoi :**<br> Utilisez les ACL et consignez les règles d'accès aux données ; cela permet de rendre la sécurité déclarative et vérifiable.
