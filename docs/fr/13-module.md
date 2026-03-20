<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 13-module
Project: apikcloud/docs
Last update: 2026-03-04
Status: Draft
Reviewer:
-->

# Guideline des modules

<mark> Statut : Projet — En attente de révision et d'approbation</mark>

> Cette section présente les directives spécifiques aux modules complémentaires Odoo développés par Apik. Elle aborde les conventions de nommage, la structure des modules, les exigences relatives au manifest, les définitions de modèles, l'utilisation des champs et l'implémentation des méthodes.

## 1. Conventions de nommage

### Règles

- **Noms des modules** : préfixe `apik_` pour tous les modules complémentaires spécifiques à Apik (par exemple, `apik_brand`, `apik_filter`)
- **En-têtes de fichiers** : Tous les fichiers incluent un en-tête de droit d'auteur : `# Copyright 2026 apik (https://apik.cloud).`

## 2. Modèle de structure

Tous les modules suivent la structure standard d'Odoo avec les conventions spécifiques à Apik :

```
addon_name/
├── __init__.py           # Import models, controllers, wizards
├── __manifest__.py       # Standard Odoo manifest with Apik metadata
├── controllers/          # HTTP controllers (website addons)
├── i18n/                 # Translation files
├── models/               # Business logic models
├── security/             # ir.model.access.csv, security groups
└── static/               # Assets: JS, CSS, images
    └── description/      # Icon and readme for the module
    └── src/js/           # JavaScript modules using @odoo-module
    └── src/scss/         # Stylesheets
├── views/                # XML view definitions
├── wizards/              # Transient models for wizards
```

## 3. Guideline du manifest

### Structure du manifest

Suivez ce modèle pour le `__manifest__.py` dans tous les modules Apik :

```python
# Copyright 2026 apik (https://apik.cloud).
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

**Règles :**

- Le champ `name` doit être unique pour tous les modules.

- Le champ `summary` doit fournir une description concise des fonctionnalités du module.

- Le champ `version` doit respecter le format de versionnement sémantique (MAJOR.MINOR.PATCH).

- Le champ `category` doit refléter fidèlement l’objectif et les fonctionnalités du module.

- Le champ `author` doit être défini sur « Apik ».

- Le champ `maintainers` doit inclure les noms d’utilisateur GitHub de tous les responsables de la maintenance.

- Le champ `website` doit pointer vers le site web officiel d'Apik.

- Le champ `depends` doit lister tous les modules requis, y compris `base` .

- Le champ `data` doit inclure tous les fichiers XML nécessaires, classés par ordre alphabétique par section.

- Le champ `assets` doit inclure tous les fichiers JavaScript et feuilles de style requis, classés par ordre alphabétique.

- Les champs `installable` , `auto_install` , `application` et `license` doivent être définis comme indiqué dans l'exemple.

- **Licence** : Tous les modules utilisent la licence `LGPL-3`

> **Remarque** : Lorsque l'ordre alphabétique est impossible, veuillez ajouter un commentaire à la fin de la ligne pour expliquer pourquoi.

## 4. Gestion des versions

Après chaque modification d'un module, la version dans le manifeste doit être mise à jour. Ceci est fait pour les deux raisons principales suivantes :

- Facilité d'identification de la version du module dans la liste des modules installés.
- Assure que les modules sont automatiquement mis à jour lors du développement de projets Odoo Sh.

Lors de la mise à jour d'un module, veuillez respecter la convention SemVer comme mentionné. La procédure est identique à celle décrite dans le CHANGELOG.

## 5. Modèles

Ce document définit **comment concevoir, nommer et organiser les modèles** dans les modules Odoo.<br> Elle complète les pages sur **les méthodes** et **les champs** .

---

### 1. Types de modèles (et quand les utiliser)

Type | Classe de base | But | Utilisation typique
--- | --- | --- | ---
**Persistant** | `models.Model` | Données stockées | Partenaires, commandes, factures
**Transitoire** | `models.TransientModel` | Menus éphémères ; nettoyage automatique | Assistants, boîtes d'import/export
**Abstrait** | `models.AbstractModel` | Partager le comportement via l'héritage (sans table) | Mixins, comportements réutilisables, par exemple `mail.thread`, `mail.activity.mixin`, `portal.mixin`

**Règles**

- Utilisez **TransientModel** si les données ne doivent **pas** survivre au nettoyage de la mémoire.
- Utilisez **AbstractModel** pour **réutiliser les comportements** , et non pour stocker des données.
- Privilégiez **les mixins** à la réimplémentation des fonctionnalités génériques (mail, portail, séquence, évaluation).

---

### 2. Conventions de nommage

#### 2.1 Nom du modèle technique (`_name`)

- Use **namespace prefix** of your addon: `your_addon.model_name`.
- Use **singular nouns** for entities (`sale.order`, `account.move`, `product.brand`).
- Keep it **short and descriptive** (under ~40 chars).

**Exemples**

```python
_name = "product.brand"
_name = "move.chatter.history"
```

#### 2.2 Nom de la classe Python

- Utilisez les **CapWords** (PEP 8) : `Contract`, `SalesSubscription`.

#### 2.3 Nom d'affichage et ordre

- Définissez `_rec_name` si le `name` par défaut ne correspond pas à l'étiquette correcte.
- Définissez `_order` pour un listage déterministe (évitez les expressions lentes).

**Exemple**

```python
_rec_name = "display_name"
_order = "date_start desc, id desc"
```

---

### 3. Héritage des modèles

#### 3.1 Héritage classique (`_inherit`)

Étend un modèle existant (même table).<br> À utiliser pour ajouter des champs/comportements sans modifier l'identité.

```python
class ResPartner(models.Model):
    _inherit = "res.partner"

    loyalty_points = fields.Integer(
        default=0,
    )
