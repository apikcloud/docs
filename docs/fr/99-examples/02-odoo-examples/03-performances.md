<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 99-examples/01-odoo-examples/03-performances
Project: apikcloud/docs
Last update: 2026-03-02
Status: Draft
Reviewer:
-->

# Performances et filtrage

Chaque point montre un exemple **Mauvais** et **Bon**, accompagnés d'une brève explication.

## 1. Filtrage par domaine : privilégier les recherches par domaine au filtrage Python

**Ne pas faire**

```python
orders = self.search([])
paid_orders = orders.filtered(lambda o: o.state == "paid")
```

**Faire**

```python
paid_orders = self.search([("state", "=", "paid")])
```

**Pourquoi:**<br> Les domaines délèguent les tâches à la base de données ; meilleures performances et moins de mémoire.

## 2. Utilisez la méthode `filtered` pour les boucles principales

**Ne pas faire**

```python
def process(self):
    for record in self:
        if record.state == "draft":
            record.name = f"New {record.id}"
```

**Faire**

```python
def process(self):
    for record in self.filtered(lambda r: r.state == "draft"):
        record.name = f"New {record.id}"
```

**Pourquoi:**<br> `filtered()` améliore la lisibilité et évite les conditions imbriquées.

## 3. Évitez les boucles contenant `filtered`

**Ne pas faire**

```python
def process(self):
    for record in self:
        for posted_invoice in record.filtered(lambda r: r.state == "posted"):
            posted_invoice.singleton_post_action()

        for cancelled_invoice in record.filtered(lambda r: r.state == "cancelled"):
            cancelled_invoice.singleton_cancel_action()
```

**Faire**

```python
def process(self):
    for record in self:
        for posted_invoice in [r for r in record if r.state == "posted"]:
            posted_invoice.singleton_post_action()

        for cancelled_invoice in [r for r in record if r.state == "cancelled"]:
            cancelled_invoice.singleton_cancel_action()
```

**Pourquoi:**<br> L'imbrication de `filtered` engendre des problèmes de performance, car chaque `filtered` crée un nouvel ensemble d'enregistrements (`model.Models`). Il est bien plus efficace d'utiliser une liste en compréhension. Si vous devez utiliser un ensemble d'enregistrements (pour les méthodes non singleton), utilisez `filtered` et évitez de les exécuter dans une boucle.

## 4. Évitez d'utiliser `filtered_domain` si possible

**Ne pas faire**

```python
def process(self):
    posted_invoices = self.filtered_domain([("state", "=", "posted")])
```

**Faire**

```python
def process(self):
    posted_invoices = self.filtered(lambda r: r.state == "posted")
```

**Pourquoi:**<br> Le `filtered_domain` est la méthode de filtrage la plus lente. Consultez le graphique ci-dessous pour une comparaison des différentes méthodes de filtrage. `filtered_domain` ne doit être utilisé que lorsqu'il s'agit d'un domaine passé en argument et qu'il est dynamique.

Le graphique ci-dessous compare les différentes méthodes de filtrage dans Odoo. **Il n'inclut pas** l'utilisation de filtres à l'intérieur des boucles, qu'il convient d'éviter et de remplacer par des `if` si possible telles que les listes en compréhensions.

![filtering_comparison.png](../../../_media/img/filtering_comparison.png)
