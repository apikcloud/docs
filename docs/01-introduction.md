# 1. Introduction

Apik’s engineering methodology is built on clarity, consistency, and shared responsibility.  
Each line of code reflects a collective standard, not an individual preference.

Our goal is to maintain a development environment where every contribution — internal or external — remains **predictable, verifiable, and maintainable**.  
To achieve this, all projects follow the same principles of organization, validation, and delivery.

---

## 1.1. Common Engineering Foundation

All developments are versioned in a dedicated Git repository per client project.  
We follow a **trunk-based workflow**, meaning every validated contribution is merged directly into the `main` branch.  
This model enforces short-lived feature branches, continuous integration, and strict control over what reaches production.

Each contribution is:
- **reviewed** by the Quality team before merge,  
- **validated** by the **Technical Referent** for technical coherence,  
- and **released** under explicit approval from the **Project Manager**.

This layered responsibility ensures that no single actor controls the full delivery chain — quality and accountability are distributed.

---

## 1.2. Document Governance

### 1.2.1. Document Evolution
This documentation is a **living reference**.  
Contributions are welcome and encouraged — they must take the form of a **pull request**, to be reviewed by the **Quality team** and, when necessary, by the **Technical Manager** before integration.

All approved changes must maintain the same level of clarity, accuracy, and consistency as the existing content.

### 1.2.2. Document Organization
Each chapter is divided into:
- **Strict rules** — mandatory principles to be followed in all circumstances,  
- **Implementation recommendations** — expected best practices, which can only be bypassed in exceptional and documented cases.

Examples, diagrams, and code snippets are included where relevant to illustrate common patterns or expected structures.

---

## 1.3. Core Principles

- **Simplicity first** – Code must be understandable, maintainable, and self-explanatory.  
- **Traceability by design** – Every change is linked to a ticket, reviewed, and documented in the changelog.  
- **Reproducibility** – Any environment (staging, preproduction, production) can be rebuilt from versioned code and configuration.  
- **Transparency** – Each commit, release, and migration is traceable to an explicit decision.  
- **Collective responsibility** – The Technical Referent ensures technical quality, but ownership of good practices belongs to everyone.

---

## 1.4. Expectations for Developers and Partners

All developers — whether internal staff or external partners — are expected to:
- Follow Apik’s development charter and conventions.  
- Keep branches focused, rebased, and up to date.  
- Write clear, concise, and reviewable code.  
- Use the provided tooling (`pre-commit`, linters, CI checks) before pushing.  
- Participate actively in code reviews, both as authors and reviewers.  

External partners are integrated under the same rules and subject to the same validation process by the Technical Referent and Quality team.

---

## 1.5. Guarantee of Quality and Consistency

Each project must maintain:
- a **CHANGELOG.md** for release documentation,  
- a **MIGRATIONS.md** for upgrade procedures,  
- and compliance with Apik’s review and release policies.

Together, these ensure that:
- any version can be deployed or rolled back safely,  
- every feature is traceable to its origin,  
- and the integrity of the client’s environment is never compromised.

---

## 1.6. Long-Term Vision

Apik’s engineering approach is designed for **sustainability**.  
Quality is not measured by speed of delivery, but by how long the result remains stable, understandable, and evolvable.  
Documentation, automation, and disciplined review processes are not optional — they are how we keep technical debt under control and protect our clients’ systems over time.

---
[← Back to Home](../README.md) | [Next → Engineering Philosophy](02-philosophy.md)