```

**Règles**

- Limitez les surcharges **au strict minimum** ; déléguez la logique aux fonctions d'assistance.
- Documentez l'intention fonctionnelle dans une courte documentation de classe.

#### 3.2 Héritage par délégation ( `_inherits` )

Crée un autre modèle via une clé étrangère (tables séparées).<br> Utilisez-le lorsque votre modèle nécessite une relation « **est-un** + **a-un »** .

```python
class LibraryMember(models.Model):
    _name = "library.member"
    _inherits = {"res.partner": "partner_id"}

    partner_id = fields.Many2one(
        comodel_name="res.partner",
        ondelete="cascade",
        required=True,
    )
```

**Règles**

- Choose `_inherits` when you need partner fields **and** your own identity/table.
- Keep FK field names explicit: `<model>_id` (e.g., `partner_id`).

#### 3.3 Modèles abstraits

Fournir un comportement et des contraintes sans tableau.

```python
class ExportHelper(models.AbstractModel):
    _name = "export.helper"
    _description = "Export helpers"
```

**Règles**

- Aucun champ stocké, à l'exception des fonctions auxiliaires calculées sans stockage.
- Maintenez **la stabilité** de l'API ; traitez-la comme un contrat public pour votre extension.

---

### 4. Organisation de la classe (ordre et sections)

Conservez un **ordre de blocs cohérent** à l'intérieur de chaque classe de modèle :

1. **Meta** : `_name`, `_inherit`/`_inherits`, `_description`,  `_rec_name`, `_order`
2. **Defaults** : valeurs par défaut des champs
3. **Fields** : ordre alphabétique
4. **SQL constraints**: `_sql_constraints`
5. **Methods** : toutes les méthodes, voir **XX-Méthodes** pour plus de détails

**Exemple de squelette**

```python
class ResContract(models.Model):
    # 1) Meta
    _name = "res.contract"
    _description = "Contract"

    # 2) Defaults
    def _default_date_start(self):
        return fields.Date.today()

    # 3) Fields
    amount_total = fields.Monetary(
        currency_field="currency_id",
    )
    contract_type = fields.Selection(
        selection=[
            ("fixed", "Fixed"),
            ("variable", "Variable")
        ],
    )
    currency_id = fields.Many2one(
        comodel_name="res.currency",
        required=True,
    )
    date_end = fields.Date()
    date_start = fields.Date(
        default="_default_date_start",
        required=True,
    )
    name = fields.Char(
        index=True,
        required=True,
    )
    partner_id = fields.Many2one(
        comodel_name="res.partner",
        ondelete="restrict",
        required=True,
    )
    state = fields.Selection(
        selection=[("draft", "Draft"), ("active", "Active"), ("closed", "Closed")],
        default="draft",
    )

    # 4) SQL constraints
    _sql_constraints = [
        ("date_range_ok", "CHECK(date_end IS NULL OR date_end >= date_start)", "End date must be after start date."),
        ("name_unique_partner", "unique(name, partner_id)", "Contract name must be unique per partner."),
    ]

    # 5) Methods
    # -------------------
    # API related methods
    # -------------------
    # Constraints
    @api.constrains("date_start", "date_end")
    def _check_dates(self):
        for record in self:
            if record.date_end and record.date_end < record.date_start:
                raise ValidationError("End date must be after start date.")

    # Depends
    @api.depends("line_ids.amount")
    def _compute_amount_total(self):
        for record in self:
            record.amount_total = sum(record.line_ids.mapped("amount"))

    # Onchange
    @api.onchange("contract_type")
    def _onchange_contract_type(self):
        self.partner_id = False

    # ------------
    # CRUD methods
    # ------------
    @api.model_create_multi
    def create(self, vals_list):
        records = super().create(vals_list)
        records._log_state_change(vals_list)
        return records

    def write(self, vals):
        res = super().write(vals)
        self._log_state_change(vals)
        return res

    def unlink(self):
        if self.filtered(lambda r: r.state == "active"):
            raise UserError("Cannot delete active contracts.")
        return super().unlink()

    # --------------
    # Public methods
    # --------------
    def action_activate(self):
        self.filtered(lambda r: r.state == "draft").write({"state": "active"})
        return True

    # ---------------
    # Private methods
    # ---------------
    def _log_state_change(self, vals):
        if "state" in vals:
            _logger.info("Contract %s changed to %s", self.ids, vals["state"])
