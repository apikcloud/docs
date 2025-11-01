## 3. Manifest Guidelines

### Manifest Structure (`__manifest__.py`)
Follow this pattern for all Apik addons:
```python
# Copyright 2025 apik (https://apik.cloud).
# License LGPL-3.0 or later (https://www.gnu.org/licenses/lgpl).

{
    "name": "Descriptive Name",
    "summary": "A brief summary of the module's purpose",
    "version": "18.0.1.0.0",
    "category": "Category/Subcategory", 
    "author": "Apik",
    "maintainers": ["<github_username>"],
    "website": "https://apik.cloud",
    "depends": [
        "base", 
        "other_modules",
    ],
    "data": [
        # Order alphabetically, if possible.
        # Data
        # Reports  
        # Security
        "security/ir.model.access.csv",
        # Templates
        # Wizards, before views because views can depend on wizards.
        # Views
        "views/model_name.xml",
        # Menus, after all other elements as menu links mostly depend on them.
    ],
    "assets": {
        "web.assets_frontend": [
            "addon_name/static/src/js/file.js"
        ]
    },
    "installable": True,
    "auto_install": False,
    "application": False,
    "license": "LGPL-3",
}
```

**Rules:**
- The `name` field must be unique across all addons.
- The `summary` field should provide a concise description of the module's functionality.
- The `version` field must follow the semantic versioning format (MAJOR.MINOR.PATCH).
- The `category` field should accurately reflect the module's purpose and functionality.
- The `author` field must be set to "Apik".
- The `maintainers` field must include the GitHub usernames of all maintainers.
- The `website` field must point to the official Apik website.
- The `depends` field must list all required modules, including `base`.
- The `data` field must include all necessary XML files, ordered alphabetically.
- The `assets` field must include all required JavaScript files.
- The `installable`, `auto_install`, `application`, and `license` fields must be set as shown in the example.


- **License**: All addons use `LGPL-3` license