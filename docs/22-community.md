<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 22-community
Project: aikcloud/docs
Last update: 2025-12-08
Status: Draft
Reviewer: 
-->

# Community

<mark> Status: Draft — Pending Review and Approval </mark>

## What is OCA?

**OCA website**: [https://odoo-community.org/](https://odoo-community.org/)

**Github Organization**: [https://github.com/OCA](https://github.com/OCA)

The Odoo Community Association, OCA, is a membership based organization, established in 2013 to promote and support collaborative Odoo ERP solutions and to foster open source excellence. We make Odoo mightier, together.
The OCA brings people from around the world together to create reliable, high quality Odoo apps and modules that are easily accessible. We provide frameworks to rigorously test every OCA app so it works and is more secure. We help members to improve programming skills through teamwork, code-sprints, and community forums, and support you to connect with peers from across the globe to build your reputation and your personal and professional relationships. 

OCA is an independent legal non-profit entity. This lets members and non-members contribute open source code, funding, and other resources with the knowledge that your contributions will be maintained for public benefit. All OCA projects are freely available and usable under an OSI-certified Open Source license.

As a non-profit entity, the association has no shareholders. The OCA is managed collectively by a board of directors who are elected by delegate members.

*Source*: [About OCA](https://odoo-community.org/page/about)

## Contributing to OCA

[Contribution Guidelines](https://github.com/OCA/odoo-community.org/blob/master/website/Contribution/CONTRIBUTING.rst)

## Migrating modules

### Before starting

If the desired modules are not yet available on the target version branch, first check the corresponding migration issue.

Example for repository [OCA/project](https://github.com/OCA/project):  
In the [issues list](https://github.com/OCA/project/issues), locate the migration issue for your version (e.g. [Migration to version 19.0](https://github.com/OCA/project/issues/1571)).

Verify if a pull request (PR) exists for the module, and check whether a contributor has declared themselves as working on it in a comment.

Follow the PR and retrieve the corresponding repository and branch.

If no PR exists, refer to the next section *How to proceed*.

### How to proceed

Please follow the migration guide according to the target version, for example [Migration to version 19.0](https://github.com/OCA/maintainer-tools/wiki/Migration-to-version-19.0#how-to).

#### Preparation


Package `odoo-module-migrator` must be installed (please refer to the [Tools](23-tools.md) page), and you must retrieve the following three files from [scripts repository](https://github.com/apikcloud/scripts/tree/main/oca_migration):


| File Name               | Description                                                |
|-------------------------|------------------------------------------------------------|
| **env.sh** | Needed to define OCA module migration parameters |
| **create_migrate_rep.sh** | Automate commands before starting migration code (subfolder creation, git clone, pre-commit, ...) |
| **push_remote.sh** | Automate commands executed after migration code (commit, remote add, push) |



#### Procedure 

* First declare your intention by commenting on the migration issue. This helps avoid duplication of effort.
* Make sure the **OCA repo is forked** in Apik organization, following the convention name **oca-<repo_name>** and apply permissions according to the rules currently in force.
* Create a **local folder** that contains the **3 files** mentionned in the [preparation step](#preparation).

* Edit `env.sh` file following these rules:
```bash
src=18 # Origin version, without the .0
dest=19 # Target version, without the .0
repo=brand # Name of the OCA repository
module=partner_brand # Technical name of the module to migrate
```
* Execute the **create_migrate.sh** script.
* Code step :
    * Language must be set to **en_US**.
    * All **unit tests must be valid** (see [Unit tests](14-unit-tests.md)).
    * Execute **pre-commit** while errors are detected.
    * Update **CONTRIBUTORS** field if exist, else edit maintainers part in the manifest.

If a depends module is not yet migrated to the new version, you need to add the following code in the pyproject.toml to allow tests to be running fine:
    
```toml
[project]
    name = "odoo-addons-oca-<migrated_module>"
    version = "<version>.<date>.0"
    dependencies = [
    "odoo-addon-<dependency_module_name> @ git+<oca_repo_link>@refs/pull/<pr_number>/head#subdirectory=<dependency_module_name>", ]
```

*Example* :
```toml
[project]
name = "odoo-addons-oca-partner_brand"
version = "19.0.20251106.0"
dependencies = [
"odoo-addon-brand @ git+https://github.com/OCA/brand.git@refs/pull/270/head#subdirectory=brand",
    ]
```

* Execute `push_remote.sh` script
    * **squash** all commits created during the code step. **Keep only the last one**, created by the script.
    * **Force push** (push -f) to the forked repo.
* **Create the pull request** from the apik repository to the OCA repository
    * The PR **title** must following this rule : `[VERSION][MIG] <module_name>: Migration to <version>`   
    *Example*: `[19.0][MIG] partner_brand: Migration to 19.0)`
    * If there is **PR dependencies**, indicate the following text in the **description** : `<dependecny_module_name>: [#<PR_number>](<PR_link>)`  
    *Example*: `brand: [#270](https://github.com/OCA/brand/pull/270)`
    
