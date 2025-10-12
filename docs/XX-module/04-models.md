# XX. Models

## Naming Conventions
- Follow Odoo conventions but use descriptive names (`product.brand`, `product.filter`, `faceted.page`)
- For wizards, use the an action-oriented name (`import.product.wizard`, `action.merge.sales`)

## Security & Access Rights
- Include `security/ir.model.access.csv` for all new models
- Use descriptive access rule names following pattern: `access_model_name_group`
- Consider multi-company access when applicable