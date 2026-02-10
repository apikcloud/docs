<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 09-commits
Project: apikcloud/docs
Last update: 2026-02-05
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
<type>(optional scope): <short summary> [#task]

[optional body]
```

**Exemple**

```
feat(account): add invoice merge wizard [#123456]

This introduces a new wizard allowing users to merge multiple draft invoices.
```

Un commit ne contient ni majuscules, ni point final, ni espace. De plus, l'identifiant de la tâche doit être placé entre crochets et précédé d'un dièse (#).<br> Tout commit ne respectant pas cette convention sera rejeté.

## Types

Les principaux types que vous devriez utiliser sont listés ci-dessous. En tant que développeur, vous utiliserez principalement les suivants : `feat` , `fix` , `release` .

Type | Signification | Exemple
--- | --- | ---
**feat** | Nouvelle fonctionnalité | `feat(mail): support DKIM signature [#12345]`
**fix** | Correction de bug | `fix(project): avoid crash on archived tasks [#12345]`
**release** | Préparer une nouvelle release | `release: v1.2.0 [#12345]`
**style** | Style de code, formatage, virgules manquantes, etc. | `style(account): reformat import wizard [#12345]`
**revert** | Annuler un commit précédent | `revert: fix(account): wrong domain in partner search [#12345]`
**test** | Ajouter ou mettre à jour les tests | `test(project): add regression test for task stages [#12345]`
**refactor** | Modification interne du code sans changement de comportement | `refactor(base): simplify partner search domain [#12345]`
**docs** | Modification de la documentation | `docs: add deployment workflow diagram [#12345]`
**chore** | Maintenance ou outillage | `chore(ci): upgrade pre-commit hooks [#12345]`
**ci** | Configuration ou scripts CI/CD | `ci(github): parallelize test workflow [#12345]`
**perf** | Amélioration des performances | `perf(account): optimize reconciliation lookup [#12345]`
**build** | Modifications apportées au système de build, aux dépendances, à Docker, etc. | `build(docker): bump Python base image [#12345]`

## Champ d'application

La **portée** indique la partie du système concernée ; elle est **facultative,** mais fortement recommandée, car elle est utile lorsque :

- Le projet est vaste ou modulaire (ex : modules Odoo, CI, Docker, infrastructure).
- Vous souhaitez filtrer les commits par zone.

> **Remarque** : Si vous ne savez pas quelle portée utiliser, il est préférable de **ne pas** en utiliser.

**Portées typiques**

```
account, project, mail, mrp, helpdesk, crm, ci, infra, docker, tests, docs
```

## Règles relatives au contenu

- Une modification logique par commit (**commits atomiques**).
- La première ligne ne doit pas dépasser **72 caractères** .
- Expliquez *pourquoi* lorsque la raison n'est pas évidente.
- Mettre en évidence les détails techniques importants lorsque cela est nécessaire.
- Évitez les messages vagues comme « update », « fix issue », « stuff ».
- Veuillez vous référer à la tâche associée, le cas échéant :
    ```
    feat: add mail alias sync [#12345]
    ```
- Avant la fusion, **effectuez un squash ou un rebase** pour conserver un historique linéaire propre.

## Conseils

- Rédigez un résumé court et clair.
- Utilisez le corps du texte pour décrire le contexte ou la motivation, si nécessaire.
- Utilisez le corps du texte pour mettre en évidence les détails techniques qui pourraient aider d'autres développeurs.
- Évitez les messages sans signification (« update », « minor change », « final »).
- La constance est plus importante que la perfection.

## Pourquoi c'est important

Un historique lisible = des reviews plus rapides, des changelogs plus clairs et un dépannage plus facile.<br>Chaque commit est un fil conducteur pour les futurs développeurs — faites-en des utiles.
