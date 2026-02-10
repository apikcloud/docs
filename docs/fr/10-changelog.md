<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 10-changelog
Project: apikcloud/docs
Last update: 2026-02-05
Status: Draft
Reviewer:
-->

# Changelog

<mark> Statut : Projet — En attente de révision et d'approbation</mark>

Ce document décrit notre méthode de rédaction et de mise à jour **manuelle** des journaux de modifications pour les projets Apik. Il complète notre flux de travail et la documentation de nos commits. Nous suivons les principes de [Keep a Changelog 1.1.0,](https://keepachangelog.com/en/1.1.0/) qui adhère au [versionnage sémantique](https://semver.org/spec/v2.0.0.html) , et rédigeons chaque entrée manuellement – ​​aucune génération automatique n'est utilisée.

## Objectif et public cible

> Le journal des modifications explique **les changements intervenus entre les versions** aux personnes qui ne consultent pas les commits : chefs de projet, assurance qualité, support et clients. Il met l’accent sur **l’impact et le comportement** , et non sur les détails d’implémentation.

Les chefs de projet ne consultent pas le journal des modifications avant la mise en production, mais ils doivent en avoir **la visibilité** :

- `CHANGELOG.md` est toujours disponible dans la branche principale.
- Les mises à jour sont incluses dans les résumés de version.

## Principes

- **Sélection humaine** : la clarté prime sur l’automatisation.
- **Versionné** : les entrées sont regroupées par **étiquette de version** ( `vX.YZ` ) et par date.
- **Axé sur l'impact** : inclure les changements que les utilisateurs ou les opérateurs remarqueront.
- **Ton neutre** : factuel, concis, sans marketing.
- **Format stable** : sections et formulations cohérentes.

## Critères d'inclusion

Inclure :

- Nouvelles fonctionnalités ou améliorations visibles.
- Corrections de bugs ayant un impact visible pour l'utilisateur.
- Mises à jour majeures ou modifiant le comportement.
- Migrations, dépréciations, suppressions.
- Améliorations des performances ou de la sécurité.
- Refontes à fort impact.

Exclure (sauf si critique) :

- Linting, style de code.
- Refactorisations à faible impact.
- CI, outils, mises à jour de compilation uniquement ou de dépendances.

> Si un chef de projet, un consultant ou un client **a besoin de le savoir** , c'est ici que ça doit être.

## Structure par version

```markdown
## [vX.Y.Z] — YYYY-MM-DD

### Added
- …

### Changed
- …

### Fixed
- …

### Removed
- …

### Migration Notes
- …
```

Facultatif :

- **Problèmes connus** : liste non exhaustive + solutions de contournement.

> **Remarque** : Une fois que le journal des modifications contient une entrée, la partie modèle du fichier doit être supprimée.

## Writing Rules

- **Une ligne par élément.**
- **Pas de préfixe** (« Added : », « Fixed : ») — la section le définit déjà.
- Commencez directement par l'action ou l'objet modifié.
- Limitez les lignes à moins de **120 caractères** .
- Utilisez des verbes forts et descriptifs ; évitez les formulations vagues.
- Aucun terme technique.

**Exemples (bons)**

[Voir l'exemple de modèle ci-dessous.](#template-example)

**Éviter**

```
- Added: various fixes
- Fixed bug
- Update stuff
- Change function button_confirm on stock.picking
```

## Relation entre Commits et Tâches

- **Commits** : techniques, atomiques, axés sur le développement.
- **Changelog** : résumé organisé et axé sur l'utilisateur.
- **Tâches** : le lien avec les tâches se fait via le commit.
- **Périmètre impacté** : indiqué de manière optionnelle dans le commit.

## Flux de travail d'équipe

1. **En cours de développement** : le développeur ajoute des lignes de Changelog provisoires dans la section « Unreleased ».
2. **Avant le tag** : *le référent technique* consolide et met en formate les entrées.
3. **Visibilité** : le chef de projet dispose d'un accès en lecture pour suivre le contenu des versions.
4. **Tag et publication** : `CHANGELOG.md` validé avec le tag.
5. **Post-release** : ajouter les problèmes connus si nécessaire ; l’historique reste immuable.

**Rôles**

- **Développeur** : brouillons d'entrées.
- **Réviseur (AQ)** : vérifie l'exactitude et la pertinence.
- **Référent technique** : mise en forme finale et portée.

## Guide spécifique à Odoo

- Mentionnez **les modèles** concernés par leur nom **humain** (par exemple, `purchase order` , `partner` ).
- Ne mentionnez pas **les extensions** concernées, sauf pour l'ajout, la mise à jour ou la suppression de modules OCA ou tiers. Dans ce cas, ajoutez un bref résumé de la description de l'extension afin d'en faciliter la compréhension.
- Signaler **les modifications apportées au modèle de données** (champs, contraintes, scripts).
- Veuillez noter les modifications apportées **aux droits d'accès**, **aux paramètres du serveur** ou **aux variables d'environnement**.
- Résumez **les étapes de migration** ; les procédures détaillées se trouvent dans `MIGRATION.md`.

## Exemple de modèle

```markdown
# Changelog

All notable changes to this project are documented here.

This changelog follows the [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) convention
and adheres to Apik’s internal [Changelog Guidelines](https://github.com/apikcloud/docs/docs/07-changelog.md).

The goal: provide a clear, user-focused history of what has changed, improved, or been fixed.

## [v1.5.0] — 2025-10-12

### Added

- Vendor bill OCR with manual fallback.
- Wizard to merge invoices.
- OCA module `partner_firstname` to split partners' names in two fields: first name
  and last name.

### Changed

- Rights management on sale order templates.
- Add the sum of initial amounts in contract form view.
- Disable the creation of products on the fly in the sale order templates.

### Fixed

- Block the possibility to change the product on sale orders after creation to avoid
  issues with components.
- Update Odoo version from `18.0-20250625-enterprise` to `18.0-20251215-enterprise` to
  fix a standard bug that duplicates content in the website.

### Migration Notes

- Update `mgdis_contract` before `mgdis_sales`.
```

## Liste de vérification de la mise en production

- [ ] Entrées regroupées par version et par date.
- [ ] Seuls les éléments ayant un impact sur l'utilisateur sont inclus.
- [ ] Ton cohérent, verbes clairs.
- [ ] Les changements importants et les mesures de sécurité sont mis en évidence.
- [ ] Notes de migration validées.
- [ ] Changelog validé avec le tag.
- [ ] Le chef de projet a accès à la visibilité.