```

---

### 5. Intégrité et contraintes des données

- Privilégiez **les contraintes SQL** pour les invariants qui doivent être respectés au niveau de la base de données (unicité, logique de date).
- Utilisez `@api.constrains` pour les vérifications au niveau Python nécessitant un contexte d'enregistrement.
- Utilisez explicitement **les politiques ondelete** (`restrict`, `cascade`, `set null`) sur les champs relationnels.
- Évitez de stocker des valeurs dénormalisées, sauf justification (et documentez pourquoi).

---

### 6. Sécurité et accès (niveau élevé)

- Définissez `ir.model.access.csv` pour les règles de création/lecture/écriture/dissociation par rôle.
- Utilisez **des règles d'enregistrement** pour l'accès basé sur le domaine ; veillez à ce qu'elles **soient aussi simples que possible**.
- Ne filtrez jamais entièrement la sécurité en Python — **appliquez-la dans les ACL et les règles**.

---

### 7. Internationalisation

- Utilisez `_(...)` pour toutes les chaînes visibles par l'utilisateur (étiquettes, erreurs).
- Veillez à ce que l'aide contextuelle/les infobulles soient concises et exploitables.

---

### 8. Considérations relatives à la performance

- Évitez les boucles par enregistrement dans les champs calculés — utilisez le traitement par lots avec `mapped()` ou les compréhensions d'ensembles.
- Préchargez les relations et utilisez `read_group` pour les agrégats.
- Indexez les champs fréquemment recherchés (`index=True`).
- Évitez les longues listes `@api.depends` ; ne dépendez que de ce qui est nécessaire.

---

### 9. Do &amp; Don’t

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

## 6. Champs

Ce document définit comment **concevoir, nommer et configurer les champs** dans les modules complémentaires Odoo.<br> Elle complète les pages sur **les modèles** et **les méthodes**.

---

### 5.1. Types de champs (carte rapide)

Catégorie | Types | Notes
--- | --- | ---
**Basique** | `Char`, `Text`, `Html`, `Boolean`, `Integer`, `Float`, `Date`, `Datetime`, `Binary` | Privilégiez `Char(index=True)` pour les chaînes courtes consultables.
**Devises et chiffres** | `Monetary`, `Float`, `Integer` | `Monetary` nécessite `currency_field`
**Relationnel** | `Many2one`, `One2many`, `Many2many` | Toujours définir `comodel_name` ; définir `ondelete` pour `Many2one`
**Sélection** | `Selection` | Veillez à la stabilité des choix ; utilisez des constantes.
**Spécialisé** | `Json`, `Reference` | À utiliser avec parcimonie ; documentez clairement le schéma.

---

### 5.2. Nommage et labels

- **Nom technique** : `snake_case`, court, descriptif (`amount_total`, `partner_ref`).
- **String/label** : concise, destinée à l'utilisateur, **traduite** (`string="Amount Total"`).
- **Aide** : ajoutez `help="..."` pour les champs non évidents ; court et exploitable.
- **Copie** : définissez `copy=False` pour les champs qui ne doivent pas être dupliqués sur la copie de l'enregistrement (par exemple, les états, les nombres).

**Exemple**

```python
amount_total = fields.Monetary(
    currency_field="currency_id",
    help="Computed total in order currency.",
    string="Total",
)
```

---

### 5.3. Ordre des attributs

Selon le type de champ, tous les attributs ne sont pas toujours pertinents.

Deux règles sont obligatoires :

- L'attribut `string` est toujours le dernier, car il est facultatif et présent dans tous les champs.
- L'attribut `help` est toujours l'avant-dernier (ou le dernier si `string` n'est pas définie).

> ⚠️ Sauf indication contraire dans une règle, l'ordre doit être alphabétique.

#### One2many, Many2many et Many2one

L'ordre des attributs spécifiques One2many, Many2many et Many2one doit être le suivant :

1. `comodel_name` doit toujours être le premier argument.
2. `inverse_name` (champs One2many uniquement).
3. `related` (champ relationnel uniquement).

##### Exemple

```python
relational_field_id = fields.One2many(
    comodel_name="res.partner",
    inverse_name="partner_id",  # Only for One2many
    copy=True,
    domain=[("active", "=", True)],
    groups="base.group_user",
    help="This is a relational field",
    string="Field name",
)
```

#### Selection

Les champs de sélection doivent avoir `selection` comme premier argument, ou `selection_add` s'il s'agit d'une extension d'un champ existant.

##### Exemple

```python
selection_field = fields.Selection(
    selection=[
        ("option1", "Option 1"),
        ("option2", "Option 2"),
    ],
)

