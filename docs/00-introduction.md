# 1. Introduction

Cette charte définit les **règles strictes** de développement applicables à tous les projets Odoo pris en charge par Apik. Elle s'adresse à toute personne amenée à écrire, modifier ou relire du code dans nos modules personnalisés ou génériques.

Elle a pour objectif de :

- Renforcer la qualité, la maintenabilité et la sécurité du code
- Garantir l'homogénéité entre projets et équipes
- Accélérer les relectures, corrections et évolutions
- Éviter les régressions et dérives techniques

Tout·e développeur·euse s’engage à :

- respecter intégralement cette charte pour tout nouveau développement,
- signaler tout écart ou dette technique par un ticket clair,
- ne jamais livrer de code sans relecture, test ni documentation minimale,
- contribuer à l’amélioration continue de la charte et de nos pratiques.

L’équipe de développement s’engage à :

- fournir un socle de développement stable, documenté, testé,
- maintenir les outils (CI, templates, linter, scaffold, pre-commit),
- diffuser les bonnes pratiques et former les nouveaux arrivants,
- garantir la qualité des livrables sur tous les périmètres Odoo.

Tout développement non conforme pourra être refusé en relecture.

## 1.1. Évolution de la charte

Cette charte est un document vivant. Elle est révisée à chaque changement majeur de version Odoo ou d’outillage. Les retours de l’équipe sont les bienvenus, mais les évolutions sont validées par le référent technique.

## 1.2. Organisation du document

Chaque chapitre est divisé en **règles strictes** (à respecter impérativement) et **recommandations de mise en œuvre** (à suivre systématiquement sauf cas très particuliers, documentés).

Des blocs d’exemples, schémas, ou extraits de code viendront illustrer les cas types dans les sections suivantes.