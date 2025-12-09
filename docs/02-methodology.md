<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 02-methodology
Project: aikcloud/docs
Last update: 2025-12-08
Status: Draft
Reviewer: 
-->

# Methodology Overview

<mark> Status: Draft — Pending Review and Approval </mark>

> Apik’s engineering methodology is built on clarity, consistency, and shared responsibility.  
> Each line of code reflects a collective standard, not an individual preference.
> 
> Our goal is to maintain a development environment where every contribution — internal or external — remains **predictable, verifiable, and maintainable**.  
>
> To achieve this, all projects follow the same principles of organization, validation, and delivery.


## Common Engineering Foundation

All developments are versioned in a dedicated Git repository per client project.  
We follow a **trunk-based workflow**, meaning every validated contribution is merged directly into the `main` branch.  
This model enforces short-lived feature branches, continuous integration, and strict control over what reaches production.

Each contribution is:
- **reviewed** by the Quality team before merge,  
- **validated** by the **Technical Referent** for technical coherence,  
- and **released** under explicit approval from the **Project Manager**.

This layered responsibility ensures that no single actor controls the full delivery chain — quality and accountability are distributed.


## Guarantee of Quality and Consistency

Each project must maintain:
- a **README.md** for listing addons and project documentation,
- a **CHANGELOG.md** for release documentation,  
- a **MIGRATIONS.md** for upgrade procedures,  
- and compliance with Apik’s review and release policies.

Together, these ensure that:
- any version can be deployed or rolled back safely,  
- every feature is traceable to its origin,  
- and the integrity of the client’s environment is never compromised.



## Long-Term Vision

Apik’s engineering approach is designed for **sustainability**.  
Quality is not measured by speed of delivery, but by how long the result remains stable, understandable, and evolvable.  
Documentation, automation, and disciplined review processes are not optional — they are how we keep technical debt under control and protect our clients’ systems over time.