inherited_selection_field = fields.Selection(
    selection_add=[
        ("option3", "Option 3"),
    ],
)
```

#### Monetary

Pour les champs `Moneratary`, l'attribut `currency_field`, si nécessaire, doit être écrit comme premier argument.

##### Exemple

```python
monetary_field = fields.Monetary(
    currency_field="currency_id",
    compute="_compute_monetary_field",
    copy=True,
    store=True,
)
```

---

### 5.4. Champs relationnels

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

- Spécifiez toujours `ondelete` : choisissez parmi `restrict`, `set null`, `cascade` (soyez explicite).
- Ajoutez `index=True` aux relations fréquemment consultées.
- Utilisez des noms significatifs : `<model>_id` (par exemple, `company_id`, `currency_id`).

#### One2many

```python
line_ids = fields.One2many(
    comodel_name="apik_contract.line",
    inverse_name="contract_id",
    copy=True,
    string="Lines",
)
```

**Règles**

- `inverse_name` doit exister et être indexé s'il est utilisé dans des domaines/agrégations.
- Évitez les modifications massives déclenchées par des O2M importants ; privilégiez les boutons explicites ou les lots.

#### Many2many

```python
tag_ids = fields.Many2many(
    comodel_name="apik_contract.tag",
    string="Tags",
)
```

**Règles**

- Évitez les M2M pour les données qui nécessitent un tri ou des attributs supplémentaires → utilisez des **O2M avec un modèle détaillé**.
- Lorsque la performance est importante, assurez-vous que les jointures sont sélectives (domaines, index sur le comodèle).

---

### 5.5. Computed, Inverse, and Related

#### Computed

```python
amount_total = fields.Monetary(
    compute="_compute_amount",
    currency_field="currency_id",
    store=True,
)


