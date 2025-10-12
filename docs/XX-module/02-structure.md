# Structure Pattern

All addons follow standard Odoo structure with Apik-specific conventions:
```
addon_name/
├── __init__.py           # Import models, controllers, wizards
├── __manifest__.py       # Standard Odoo manifest with Apik metadata
├── models/               # Business logic models
├── views/                # XML view definitions  
├── controllers/          # HTTP controllers (website addons)
├── wizards/              # Transient models for wizards
├── security/             # ir.model.access.csv, security groups
├── i18n/                 # Translation files
└── static/               # Assets: JS, CSS, images
    └── src/js/          # JavaScript modules using @odoo-module
```