# Database Management

<mark> Status: Draft — Pending Review and Approval </mark>

## What is an Odoo backup?
An Odoo backup is a copy of the Odoo database and associated filestore that captures the current state of the system. This backup can be used to restore the system to a previous state in case of data loss, corruption, or other issues. Backups are generated in the form of a **zip archive** containing:
- **`dump.sql`**: A SQL dump of the PostgreSQL database containing all Odoo data
- **`filestore/` folder**: A copy of the filestore directory that contains attachments and binary files (Odoo assets and user-uploaded files)

> For the remainder of this documentation, we will refer to this form as **Odoo standard backup**.

The Odoo application provides a built-in feature to create standard database backups via the user interface or API calls.

However, for specific compliance, security, or performance requirements, customised backup solutions must be implemented.

## Backup Policy
Regular backups of the Odoo database are crucial to prevent data loss and ensure business continuity. We recommend doing this even in addition to existing infrastructure backup solutions. Follow these best practices for database backups:
- **Frequency**: Schedule automatic backups at least daily.
- **Retention**: Keep a minimum of 14 backups, with longer retention for critical data.
- **Granularity**: Consider additional weekly or monthly full backups (e.g., 7 days, 4 weeks, 3 months).
- **Storage**: Store backups in a secure, offsite location (e.g., cloud storage, separate physical location).
- **Testing**: Regularly test backup restoration procedures to ensure data integrity and recovery speed.

## Creating Odoo Backups

**Anatomy of an Odoo standard backup**
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


The filestore of an Odoo database is located in the `filestore` directory of the Odoo data folder (configured via the `data_dir` parameter in the Odoo configuration file). Each database has its own subdirectory in `filestore`, named after the database name.

Default value: `/var/lib/odoo`  
Most common path: `/var/lib/odoo/.local/share/Odoo/filestore/<db_name>`

To know the exact location of the filestore, you can run the following command in an Odoo shell:

```python
odoo.tools.config.filestore(<db_name>)
```

### Within the Odoo environment

The solutions listed below all use the internal Odoo mechanics (API) to create a standard backup. These solutions require direct access to the Odoo environment; in the case of a Python script, it must be possible to import the Odoo module (`import odoo`).

**Pros**: Integrated, easy to use, no external dependencies (except third-party modules)  
**Cons**: Odoo is resource-intensive, risk of timeout, no advanced backup management (encryption, external storage*, etc.)  


> **Our recommendation**: the Odoo application should not have to manage database backups itself. Prefer an external solution or at least one decoupled from the application.

**API** (odoo.service.db.dump_db):
```python
dump_db(db_name, stream, backup_format='zip')
    Dump database `db` into file-like object `stream` if stream is None
    return a file object with the dump
```

1. **Odoo web interface**

From the Odoo web interface, it is possible to create a standard backup of the database by going to the database management page: `/web/database/manager`. This solution is the simplest but also the least flexible. 
Indeed, it requires knowledge of the administrator password and access to the database listing (`list_db=True`), which in production should be avoided for security reasons. This solution is also dependent on the web server configuration (timeout, maximum file size, etc.).

2. **From an Odoo shell**

```bash
odoo shell --no-http << EOF
import os
from datetime import datetime
dbname = env.cr.dbname
zipfile = "{}_{}.zip".format(dbname, datetime.now().strftime("%Y%m%d_%H%M"))
odoo.service.db.dump_db(dbname, os.path.join(os.getcwd(), zipfile))
EOF
```

> Note: the command must be adapted depending on whether the database name is present in the Odoo configuration or not (`db_name`). The example assumes that the database is unique and known by Odoo, hence the retrieval via the cursor.

3. **From a Python script**

Minimal example:

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


4. **Via a third-party module**

The [auto_backup](https://github.com/OCA/server-tools/tree/18.0/auto_backup) module provided by the OCA allows automating the creation and management of Odoo database backups. It offers advanced features such as backup scheduling, retention management, and sending backups to external destinations (FTP, S3, etc.).


### From the infrastructure

This approach quickly performs a manual dump of the database and a copy of the filestore, and assembles everything into a zip archive conforming to the standard Odoo format. It requires direct access to the database (via psql or a similar tool) and the file system hosting the filestore.
Perform a SQL dump of the PostgreSQL database:

```bash
pg_dump -U <db_user> -h <db_host> -p <db_port> --no-owner --file ./dump.sql <db_name>
```

If performed on a host different from Odoo, the user, password, host, and port must be configured accordingly.

The password can be provided via the `PGPASSWORD` environment variable or via the `~/.pgpass` file.

### In the case of a containerized environment
It is not possible to list all possible variants here, but here are some example commands to access Docker containers.

A script placed in the Odoo container could be executed as follows:

```bash

docker compose (-f <compose-file>) exec <odoo service> bash -c "/path/to/backup_script.sh"
```

Note that in this case, the writing of the files resulting from the script will be done in the container. You will therefore need to provide a shared volume with the host or use docker copy commands to extract the necessary data directly from the host.

```bash
# Dump the database from the postgres container
docker compose (-f <compose-file>) exec <postgres service> pg_dump -U <db_user> --no-owner --file /tmp/dump.sql <db_name>

# Copy the dump file from the postgres container to the host
docker compose (-f <compose-file>) cp <postgres service>:/tmp/dump.sql ./

# Copy the filestore from the odoo container
docker compose (-f <compose-file>) cp <odoo service>:/var/lib/odoo/.local/share/Odoo/filestore/<db_name> ./filestore
```
Then, all that remains is to zip everything:

```bash
zip -r <backup_filename>.zip dump.sql filestore
```

A more complete solution could be implemented via a container dedicated to backups, which would have access to the data volumes of the Odoo and Postgres containers, and which would periodically execute the necessary commands to create, store, and/or send backups to an external service (S3 bucket, ftp, etc).

### Bypassing the standard Odoo format

It is also possible within the framework of a custom backup solution to bypass the standard Odoo format. For example, by choosing to perform dumps in folder format, this format has the advantage of being faster to create and restore. It is also the format used by Odoo during upgrades.

```bash
pg_dump --no-owner --format d --jobs <cpu_count> --file <dump> <db_name>
```

Note: In this case, the restoration must also be adapted to take into account this non-standard dump format. The filestore remains unchanged and must always be copied as is.

## Restoring Odoo Backups

In the same way as for creating backups, restoration can be done via the Odoo web interface, via Python scripts using the Odoo API, or via external tools.

The restoration logic consists of:
1. Extracting the contents of the zip archive
2. Restoring the SQL dump into a PostgreSQL database
3. Copying the contents of the filestore folder into the corresponding Odoo filestore directory for the restored database.

> **Important**: An Odoo database contains scheduled actions (cron jobs) that can run automatically. A neutralization feature is available since version 16.0 and should be used for any non-production restoration to avoid the undesired execution of these tasks. Before version 16.0, it is recommended to manually disable scheduled actions after restoration or ensure that the Odoo instance is isolated from the network.

**API** (odoo.service.db.restore_db):
```python
restore_db(db, dump_file, copy=False, neutralize_database=False)
```

The `copy` parameter should always be set to True except in the case of restoring a production database (`copy=False` means that the database is moved, it keeps the UUID already known to the publisher).

Example of a bash command via the Odoo shell:
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
