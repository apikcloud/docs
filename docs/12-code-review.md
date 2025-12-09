<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 12-code-review
Project: aikcloud/docs
Last update: 2025-12-08
Status: Draft
Reviewer: 
-->

# Code Review Guidelines

<mark> Status: Draft — Pending Review and Approval </mark>

> All code changes at Apik are subject to **systematic review** before being merged into `main`.  
> The review is a key element of quality assurance, technical coherence, and team learning.

## Purpose

Code review ensures that every line of code entering production is:
- **Correct** — functionally aligned with the ticket or feature goal,
- **Consistent** — following Apik’s internal development charter,
- **Maintainable** — clear, tested, and logically structured,
- **Secure** — free from obvious vulnerabilities or unsafe shortcuts.

It is also a means of **shared ownership**: reviewers understand the code they approve.


##  Scope and Exceptions

### Mandatory Reviews
- All **feature branches** (`feat/<ticket>/<desc>`)
- All **bug fixes** (`fix/<ticket>/<desc>`)
- Any **refactor or technical improvement** that impacts shared components.

### Exceptions — “Accelerated Code Delivery”
A review can be skipped *only* for:
- Urgent production hotfixes that are **risk-assessed** by the Technical Referent.
- Integrations of **third-party modules** without internal modifications.

In such cases, the Technical Referent must **retro-review** the code after deployment  
and document the exception in the project’s changelog.


## Roles

| Role | Responsibility |
|------|----------------|
| **Developer (author)** | Opens the PR, provides clear context, responds to feedback |
| **Reviewer** | Checks code quality, style, performance, and maintainability |
| **Technical Referent** | Final approver; validates the merge to `main` |
| **QA (optional)** | Tests functional behavior when relevant |

A pull request must have at least **one approval** from a Technical Referent or an assigned reviewer before merge.


## Review Process

### Step 1 — Prepare the Review
- Rebase your branch on the latest `main` (`git fetch && git rebase origin/main`).
- Ensure all tests pass locally and pre-commit checks succeed.
- Squash your commits if necessary (see `COMMITS.md`).
- Open a Pull Request with:
  - a descriptive title (feature or fix),
  - a clear summary of purpose and impact,
  - reference to the ticket ID (`[#12345]`).

### Step 2 — Conduct the Review
Reviewers must:
- Read the code, not just the diff — understand intent.
- Focus on *why* and *how*, not personal style preferences.
- Check:
  - Functionality and regressions
  - Performance implications
  - Security / data exposure
  - Test coverage (existing or new)
  - Naming, clarity, and comments
  - Compliance with Apik’s code style and guidelines

Optional tools:
- `ruff`, `pylint-odoo`, and pre-commit hooks (should pass before review).
- Odoo run logs and functional testing in dev/staging.

### Step 3 — Feedback & Collaboration
- Keep feedback **constructive and concise**.
- Prefer **suggestions over imperatives**.
- If unsure, ask for clarification — don’t block unnecessarily.
- The author is responsible for addressing feedback and re-requesting review.


## Merge Rules

- **Merges to `main` are done via “Squash & merge” or “Rebase and merge”**.
- The final commit message must follow the [Conventional Commits](./COMMITS.md) format.
- No merge commits (`--no-ff` merges are forbidden).
- Branches must be rebased before merge to ensure linear history.
- The Technical Referent has the **final say** on whether the branch is ready.

A merge means:
> “This feature is ready for staging and may be deployed.”


## Review Quality Criteria

A review is considered complete when:
- All discussions are resolved.
- Code style and conventions are respected.
- Tests (unit or functional) are in place or justified.
- The reviewer can explain the purpose of the change.

Avoid “rubber-stamping”: every approval must be **an informed decision**.


## Review Etiquette

- Assume good intent.
- Praise what’s well done before noting improvements.
- Separate factual issues from opinions.
- Don’t block indefinitely; escalate to the Technical Referent if needed.
- Use draft PRs for early feedback — not everything must be final.


## Common Review Findings (to watch for)

- Missing or incorrect access rights in Odoo models.
- SQL queries without limits or context filters.
- Overridden core methods without calling `super()`.
- Unused imports, dead code, or debug prints.
- Missing dependency in `__manifest__.py`.
- Lack of `@api.constrains` or `@api.depends` when needed.
- Hardcoded strings instead of translations.


## Checklist for Reviewers

- [ ] Code runs without errors locally.
- [ ] Changes follow naming and structure rules.
- [ ] No sensitive data or credentials in code.
- [ ] Commit message and PR description are clear.
- [ ] Tests (if any) cover critical paths.
- [ ] No unnecessary dependencies added.
- [ ] Code readability and clarity are acceptable.
- [ ] Ticket reference included.