@api.depends("line_ids.amount", "currency_id")
def _compute_amount(self):
    ...
```

**Règles**

- Utilisez `store=True` pour les valeurs fréquemment utilisées dans les recherches/agrégations ou affichées dans les listes.
- Veillez à ce que `@api.depends(...)` **soit minimal et précis** afin de réduire les invalidations.
- Privilégiez **le traitement par lots** ; évitez les boucles par enregistrement.
- N'utilisez `compute_sudo=True` que si cela est strictement nécessaire et documenté.

#### Inverse

Fournissez une fonction inverse lorsque les utilisateurs peuvent modifier un champ calculé et que vous devez **conserver** cette modification.

```python
rate = fields.Float(
    compute="_compute_rate",
    inverse="_inverse_rate",
    store=True,
)


def _inverse_rate(self): ...
```

#### Related

```python
company_currency_id = fields.Many2one(
    comodel_name="res.currency",
    related="company_id.currency_id",
    store=True,
)
```

**Règles**

- Utilisez `related` pour les dérivations 1-à-1 ; ajoutez `store=True` si utilisé dans la recherche/le tri.
- N'enchaînez pas de longs chemins `related` ; utilisez plutôt une fonction auxiliaire pour effectuer les calculs.

---

### 5.6. Sélections et énumérations

```python
STATE = [
    ("draft", "Draft"),
    ("active", "Active"),
    ("closed", "Closed"),
]

