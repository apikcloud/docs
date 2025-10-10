# Structure Pattern

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
