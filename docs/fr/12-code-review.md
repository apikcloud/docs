<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 12-code-review
Project: apikcloud/docs
Last update: 2026-02-05
Status: Draft
Reviewer:
-->

# Guidelines pour la révision du code

<mark> Statut : Projet — En attente de révision et d'approbation</mark>

> Toutes les modifications de code chez Apik sont soumises à **un examen systématique** avant d'être fusionnées dans `main` .<br> L'évaluation est un élément clé de l'assurance qualité, de la cohérence technique et de l'apprentissage en équipe.

## Objectif

La revue de code garantit que chaque ligne de code entrant en production est :

- **Correcte** — fonctionnellement aligné sur l'objectif de la tâche ou de la fonctionnalité,
- **Cohérente** — conformément à la charte de développement interne d'Apik,
- **Maintenable** — claire, testée et structurée de manière logique,
- **Sécurisée** — exempte de vulnérabilités évidentes ou de raccourcis dangereux.

C'est aussi un moyen de **propriété partagée** : les relecteurs comprennent le code qu'ils approuvent.

## Périmètre et exceptions

### Revues obligatoires

- Toutes **les branches de features** ( `feat/<task>/<desc>` )
- Toutes **les corrections de bugs** ( `fix/<task>/<desc>` )
- Toute **refactorisation ou amélioration technique** ayant un impact sur les composants partagés

### Exceptions — « Mise à disposition accélérée »

On ne peut ignorer une évaluation *que* pour les raisons suivantes :

- Correctifs de production urgents faisant l'objet **d'une évaluation des risques** par le référent technique ou par un relecteur en l'absence de référent technique ou si celui-ci est indisponible.
- Intégration de **modules tiers** sans modifications internes.

Dans ce cas, un relecteur doit **examiner** le code après son déploiement et consigner l'exception dans le changelog du projet. De plus, le code doit être fusionné dans la `main` et dans toutes les balises présentes entre le code corrigé et la `main` , le cas échéant.

## Rôles

Rôle | Responsabilité
--- | ---
**Développeur (auteur)** | Ouvre la PR, fournit un contexte clair, répond aux commentaires, fusionne avec la branche principale une fois validée.
**Relecteur** | Vérifie la qualité, le style, les performances et la maintenabilité du code
**Référent technique (facultatif)** | Possède une vision globale du projet et peut donner son avis si nécessaire.
**QA (facultatif)** | Teste le comportement fonctionnel lorsque cela est pertinent

Une demande de fusion doit recevoir au moins **une approbation** d'un réviseur désigné avant d'être fusionnée.

## Processus de relecture

### Étape 1 — Préparer la relecture

- Rebasez votre branche sur la dernière `main` ( `git fetch && git rebase origin/main` ).
- Assurez-vous que tous les tests réussissent en local et que les vérifications préalables à la validation aboutissent.
- Squash vos commits si nécessaire (voir [`COMMITS.md`](./09-commits.md) ).
- Ouvrez une Pull Request avec :
    - un titre descriptif (fonctionnalité ou correctif),
    - optionnellement, la portée du commit (par exemple « projet », « mrp », « site web »),
    - un résumé clair de l'objectif et de l'impact,
    - référence à l'ID de la tâche (pour une seule tâche : `[#12345]` , pour plusieurs tâches : `[#12345, #12346]` ).

> **Remarque** : Pour les développements de grande envergure, il est recommandé de solliciter le relecteur même si le développement n’est pas terminé. Cela lui permet de donner son avis et d’éviter une relecture trop longue.
>
> Éviter les revues importantes permet également d'éviter les goulots d'étranglement pour tous les autres projets.

### Étape 2 — Réaliser la relecture

Les relecteurs doivent :

- Lire la description de la tâche et le résumé de la PR.
- Lire le code, pas seulement les différences — comprendre l'intention.
- Se concentrer sur *le pourquoi* et *le comment* , et non sur les préférences stylistiques personnelles.
- Vérifier :
    - Les fonctionnalités et régressions
    - Les implications en matière de performance
    - La sécurité / exposition des données
    - La couverture des tests (existante ou nouvelle)
    - Les nommage, clarté et commentaires
    - Le respect des règles de style et des directives de codage d'Apik

Outils optionnels :

- `ruff` , `pylint-odoo` et hooks pre-commit (doivent passer avant la revue).
- Si les hooks de pré-commit ne sont pas validés, le développeur doit indiquer au relecteur quels hooks échouent.
- Logs Odoo et tests fonctionnels en environnement de développement/préproduction.

