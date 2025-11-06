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

Exclude (unless critical):
- Refactors, linting, code style.
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

### Deprecated
- …

### Removed
- …

### Performance
- …

### Security
- …

### Migration Notes
- …
```

Optional:
- **Odoo Modules Impacted**: `account`, `project`, `mail`, etc.
- **Known Issues**: short list + workarounds.



## Writing Rules

- **One line per item.**
- **No prefix** ("Added:", "Fixed:") — the section already defines it.
- Start directly with the action or object changed.
- Mention affected **module** in parentheses.
- End with related **ticket ID** in brackets.
- Keep lines under **120 chars**.
- Use strong, descriptive verbs; avoid vague wording.

**Examples (good)**
```markdown
### Added
- Merge wizard for draft invoices (account) [#16838]

### Fixed
- Refreshing price for subscription components (mgdis_sales) [#16838]

### Changed
- Manage rights on Sale Order Templates (mgdis_security) [#16836]
```

**Avoid**
```
- Added: various fixes
- Fixed bug
- Update stuff
```


## Relationship with Commits and Tickets

- **Commits**: technical, atomic, dev-focused.
- **Changelog**: curated, user-focused summary.
- **Tickets**: link the changelog to project tracking tools.

Ticket reference format:
```
(description) [#12345]
```

Example:
```
- Improve invoice PDF header (account) [#17021]
```


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

- Mention affected **addons** and **models** (e.g., `account.move`, `mail.thread`).
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
- Vendor bill OCR with manual fallback (account) [#16838]

### Changed
- Rights management on Sale Order Templates (mgdis_security) [#16836]
- Sum of initial amounts in contract form view (mgdis_contract) [#16838]

### Fixed
- Refreshing subscription component price (mgdis_sales) [#16838]

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
