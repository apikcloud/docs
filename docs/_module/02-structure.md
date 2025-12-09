<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 02-structure
Project: aikcloud/docs
Last update: 2025-12-08
Status: Draft
Reviewer: 
-->

## 2. Structure Pattern

All addons follow standard Odoo structure with Apik-specific conventions:
```
addon_name/
├── __init__.py           # Import models, controllers, wizards
├── __manifest__.py       # Standard Odoo manifest with Apik metadata
├── controllers/          # HTTP controllers (website addons)
├── i18n/                 # Translation files
├── models/               # Business logic models
├── security/             # ir.model.access.csv, security groups
└── static/               # Assets: JS, CSS, images
    └── src/js/           # JavaScript modules using @odoo-module
├── views/                # XML view definitions  
├── wizards/              # Transient models for wizards
```