> **Remarque** : En cas de non-respect des guidelines, la revue de code est immédiatement rejetée. Exemples :
>
> - Un commit avec le titre « fix » au lieu de « fix: … »
> - En-tête sans copyright
> - Aucun ID de tâche dans le message de commit
> - Nom de module/fichier incorrect
> - Les hooks de pré-commit ne passent pas, etc.
>
> Cette méthode permet d'éviter les discussions inutiles et de ne pas consacrer trop de temps à la relecture, le temps imparti étant limité.

### Étape 3 — Commentaires et collaboration

- Veillez à ce que vos commentaires **soient constructifs et concis** .
- Préférez **les suggestions aux impératifs** .
- En cas de doute, demandez des précisions — ne bloquez pas inutilement.
- Il incombe à l'auteur de prendre en compte les commentaires et de solliciter une nouvelle révision.

## Règles de rétroaction

Il existe trois types de retours d'information : critiques, suggestions et questions.

Tous les commentaires peuvent être discutés avec le relecteur en cas de désaccord ou de malentendu.

### Critique

- Indiqué par un :x:.
- Utilisé pour les bugs, les problèmes d'optimisation ou les gros problèmes de lisibilité.
- Il **faut** les corriger.

### Suggestion

- Utilisé pour corriger de petits problèmes de lisibilité, apporter des améliorations ou suggérer une alternative.
- Elles sont **facultatives** .
- Si elles sont ignorées, le développeur doit en expliquer la raison, afin d'en assurer le suivi.
- Même si les suggestions sont validées par le développeur, il doit y avoir au moins un commentaire reconnaissant que les suggestions sont comprises et utilisées efficacement, et non pas simplement copiées-collées.

### Question

- Utilisé lorsqu'il faut davantage d'informations ou de contexte pour comprendre et formuler une suggestion.
- Ces questions **doivent être répondues** par le développeur.

## Règles de merge

- **Les merges avec `main` se font via « Squash &amp; merge » ou « Rebase and merge »** .
- Le message de commit final doit respecter le format des [Conventionnal Commits](./09-commits.md) .
- Aucun commit de merge (les merges `--no-ff` sont interdites).
- Les branches doivent être rebasées avant le merge afin de garantir un historique linéaire.
- Le relecteur a le **dernier mot** quant à savoir si la branche est prête.

Un merge signifie :

> « Cette fonctionnalité est prête pour la phase de test et peut être déployée. »

## Critères de qualité des relectures

Une évaluation est considérée comme terminée lorsque :

- Toutes les discussions sont closes.
- Le style et les conventions du code sont respectés.
- Des tests (unitaires ou fonctionnels) sont en place ou justifiés.
- Le relecteur peut expliquer le but de la modification.

Évitez les approbations automatiques : chaque approbation doit être **une décision éclairée** .

## Règles de conduite pour les avis

- Partons du principe que les intentions sont bonnes.
- Félicitez ce qui a bien été fait avant de relever les améliorations.
- Distinguer les faits des opinions.
- Ne bloquez pas indéfiniment ; faites appel au référent technique si nécessaire.
- Utilisez les versions préliminaires des demandes de merge pour obtenir des retours rapides — tout ne doit pas nécessairement être définitif.

## Constatations courantes lors des examens (à surveiller)

- Droits d'accès manquants ou incorrects dans les modèles Odoo.
- Requêtes SQL sans limites ni filtres de contexte.
- Redéfinition des méthodes principales sans appeler `super()` .
- Importations inutilisées, code mort ou messages de débogage.
- Dépendance manquante dans `__manifest__.py` .
- Absence de `@api.constrains` ou `@api.depends` lorsque nécessaire.
- Des chaînes de caractères codées en dur au lieu de traductions.
- Perte de données.

## Liste de vérification pour les relecteurs

- [ ] Le code s'exécute sans erreur en local.
- [ ] Les modifications suivent les règles de dénomination et de structure.
- [ ] Aucune donnée sensible ni identifiant dans le code.
- [ ] Le message de commit et la description de la PR sont clairs.
- [ ] Les tests (le cas échéant) couvrent les chemins critiques.
- [ ] Aucune dépendance inutile ajoutée.
- [ ] La lisibilité et la clarté du code sont acceptables.
- [ ] Référence de la tâche incluse.
