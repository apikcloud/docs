# Community

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

If you plan to migrate a module, please first declare your intention by commenting on the migration issue. This helps avoid duplication of effort.

If no migration repository exists, create a fork in the `apikcloud` organization using the `oca-` prefix,  
and apply permissions according to the rules currently in force.

<mark>To be completed</mark>