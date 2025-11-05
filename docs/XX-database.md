# Database Management

<mark> Status: Draft — Pending Review and Approval </mark>

## What is an Odoo backup?
An Odoo backup is a copy of the Odoo database and associated filestore that captures the current state of the system. This backup can be used to restore the system to a previous state in case of data loss, corruption, or other issues. Backups are generated in the form of a **zip archive** containing:
- **Database Dump**: A SQL dump of the PostgreSQL database containing all Odoo data
- **Filestore**: A copy of the filestore directory that contains attachments and binary files (Odoo assets and user-uploaded files)

> For the remainder of this documentation, we will refer to this form as **Odoo standard backup**.

L'applicatif Odoo propose une fonctionnalité intégrée pour créer des sauvegardes standard de la base de données via l'interface utilisateur ou des appels API. 
Sans contre mesure particulière (`list_db=False`) la sauvegarde ou la restauration sont accessibles par l'url `/web/database/manager` de l'instance Odoo.

Cependant, pour des besoins spécifiques de conformité, de sécurité ou de performance, des solutions de sauvegarde personnalisées peuvent être mises en place.

## Backup Policy
Regular backups of the Odoo database are crucial to prevent data loss and ensure business continuity. We recommend doing this even in addition to existing infrastructure backup solutions. Follow these best practices for database backups:
- **Frequency**: Schedule automatic backups at least daily.
- **Retention**: Keep a minimum of 14 backups, with longer retention for critical data.
- **Granularity**: Consider additional weekly or monthly full backups (e.g., 7 days, 4 weeks, 3 months).
- **Storage**: Store backups in a secure, offsite location (e.g., cloud storage, separate physical location).
- **Testing**: Regularly test backup restoration procedures to ensure data integrity and recovery speed.