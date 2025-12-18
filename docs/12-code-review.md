<!--
© 2026 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 12-code-review
Project: apikcloud/docs
Last update: 2026-01-05
Status: Draft
Reviewer: 
-->

# Code Review Guidelines

<mark> Status: Draft — Pending Review and Approval </mark>

> All code changes at Apik are subject to **systematic review** before being merged into `main`.  
> The review is a key element of quality assurance, technical coherence, and team learning.

## Purpose

Code review ensures that every line of code entering production is:
- **Correct** — functionally aligned with the task or feature goal,
- **Consistent** — following Apik’s internal development charter,
- **Maintainable** — clear, tested, and logically structured,
- **Secure** — free from obvious vulnerabilities or unsafe shortcuts.

It is also a means of **shared ownership**: reviewers understand the code they approve.


##  Scope and Exceptions

### Mandatory Reviews
- All **feature branches** (`feat/<task>/<desc>`)
- All **bug fixes** (`fix/<task>/<desc>`)
- Any **refactor or technical improvement** that impacts shared components

### Exceptions — “Accelerated Code Delivery”
A review can be skipped *only* for:
- Urgent production hotfixes that are **risk-assessed** by the Technical Referent or a Reviewer if there's no Technical Referent or is unavailable.
- Integrations of **third-party modules** without internal modifications.

In such cases, a Reviewer must **retro-review** the code after deployment  
and document the exception in the project’s changelog.


## Roles

| Role | Responsibility |
|------|----------------|
| **Developer (author)** | Opens the PR, provides clear context, responds to feedback, merges to main when validated |
| **Reviewer** | Checks code quality, style, performance, and maintainability |
| **Technical Referent (optional)** | Has a global vision of the project and can give its opinion if necessary |
| **QA (optional)** | Tests functional behavior when relevant |

A pull request must have at least **one approval** from an assigned Reviewer before merge.


## Review Process

### Step 1 — Prepare the Review
- Rebase your branch on the latest `main` (`git fetch && git rebase origin/main`).
- Ensure all tests pass locally and pre-commit checks succeed.
- Squash your commits if necessary (see [`COMMITS.md`](./COMMITS.md)).
- Open a Pull Request with:
  - a descriptive title (feature or fix),
  - a clear summary of purpose and impact,
  - reference to the task ID (`[#12345]`).

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


## Feedback Rules

There are three types of feedback: critical, suggestion and question.

All the feedbacks can be discussed with the Reviewer in case of disagreement or misunderstanding.

### Critical

- Indicated with a :x:.
- Used for bugs, optimization issues or big troubles with the readability.
- They **have to** be corrected.

### Suggestion

- Used for small problems of readability, improvements, or suggest an alternative.
- They are **optional**.
- If they are ignored, the Developer must explain why, to keep track.
- Even if the suggestions are validated by the Developer, there must be at least 
  a comment acknowledging the fact the suggestions are understood and efficiently 
  used, not only copy-pasted.

### Question

- Used when more info or context is needed to understand and give a suggestion.
- They **have to be answered** by the Developer.


## Merge Rules

- **Merges to `main` are done via “Squash & merge” or “Rebase and merge”**.
- The final commit message must follow the [Conventional Commits](./COMMITS.md) format.
- No merge commits (`--no-ff` merges are forbidden).
- Branches must be rebased before merge to ensure linear history.
- The Reviewer has the **final say** on whether the branch is ready.

A merge means:
> “This feature is ready for staging and may be deployed.”


## Review Quality Criteria

A review is considered complete when:
- All discussions are resolved.
- Code style and conventions are respected.
- Tests (unit or functional) are in place or justified.
- The Reviewer can explain the purpose of the change.

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
- Data loss.


## Checklist for Reviewers

- [ ] Code runs without errors locally.
- [ ] Changes follow naming and structure rules.
- [ ] No sensitive data or credentials in code.
- [ ] Commit message and PR description are clear.
- [ ] Tests (if any) cover critical paths.
- [ ] No unnecessary dependencies added.
- [ ] Code readability and clarity are acceptable.
- [ ] Task reference included.