state = fields.Selection(
    selection=STATE,
    default="draft",
    index=True,
    required=True,
    tracking=True,
    string="Status",
)
```

**Règles**

- Veillez à ce que les choix restent **stables** (modifier les clés interrompt les données/migrations).
- Centralisez les options sous forme **de constantes au niveau du module** .
- Utilisez `tracking=True` pour les champs de cycle de vie visibles par l'utilisateur.

---

### 5.7. Money, Currency, et Precision

```python
currency_id = fields.Many2one(
    comodel_name="res.currency",
    ondelete="restrict",
    required=True,
)
amount_total = fields.Monetary(
    currency_field="currency_id",
    digits="Product Price",
    string="Total",
)
```

**Règles**

- Fournissez toujours `currency_field` pour `Monetary`, uniquement si le champ de devise n'est pas nommé `currency_id` .
- Utilisez **des précisions nommées** (`digits="Product Price"`) lorsque les règles métier l'exigent.
- Évitez de stocker à la fois **le prix unitaire** et **le prix total** sans justification ; calculez-les lorsque cela est possible.

---

### 5.8. Defaults, Readonly, Copy, Tracking

- `default=...` pour des valeurs par défaut sûres (fonctions autorisées).
- `readonly=True` pour les valeurs que les utilisateurs ne doivent pas modifier ; à associer à `states={...}` si nécessaire.
- `copy=False` for identifiers/sequences or transient state.
- `tracking=True` sur les champs importants de l'entreprise ; utilisez-le avec parcimonie pour éviter le bruit dans les logs.

---

### 5.9. Indexation et recherche

- Ajoutez `index=True` aux champs fréquemment utilisés dans les domaines ou les jointures.
- Pour la recherche textuelle, combinez `index=True` sur `Char` + un assistant **de recherche** si nécessaire.
- Utilisez `read_group` pour les agrégations ; évitez de parcourir de grandes tables via Python.

---

### 5.10. Sécurité et multisociétés

- Ne vous fiez **pas** à Python pour imposer l'accès ; définissez **des ACL** et **enregistrez les règles** .
- Pour les champs multisociétés, envisagez `company_dependent=True` ou une clé étrangère explicite pour la société.
- Validez les relations inter-entreprises dans `@api.constrains` le cas échéant.

---

### 5.11. Internationalisation

- Tous les champs `string`, `help` et de sélection doivent être **traduisibles**.
- Rédigez des messages courts et clairs ; évitez le jargon dans les libellés destinés aux utilisateurs (principalement dans l'attribut `help` ).

---

### 5.12. Migrations et stabilité

- Renommer un champ perturbe les API stables ; privilégiez la **création d’un nouveau champ et la migration** plutôt que le renommage.
- Lors de la dépréciation, conservez l'ancien champ en lecture seule pour une version donnée et fournissez un script de données.
- Documentez toutes les modifications dans `MIGRATIONS.md` et référencez-les dans `CHANGELOG.md` .

---

### 5.13. Ce qu'il faut faire et ne pas faire

**Faire**

- Use explicit `ondelete` on `Many2one`.
- Batch compute; keep `@api.depends` minimal.
- Track important lifecycle fields with `tracking=True`.
- Centralize selections in constants.

**Ne pas faire**

- Don’t use `Json` as a shortcut for unmodeled data when relations suffice.
- Don’t overuse `related` with long chains — compute instead.
- Don’t store redundant denormalized data without justification.
- Don’t hide business logic in field defaults.

---

**Exemples (modèle équilibré)**

```python
class PartnerContract(models.Model):
    _name = "partner.contract"
    _description = "Partner Contract"

    amount_total = fields.Monetary(
        compute="_compute_amount",
        currency_field="currency_id",
        store=True,
        string="Total",
    )
    currency_id = fields.Many2one(
        comodel_name="res.currency",
        ondelete="restrict",
        required=True,
    )
    line_ids = fields.One2many(
        comodel_name="partner.contract.line",
        inverse_name="contract_id",
        copy=True,
    )
    name = fields.Char(
        index=True,
        required=True,
    )
    partner_id = fields.Many2one(
        comodel_name="res.partner",
        index=True,
        ondelete="restrict",
        required=True,
        string="Customer",
    )
    state = fields.Selection(
        selection=STATE,
        default="draft",
        index=True,
        required=True,
        tracking=True,
        string="Status",
    )

    # -------------------
    # API related methods
    # -------------------
    @api.depends("line_ids.amount")
    def _compute_amount(self):
        for record in self:
            record.amount_total = sum(record.line_ids.mapped("amount"))
```

## 7. Méthodes

Ce document définit **comment concevoir, nommer et ordonner les méthodes** dans les modules Odoo.<br> Cela s'applique aussi bien à la logique métier qu'au code au niveau du framework.

---

### 6.1. Types de méthodes dans Odoo

#### Méthodes métiers

Ces éléments implémentent la logique fonctionnelle de votre module (facturation, validation, etc.).<br> Elles sont généralement **appelées par des actions, des boutons ou des tâches cron**.

**Exemple**

```python
def action_validate(self):
    """Validate the invoice and trigger posting logic."""
    self.ensure_one()
    self._check_invoice_balanced()
    self.state = "posted"
    self._post_account_move()
