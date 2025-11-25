# Gestion des bases de Données

## Qu'est-ce qu'une sauvegarde Odoo ?
Une sauvegarde Odoo est une copie de la base de données Odoo et du filestore associé qui capture l'état actuel du système. Cette sauvegarde peut être utilisée pour restaurer le système à un état antérieur en cas de perte de données, de corruption ou d'autres problèmes. Les sauvegardes sont générées sous la forme d'une **archive zip** contenant :
- **`dump.sql`** : un dump SQL de la base de données PostgreSQL contenant toutes les données Odoo
- **dossier `filestore/`** : une copie du répertoire filestore qui contient les pièces jointes et les fichiers binaires (ressources Odoo et fichiers téléchargés par les utilisateurs)

> Pour le reste de cette documentation, nous nous référerons à cette forme sous le nom de **sauvegarde standard Odoo**.

L'applicatif Odoo propose une fonctionnalité intégrée pour créer des sauvegardes standard de la base de données via l'interface utilisateur ou des appels API. 

Cependant, pour des besoins spécifiques de conformité, de sécurité ou de performance, des solutions de sauvegarde personnalisées doivent être mises en place.

## Politique de sauvegarde
Les sauvegardes régulières de la base de données Odoo sont cruciales pour prévenir la perte de données et assurer la continuité des activités. Nous recommandons de le faire même en complément des solutions de sauvegarde d'infrastructure existantes. Suivez ces bonnes pratiques pour les sauvegardes de bases de données :
- **Fréquence** : Planifiez des sauvegardes automatiques au moins quotidiennement.
- **Rétention** : Conservez un minimum de 14 sauvegardes, avec une rétention plus longue pour les données critiques.
- **Granularité** : Envisagez des sauvegardes complètes supplémentaires hebdomadaires ou mensuelles (par exemple, 7 jours, 4 semaines, 3 mois).
- **Stockage** : Stockez les sauvegardes dans un emplacement sécurisé et hors site (par exemple stockage cloud, emplacement physique séparé).
- **Test** : Testez régulièrement les procédures de restauration des sauvegardes pour garantir l'intégrité des données et le temps nécessaireà la récupération.

## Création de sauvegardes Odoo

**Anatomie d'un backup Odoo**
```
backup.zip
    |
    |-- dump.sql
    |-- filestore/
            |-- <hash1>/
            |       |-- <file1>
            |       |-- <file2>
            |-- <hash2>/
                    |-- <file1>
                    |-- <file2>
```


