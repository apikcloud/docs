<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 09-commits
Project: aikcloud/docs
Last update: 2025-12-08
Status: Draft
Reviewer:
-->

# Directives pour commit

<mark> Statut : Projet — En attente de révision et d'approbation </mark>

> Les commits constituent l'unité de changement la plus petite et la plus significative.<br> Ils expliquent *pourquoi* le code existe, et pas seulement *ce qui* a été modifié.

## Convention de message

Nous suivons la spécification **[Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)** pour garantir la cohérence et l'automatisation des messages.

### Syntaxe

```
<type>(optional scope): <short summary>

[optional body]

[optional footer(s)]
```

**Exemple**

```
feat(account): add invoice merge wizard

This introduces a new wizard allowing users to merge multiple draft invoices.
Closes #1234
```

## Types

Type | Signification | Exemple
--- | --- | ---
**feat** | Nouvelle fonctionnalité | `feat(mail): support DKIM signature`
**fix** | Correction de bug | `fix(project): avoid crash on archived tasks`
**refactor** | Modification interne du code sans changement de comportement | `refactor(base): simplify partner search domain`
**docs** | Modification de la documentation | `docs: add deployment workflow diagram`
**style** | Style de code, formatage, virgules manquantes, etc. | `style(account): reformat import wizard`
**test** | Ajouter ou mettre à jour les tests | `test(project): add regression test for task stages`
**chore** | Maintenance ou outillage | `chore(ci): upgrade pre-commit hooks`
**build** | Modifications apportées au système de build, aux dépendances, à Docker, etc. | `build(docker): bump Python base image`
**perf** | Amélioration des performances | `perf(account): optimize reconciliation lookup`
**ci** | Configuration ou scripts CI/CD | `ci(github): parallelize test workflow`
**revert** | Annuler un commit précédent | `revert: fix(account): wrong domain in partner search`
**release** | Préparer une nouvelle release | `release: v1.2.0`

## Champ d'application

Le **champ d'application** indique la partie du système concernée ; il est facultatif, mais utile lorsque :

- Le projet est vaste ou modulaire (ex : modules Odoo, CI, Docker, infrastructure).
- Vous souhaitez filtrer les commits dans les changelogs par domaine.

**Portées typiques**

```
account, project, mail, base, docker, ci, infra, tests, docs
```

## Règles relatives au contenu

- Une modification logique par commit (**commits atomiques**).
- La première ligne ne doit pas dépasser **72 caractères** .
- Expliquez *pourquoi* lorsque la raison n'est pas évidente.
- Évitez les messages vagues comme « update », « fix issue », « stuff ».
- Veuillez vous référer au ticket correspondant, le cas échéant :
    ```
    feat: add mail alias sync [#1234]
    ```
- Avant la fusion, **effectuez un squash ou un rebase** pour conserver un historique linéaire propre.

## Conseils

- Rédigez un résumé court et clair.
- Utilisez le corps du texte pour décrire le contexte ou la motivation, si nécessaire.
- Référencez les problèmes ou les tickets avec `Closes #1234` ou `[AP-456]` .
- Évitez les messages sans signification (« update », « minor change », « final »).
- La constance est plus importante que la perfection.

## Pourquoi c'est important

Un historique lisible = des reviews plus rapides, des changelogs plus clairs et un dépannage plus facile.<br>Chaque commit est un fil conducteur pour les futurs développeurs — faites-en des utiles.
