<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 10-changelog
Project: apikcloud/docs
Last update: 2026-01-07
Status: Draft
Reviewer: 
-->

# Changelog

<mark> Status: Draft — Pending Review and Approval </mark>

This document defines how we **manually** write and maintain changelogs for Apik projects.
It complements our workflow and commits documentations. We follow the principles of [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) who adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) and write every entry by hand — no auto-generation.



## Purpose & Audience

> The changelog explains **what changed between versions** to people who don’t read commits:
project managers, QA, support, and customers. It focuses on **impact and behavior**, not implementation details.

Project managers don’t review the changelog before release, but they must have **visibility**:
- `CHANGELOG.md` is always available in the main branch.
- Updates are included in release summaries.



## Principles

- **Human-curated**: clarity over automation.
- **Versioned**: entries are grouped by **version tag** (`vX.Y.Z`) and date.
- **Impact-oriented**: include changes users or operators will notice.
- **Neutral tone**: factual, concise, no marketing.
- **Stable format**: consistent sections and phrasing.



## Inclusion Criteria

Include:
- New features or visible improvements.
- Bug fixes with user-visible impact.
- Breaking or behavior-changing updates.
- Migrations, deprecations, removals.
- Performance or security improvements.
- High-impact refactors.

Exclude (unless critical):
- Linting, code style.
- Low-impact refactors. 
- CI, tooling, build-only or dependency bumps.

> If a PM, consultant, or client **needs to know**, it belongs here.



## Structure per Release

```markdown
## [vX.Y.Z] — YYYY-MM-DD

### Added
- …

### Changed
- …

### Fixed
- …

### Removed
- …

### Migration Notes
- …
```

Optional:
- **Known Issues**: short list + workarounds.



## Writing Rules

- **One line per item.**
- **No prefix** ("Added:", "Fixed:") — the section already defines it.
- Start directly with the action or object changed.
- Keep lines under **120 chars**.
- Use strong, descriptive verbs; avoid vague wording.
- No technical terms.

**Examples (good)**

[See template example below.](#template-example)

**Avoid**
```
- Added: various fixes
- Fixed bug
- Update stuff
- Change function button_confirm on stock.picking 
```


## Relationship with Commits and Tasks

- **Commits**: technical, atomic, dev-focused.
- **Changelog**: curated, user-focused summary.
- **Tasks**: the link with the tasks is done via the commit.
- **Impacted scope**: optionally indicated in the commit.


## Team Workflow

1. **During development**: developer adds draft changelog lines in the "Unreleased" section.
2. **Before tagging**: *Technical Referent* consolidates and formats entries.
3. **Visibility**: project manager has read access to follow release content.
4. **Tag & publish**: `CHANGELOG.md` committed with the tag.
5. **Post-release**: add known issues if needed; history remains immutable.

**Roles**
- **Developer**: drafts entries.
- **Reviewer (QA)**: checks accuracy and relevance.
- **Technical Referent**: final formatting and scope.



## Odoo-Specific Guidance

- Mention affected **models** by their **human** names (e.g., `purchase order`, `partner`).
- Do not mention affected **addons**; except for adding, updating or removing 
  OCA or third-party modules. In the case of an addition, add a quick summary of the 
  description of the addon to ensure its use is clear.
- Flag **data model changes** (fields, constraints, scripts).
- Note **access rights**, **server parameters**, or **env variables** changes.
- Summarize **migration steps**; detailed procedures go in `MIGRATION.md`.



## Template Example

```markdown
# Changelog

All notable changes to this project are documented here.

This changelog follows the [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) convention  
and adheres to Apik’s internal [Changelog Guidelines](https://github.com/apikcloud/docs/docs/07-changelog.md).

The goal: provide a clear, user-focused history of what has changed, improved, or been fixed.

## [v1.5.0] — 2025-10-12

### Added

- Vendor bill OCR with manual fallback.
- Wizard to merge invoices.
- OCA module `partner_firstname` to split partners' names in two fields: first name 
  and last name.

### Changed

- Rights management on sale order templates.
- Add the sum of initial amounts in contract form view.
- Disable the creation of products on the fly in the sale order templates.

### Fixed

- Block the possibility to change the product on sale orders after creation to avoid
  issues with components.
- Update Odoo version from `18.0-20250625-enterprise` to `18.0-20251215-enterprise` to
  fix a standard bug that duplicates content in the website.

### Migration Notes

- Update `mgdis_contract` before `mgdis_sales`.
```


## Release Checklist

- [ ] Entries grouped by version and date.
- [ ] Only user-impacting items included.
- [ ] Tone consistent, verbs clear.
- [ ] Security and breaking changes highlighted.
- [ ] Migration notes validated.
- [ ] Changelog committed with the tag.
- [ ] PM has access for visibility.
