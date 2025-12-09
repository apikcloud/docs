<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 15-configuration
Project: aikcloud/docs
Last update: 2025-12-08
Status: Stable
Reviewer: royaurelien
-->

# Configuration Odoo

## Principes généraux

En production, Odoo doit fonctionner en mode multiprocessus (`workers > 0`). Le mode threaded (`workers = 0`) n'est prévu que pour le développement ou des usages très légers.

Les limites mémoire et temps s'appliquent **par worker**, et chaque worker est un processus isolé. Le dimensionnement repose donc surtout sur la RAM disponible.

Si `workers × limit_memory_hard` dépasse la RAM physique, le système risque de swapper, ralentir brutalement ou écraser des processus.

Les mécanismes de recyclage (`limit_request`, limites mémoire/temps) servent à garder des workers propres, éviter les dérives mémoire et empêcher qu'un traitement trop long bloque l'application.

Les limites mémoires sont exprimées en bytes. Les limites temps sont en secondes.

> Pour la suite de la documentation:  
> MiB = bytes / (1024 × 1024)  
> bytes = MiB × (1024 × 1024)  

---

## Paramètres clés (odoo.conf)

<!-- | Paramètre             | Description                                                                  |
| --------------------- | ---------------------------------------------------------------------------- |
| **workers** | Nombre de processus HTTP dédiés aux requêtes. |
| **limit_memory_soft** | Seuil mémoire à partir duquel un worker termine sa requête puis est recyclé. |
| **limit_memory_hard** | Seuil mémoire maximal. Si atteint, le worker est tué immédiatement. |
| **limit_request** | Nombre max de requêtes avant recyclage automatique (défaut : 65536). |
| **limit_time_cpu** | Temps CPU max autorisé par requête (défaut : 60 s). |
| **limit_time_real** | Durée réelle max pour une requête (défaut : 120 s). |
| **max_cron_threads** | Nombre de threads/process cron (défaut : 2). |
| **limit_time_real_cron** | Durée réelle max par tâche cron. (défaut : limit_time_real). Mettre à 0 pour aucune limite. |
| **limit_time_worker_cron** | Durée maximale pendant laquelle un thread/processus cron reste actif avant d'être redémarré. Mettre à 0 pour désactiver. (défaut : 0) | -->


- **workers** : Nombre de processus HTTP dédiés aux requêtes. 
- **limit_memory_soft** : Seuil mémoire à partir duquel un worker termine sa requête puis est recyclé. 
- **limit_memory_hard** : Seuil mémoire maximal. Si atteint, le worker est tué immédiatement. 
- **limit_request** : Nombre max de requêtes avant recyclage automatique (défaut : 65536). 
- **limit_time_cpu** : Temps CPU max autorisé par requête (défaut : 60s). 
- **limit_time_real** : Durée réelle max pour une requête (défaut : 120s). 
- **max_cron_threads** : Nombre de threads/process cron (défaut : 2). 
- **limit_time_real_cron** : Durée réelle max par tâche cron. (défaut : limit_time_real). Mettre à 0 pour aucune limite. 
- **limit_time_worker_cron** : Durée maximale pendant laquelle un thread/processus cron reste actif avant d'être redémarré. Mettre à 0 pour désactiver. (défaut : 0) 


---

## Rôle des limites

**Soft vs hard** : le soft laisse finir proprement la requête, le hard agit en coupe‑circuit pour empêcher un débordement mémoire. Une limite soft trop haute rend le hard inefficace, de même qu'un delta trop faible peut interrompre des requêtes légitimes.

**Recyclage via limit_request** : utile pour les dérives mémoire progressives (fuites, comportements de modules tiers, rapports lourds). Le worker repart propre.

**Limites temps** : elles stoppent les requêtes anormalement longues (génération PDF lourde, import de fichiers massifs, traitements complexes) avant qu'elles ne paralysent les workers, mais doivent être suffisantes pour les opérations légitimes.

---

## Exemples de configuration

> Pour le dimmensionnement initial des workers, se référer à la documentation officielle: [Worker number calculation](https://www.odoo.com/documentation/18.0/administration/on_premise/deploy.html#worker-number-calculation)  

### Petite base / charge modérée

```ini
workers = 2
limit_memory_soft = 629145600 # 600M
limit_memory_hard = 1677721600 # 1600M
limit_request = 8192
limit_time_cpu = 600 # 10m
limit_time_real = 1200 # 20m
max_cron_threads = 1
```

**Contexte** : quelques utilisateurs, peu de traitements lourds. Le soft à 600M maintient un budget mémoire cohérent avec les valeurs par défaut, le hard à 1600M absorbe les pics.

### Base plus chargée / usage intensif

```ini
workers = 4
limit_memory_soft = 1073741824 # 1024M
limit_memory_hard = 2147483648 # 2048M
limit_request = 8192
limit_time_cpu = 600 # 10m
limit_time_real = 1200 # 20m
max_cron_threads = 2
```

**Contexte** : utilisateurs nombreux, rapports fréquents, traitements lourds. Plus de workers pour mieux répartir la charge et davantage de marge mémoire.

**Attention** : toujours valider que `workers × limit_memory_hard` + PostgreSQL + OS entrent dans la RAM disponible.

---

## Méthode recommandée : approche empirique

1. Sélectionner une configuration initiale simple selon le profil (petite base / base chargée).
2. Mettre en production, activer un monitoring minimal : RAM, CPU, temps de réponse, cycles de recyclage, erreurs.
3. Ajuster progressivement les paramètres, par exemple :
   - Si la RAM est saturée : réduire `workers` ou `limit_memory_hard`.
   - Si les temps de réponse sont longs ou des erreurs de timeout apparaissent : augmenter `workers` ou les limites temps.
   - Si des workers sont tués fréquemment : augmenter `limit_memory_soft` et `limit_memory_hard`. 

---

## Conseils pratiques

* Dimensionner d'abord la RAM, le CPU vient après.
* Surveiller les rapports, exports, imports : ce sont les principaux consommateurs mémoire.
* Le tuning n'est possible qu'avec un minimum de logs et de métriques.
* Ne jamais pousser les limites mémoire au maximum de la machine : garder de la marge pour PostgreSQL et l'OS.

---

## Conclusion

La configuration d'Odoo repose sur un équilibre : ressources disponibles, volumétrie, comportements utilisateurs et modules installés. On démarre avec une configuration simple, puis on affine avec le monitoring. Cette approche progressive garantit robustesse et stabilité dans le temps.