```

**Règles**

- Utilisez des verbes descriptifs (`action_`, `generate_`, `export_`, `import_`).
- Doit être **idempotent** lorsque cela est possible (appeler deux fois sans risque).
- **Ne doit pas mélanger l'interface utilisateur et la logique** (ne pas `raise UserError` sauf dans la couche finale).

---

#### Framework Hooks

Methods used by Odoo internals or extending base models.<br> Examples: `create`, `write`, `unlink`, `copy`, `name_get`, `default_get`, `_compute_*`, `_inverse_*`, `_search_*`.

**Règles**

- Toujours appeler `super()` sauf si vous souhaitez explicitement bloquer la logique parente.
- Limitez les surcharges **au strict minimum** : déléguez la logique réelle à des fonctions d'assistance privées.
- Documentez chaque modification en précisant son objectif et ses contraintes.

**Exemple**

```python
def write(self, vals):
    """Override to log partner updates."""
    res = super().write(vals)
    self._log_partner_update(vals)
    return res
```

---

#### Assistants techniques

Fonctions d'assistance internes destinées à être réutilisées au sein du même modèle ou module.<br> Elles commencent par un underscore (_).

**Règles**

- Ne jamais utiliser à partir d'actions XML ou de modules externes.
- Doit contenir une logique simple et composable.
- Ne doit pas s'appuyer sur un contexte d'interface utilisateur transitoire (`self.env.context` est acceptable).

**Exemple**

```python
def _compute_due_date(self):
    self.due_date = self.invoice_date + timedelta(days=self.payment_term_days)
```

---

#### Décorateurs API

Odoo propose plusieurs décorateurs pour clarifier la portée des méthodes.

Décorateur | Usage | Exemple
--- | --- | ---
`@api.model` | Aucun enregistrement requis | utilitaires de configuration, `create_from_ui`
`@api.model_create_multi` | Accepte plusieurs valeurs simultanément | `create`
`@api.depends` | Compute fields dependencies | `_compute_total`
`@api.onchange` | Mise à jour automatique du frontend | `_onchange_partner_id`
`@api.constrains` | Validation constraints | `_check_amount_positive`
`@api.autovacuum` | Periodic cleanup tasks | `_gc_old_records`

**Règle générale :** utilisez le décorateur qui représente le mieux la **portée** logique, et non celui qui est le plus facile à coder.

---

### 6.2. Conventions de nommage des méthodes

#### Préfixes selon leur fonction

Préfixe | Signification | Exemple
--- | --- | ---
`action_` | Déclenché par l'utilisateur ou un bouton | `action_validate`, `action_send_email`
`_compute_` | Champ calculé | `_compute_amount_total`
`_onchange_` | Mise à jour automatique du frontend | `_onchange_partner_id`
`_inverse_` | Inverse du champ calculé | `_inverse_amount_total`
`_check_` | Validation interne | `_check_dates_coherence`
`_prepare_` | Renvoie un dictionnaire ou une structure de données | `_prepare_invoice_vals`
`_get_` | Récupère ou résout quelque chose | `_get_partner_data`
`_set_` | Attribution | `_set_state_draft`
`_run_` | Exécuté par le planificateur ou par lot | `_run_invoice_auto_post`
`_sync_` | Synchronisation avec un système externe | `_sync_customer_data`

#### Règles de nommage

- Utilisez **snake_case**, pas camelCase.
- Évitez les abréviations sauf si elles sont courantes (`qty`, `uom`).
- Utilisez **d'abord les verbes**, puis les objets (`_compute_total`, et non `_total_compute`).
- Les noms ne doivent pas dépasser **40 caractères**.

---

### 6.3. Ordre des méthodes dans les classes

Suivez un ordre prévisible et cohérent dans chaque modèle :

1. **Meta** (`_name`, `_inherit`, `_description`)
2. **Default** (_méthodes `_default_...`)
3. **Fields** (`name`, `state`, `partner_id`, etc.)
4. **Contraintes SQL** (`_sql_constraints`)
5. **Méthodes Constrain / Compute / Inverse / Onchange**
6. **CRUD** (`create`, `write`, `unlink`, etc.)
7. **Méthodes métiers publiques** (`action_...`)
8. **Fonctions d'assistance privées** (`_prepare_`, `_get_`, `_check_`, `_run_`)
9. **API / utilitaires d'intégration**
10. **Autovacuum / tâches cron**

**Exemple**

```python
class SaleOrder(models.Model):
    # 1) Meta
    _name = "sale.order"

    # 2) Defaults

    @api.model
    def _default_partner_id(self): ...

    # 3) Fields
    ...
    fields
    ...

    # 4) SQL constraints
    ...
    constraints
    ...

    # 5) Methods
    # Constraints
    @api.constrains("price_total")
    def _constrains_price_total(self): ...

    # Depends
    @api.depends("order_line.price_total")
    def _compute_amount_total(self): ...

    # Onchange
    @api.onchange("partner_id")
    def _onchange_partner_id(self): ...

    # 6) CRUD methods
    def write(self, vals): ...

    # 7) Public methods
    def action_confirm(self): ...

    # 8) Private methods
    def _prepare_invoice_vals(self): ...

    # 9) API methods
    def _sync_related_invoice(self): ...

    # 10) Cron tasks
    def cron_sync_invoices(self): ...
