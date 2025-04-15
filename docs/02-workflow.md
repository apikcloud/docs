# 3. Workflow de développement (trunk-based)

## 3.1. Branches

- Une seule branche principale : `main`
- Toute fonctionnalité ou évolution passe par une branche éphémère : `feat/<ticket_id>/<resume>`
- Cette branche est supprimée après merge

## 3.2. Revue de code

- **Obligatoire** avant tout merge dans `main`
  
- La relecture est faite **par l'équipe qualité**, qui valide la conformité à la charte.
  
- Le développeur reste responsable des impacts, de la testabilité et de la compréhension de son code.
  

## 3.3. Exceptions : mise à disposition accélérée (MDA)

- Le seul cas où la relecture n’est pas exigée : **ajout d’un module sans modification de code** (mise à disposition fonctionnelle uniquement)
- Cette opération doit être signalée par un commentaire explicite dans la PR

## 3.4. Intégration continue

- Chaque push sur `main` déclenche :
  
  - un build Docker
  - des tests automatiques
  - un linter (black + flake8 + pylint-odoo)
  - une vérification de dépendances et manifest
- <mark>Usage raisonné</mark>
  

## 3.5. Commits

- Format : `[TAG] module_name: court résumé`
- Tags disponibles : `[ADD]`, `[FIX]`, `[IMP]`, `[REFAC]`, `[TEST]`, `[SECURITY]`, `[WIP]`
- Pas de commits mixtes (1 commit = 1 intention)
- Pas de merge commit sauf cas de portage ou de synchronisation exceptionnelle

## 3.6. Déploiement

- Toute livraison en préproduction ou production se base sur un **tag Git** créé depuis `main`
- Les tags suivent le format `v<major>.<minor>.<patch>` (semver)
- La génération d’un tag déclenche une image Docker estampillée du même tag