Le filestore d'une base Odoo est situé dans le répertoire `filestore` du dossier de données d'odoo (configuré via le paramètre `data_dir` dans le fichier de configuration d'odoo). Chaque base de données possède son propre sous-répertoire dans `filestore`, nommé selon le nom de la base de données.

Valeur par défaut : `/var/lib/odoo`  
Chemin le plus courant : `/var/lib/odoo/.local/share/Odoo/filestore/<db_name>`

Pour connaitre l'emplacement exact du filestore, vous pouvez exécuter la commande suivante dans un shell odoo:

```python
odoo.tools.config.filestore(<db_name>)
```

### Au sein de l'environnement Odoo

Les solutions listées ci-dessous emploient toute la mécanique interne d'odoo (API) pour créer une sauvegarde standard. Ces solutions nécessitent un accès direct à l'environnement odoo, dans le cas d'un script python il doit être possible d'importer le module odoo (`import odoo`).

**Pour**: Intégré, simple à utiliser, pas de dépendance externe (hors module tiers)  
**Contre**: Odoo est consommateur en ressources, risque de timeout, pas de gestion avancée des backups (chiffrement, stockage externe*, etc.)  

> **Notre recommandation**: l'applicatif odoo ne devrait pas avoir à gérer lui-même les sauvegardes de la base de données. Préférez une solution externe ou du moins découplée de l'applicatif.

**API** (odoo.service.db.dump_db):
```python
dump_db(db_name, stream, backup_format='zip')
    Dump database `db` into file-like object `stream` if stream is None
    return a file object with the dump
```

1. **Interface web odoo**

Depuis l'interface web d'odoo, il est possible de créer une sauvegarde standard de la base de données en se rendant sur la page de gestion des bases de données: `/web/database/manager`. Cette solution est la plus simple mais également la moins flexible. 
En effet elle nécessite la connaissance du mot de passe administrateur et l'accès aux listing des bases (`list_db=True`), ce qui en production, devrait être évité pour des raisons de sécurité. Cette solution est également dépendante de la configuration du serveur web (timeout, taille maximale des fichiers, etc.).

2. **Depuis un shell odoo**

```bash
odoo shell --no-http << EOF
import os
from datetime import datetime
dbname = env.cr.dbname
zipfile = "{}_{}.zip".format(dbname, datetime.now().strftime("%Y%m%d_%H%M"))
odoo.service.db.dump_db(dbname, os.path.join(os.getcwd(), zipfile))
EOF
```

> A noter: la commande doit être adaptée en fonction de la présence du nom de la base dans la configuration d'odoo ou non (`db_name`). L'exemple considère que la base est unique et connue par odoo, d'où la récupération via le curseur.

3. **Depuis un script python**

Exemple minimaliste:

```python
import os
from contextlib import contextmanager

import odoo

@contextmanager
def db_management_enabled():
    old_params = {"list_db": odoo.tools.config["list_db"]}
    odoo.tools.config["list_db"] = True

    if odoo.release.version_info < (12, 0):
        for v in ("host", "port", "user", "password"):
            odoov = "db_" + v.lower()
            pgv = "PG" + v.upper()
            if not odoo.tools.config[odoov] and pgv in os.environ:
                old_params[odoov] = odoo.tools.config[odoov]
                odoo.tools.config[odoov] = os.environ[pgv]
    try:
        yield
    finally:
        for key, value in old_params.items():
            odoo.tools.config[key] = value


if __name__ == "__main__":
    dbname = "<db_name>"
    filepath = "<backup.zip>"

    with db_management_enabled():
        dbs = odoo.service.db.list_dbs()
        print(f"Available databases: {dbs}")

        if dbname not in dbs:
            exit()

        odoo.service.db.dump_db(dbname, filepath)
```


4. **Via un module tiers**

Le module [auto_backup](https://github.com/OCA/server-tools/tree/18.0/auto_backup) fournit par l'OCA permet d'automatiser la création et la gestion des sauvegardes de bases de données Odoo. Il offre des fonctionnalités avancées telles que la planification des sauvegardes, la gestion de la rétention, et l'envoi des sauvegardes vers des destinations externes (FTP, S3, etc.).


### Depuis l'infrastructure

Cette approche vite à réaliser un dump manuel de la base de données et une copie du filestore, et à assembler le tout dans une archive zip conforme au format standard d'odoo. Elle nécessite un accès direct à la base de données (via psql ou un outil similaire) et au système de fichiers hébergeant le filestore.

Réaliser un dump SQL de la base de données PostgreSQL:

```bash
pg_dump -U <db_user> -h <db_host> -p <db_port> --no-owner --file ./dump.sql <db_name>
```

Si réalisé sur un hôte différent de odoo, l'utilisateur, le mot de passe, l'hôte et le port doivent être configurés en conséquence.

Le mot de passe peut être fourni via la variable d'environnement `PGPASSWORD` ou via le fichier `~/.pgpass`.

### Cas d'un environnement conteneurisé

Il n'est pas possible de lister ici toutes les variantes possibles, mais voici quelques exemples de commandes pour accéder aux conteneurs Docker.

Un script placé dans le conteneur odoo pourrait être exécuté ainsi:

```bash

docker compose (-f <compose-file>) exec <odoo service> bash -c "/path/to/backup_script.sh"
```

Notez que dans ce cas, l'écriture des fichiers résultant du script se fera dans le conteneur. Il faudra donc prévoir un volume partagé avec l'hôte ou l'usage des commandes de copie docker pour extraire les données nécessaires directement depuis l'hôte.

```bash
# Dump the database from the postgres container
docker compose (-f <compose-file>) exec <postgres service> pg_dump -U <db_user> --no-owner --file /tmp/dump.sql <db_name>

# Copy the dump file from the postgres container to the host
docker compose (-f <compose-file>) cp <postgres service>:/tmp/dump.sql ./

# Copy the filestore from the odoo container
docker compose (-f <compose-file>) cp <odoo service>:/var/lib/odoo/.local/share/Odoo/filestore/<db_name> ./filestore
```
Ensuite, il ne reste plus qu'à zipper le tout:

```bash
zip -r <backup_filename>.zip dump.sql filestore
```

Une solution plus complète pourrait être mise en place via un conteneur dédié aux sauvegardes, qui aurait accès aux volumes de données des conteneurs odoo et postgres, et qui exécuterait périodiquement les commandes nécessaires pour créer, stocker et/ou envoyer les sauvegardes sur un service externe (bucket S3, ftp, etc).

### S'affranchir du format standard Odoo

Il est également possible dans le cadre d'une solution de sauvegarde personnalisée de s'affranchir du format standard Odoo. Par exemple, on choisissant de réaliser des dumps au format folder, ce format ayant l'avantage d'être plus rapide à créer et à restaurer. C'est d'ailleurs le format utilisé par Odoo lors des upgrades.

```bash
pg_dump --no-owner --format d --jobs <cpu_count> --file <dump> <db_name>
```

Note: Dans ce cas, la restauration devra également être adaptée pour prendre en compte ce format de dump non standard. Le filestore reste quant à lui inchangé et doit toujours être copié tel quel.

## Restauration de sauvegardes

De la même manière que pour la création de sauvegardes, la restauration peut être effectuée via l'interface web d'Odoo, via des scripts Python utilisant l'API d'Odoo, ou via des outils externes.

La logique de restauration consiste à:
1. Extraire le contenu de l'archive zip
2. Restaurer le dump SQL dans une base de données PostgreSQL
3. Copier le contenu du dossier filestore dans le répertoire filestore d'Odoo correspondant à la base restaurée.

> **Important**: Une base de données Odoo contient des actions planifiées (cron jobs) qui peuvent s'exécuter automatiquement. Une fonctionnalité de neutralisation est disponible depuis la version 16.0 et doit être utilisée pour toute restauration hors production afin d'éviter l'exécution non désirée de ces tâches. Avant la version 16.0, il est recommandé de désactiver manuellement les actions planifiées après la restauration ou de veiller à ce que l'instance Odoo soit isolée du réseau.

**API** (odoo.service.db.restore_db):
```python
restore_db(db, dump_file, copy=False, neutralize_database=False)
```

Le paramètre `copy` doit toujours être à True sauf en cas de restauration d'une base de production (`copy=False` signifie que la base est déplacée, elle garde l'UUID déjà connue chez l'éditeur).

Exemple de commande bash via le shell Odoo:
```bash
odoo shell --no-http << EOF
odoo.service.db.restore_db("<database>", "<backup.zip>", copy=True, neutralize_database=True)
EOF
```

Exemple de script python:

```python
import os
from contextlib import contextmanager

import odoo


@contextmanager
def db_management_enabled():
    old_params = {"list_db": odoo.tools.config["list_db"]}
    odoo.tools.config["list_db"] = True
    if odoo.release.version_info < (12, 0):
        for v in ("host", "port", "user", "password"):
            odoov = "db_" + v.lower()
            pgv = "PG" + v.upper()
            if not odoo.tools.config[odoov] and pgv in os.environ:
                old_params[odoov] = odoo.tools.config[odoov]
                odoo.tools.config[odoov] = os.environ[pgv]
    try:
        yield
    finally:
        for key, value in old_params.items():
            odoo.tools.config[key] = value


if __name__ == "__main__":
    dbname = "<database>"
    filepath = "<backup.zip>"

    with db_management_enabled():
        dbs = odoo.service.db.list_dbs()

        # Drop the database if it already exists
        if dbname in dbs:
            odoo.service.db.drop_db(dbname)

        # Restore the database from the backup file
        odoo.service.db.restore_db(
            dbname, filepath, copy=True, neutralize_database=True
        )

```