```

---

### 6.4. Documentation et typage

- Incluez toujours **des docstrings** pour les méthodes publiques et les méthodes surchargées.
- Utilisez **les indications de type** lorsque cela améliore la lisibilité (facultatif, mais recommandé).
- Les fonctions d'assistance privées peuvent omettre la documentation si celles-ci sont explicites.

**Exemple**

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

## XX. Migrations Scripts

*Content to be written: when to use, structure, best practices.*

## XX. Hooks

Hooks are special functions automatically called by Odoo during a module’s lifecycle.<br> They allow executing **custom logic before or after installation/uninstallation**, or at **server load time**.

Hook name | Arguments | Execution moment | Purpose / Typical use case | Remarks
--- | --- | --- | --- | ---
**`pre_init_hook`** | `cr` *(cursor)* | **Before module installation** | Prepare database structures or fix legacy data **before models are created**.<br>Example: rename SQL columns, remove obsolete constraints, create missing sequences. | Runs with no ORM, only SQL. Keep it short and idempotent.
**`post_init_hook`** | `cr, registry` | **Right after installation** | Finalize setup once the ORM and registry are ready.<br>Example: populate computed fields, initialize demo data, register external integrations. | Use only for first-time setup — **not for migrations**.
**`uninstall_hook`** | `cr, registry` | **After uninstallation** | Cleanup operations related to this module.<br>Example: delete orphaned records, unregister webhooks, remove temp data. | Should not alter data from other modules.
**`post_load`** *(undocumented)* | *(none)* | **At server load**, before registry initialization | Initialize **server-wide features** that apply across databases.<br>Example: monkey-patching, logging setup, registering HTTP controllers. | Very early in load sequence — no ORM, no models. Use sparingly.

---

### How to Declare

In your module’s `__manifest__.py`:

```python
{
    "pre_init_hook": "pre_init",
    "post_init_hook": "post_init",
    "uninstall_hook": "uninstall",
    "post_load": "after_load",  # not officially documented
}
```

In your module’s `__init__.py`:

```python
def pre_init(cr):
    # raw SQL operations before models exist
    pass


def post_init(cr, registry):
    # ORM-safe initialization right after install
    pass


def uninstall(cr, registry):
    # cleanup logic on uninstall
    pass


def after_load():
    # executed when the server loads modules
    pass
```

---

### Hooks vs. Scripts de migration

Les hooks sont **des outils d'aide au cycle de vie**, et non **des outils de migration de version**.<br> Lors de la mise à niveau d'un module entre versions, Odoo exécute automatiquement les scripts Python stockés dans :

```
mymodule/
 └── migrations/
     └── 18.0.1.0.0/
         └── post-migration.py
```

Les scripts de migration sont l'endroit idéal pour :

- Modifications du schéma (champs, contraintes)
- Transformations de données entre versions
- Champs de remplissage ou de recalcul
- Nettoyage des archives obsolètes

Les hooks, en revanche, ne servent qu'à **la configuration de l'installation/désinstallation** ou **à la logique d'exécution globale**.
