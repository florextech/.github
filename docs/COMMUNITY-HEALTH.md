# Florex Labs community health defaults

Reference documentation for this repository. Maintained for contributors to the
organization, not for the public profile — that lives in
[`../profile/README.md`](../profile/README.md) and is rendered on
[github.com/florextech](https://github.com/florextech).

---

## How precedence works

GitHub applies a default file from this repository to any `florextech`
repository that **does not define its own** version of that file.

For files that GitHub accepts in several locations, the lookup order is:

1. `<repo>/.github/`
2. `<repo>/` (root)
3. `<repo>/docs/`
4. the organization `.github` repository

The same order applies *inside* this repository.

**Overrides are all-or-nothing per area.** If a repository ships its own
`.github/ISSUE_TEMPLATE/` folder, *none* of these templates apply to it — the
repository loses the defaults entirely rather than merging. Same for discussion
forms. A repository that wants different templates must supply a complete set.

Current overrides in the organization:

| Repository | Overrides |
| --- | --- |
| `florex-ui` | Issue templates, PR template, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md` |
| `logcat-desk` | Issue templates, PR template, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md` |
| `docs-to-mcp` | Issue templates, PR template, `CONTRIBUTING.md`, `SECURITY.md`, `CODEOWNERS` |
| `chaos-internet-simulator` | Issue templates, PR template, `CODE_OF_CONDUCT.md`, `SECURITY.md` |
| `agent-bridge` | Issue templates, PR template, `CONTRIBUTING.md`, `FUNDING.yml`, `CODEOWNERS` |
| `infrastructure` | Nothing — receives the full default set |
| `story-then-speak` | Nothing — receives the full default set |

---

## What applies automatically

| File | Location here | Notes |
| --- | --- | --- |
| `CONTRIBUTING.md` | root | Contribution workflow and code standards |
| `CODE_OF_CONDUCT.md` | root | Contributor Covenant 2.1 |
| `SECURITY.md` | root | Reporting, disclosure timeline, safe harbor |
| `SUPPORT.md` | root | Help channels |
| `ACCESSIBILITY.md` | root | WCAG 2.1 AA target |
| `FUNDING.yml` | root | No sponsor button; see comments in file |
| `PULL_REQUEST_TEMPLATE.md` | `.github/` | |
| `ISSUE_TEMPLATE/` | `.github/` | Bug, feature, question, plus `config.yml` |
| `DISCUSSION_TEMPLATE/` | `.github/` | General, Ideas |
| `VULNERABILITY_REPORT.yml` | `.github/` | Private reporting form |

These also apply to **private** repositories, where they are not listed in the
file browser but still surface in the UI.

## What does not apply automatically

GitHub does not propagate these from this repository. Each repository needs its
own copy:

| Item | Action |
| --- | --- |
| `LICENSE` | `./scripts/adopt-org-defaults.sh licenses` |
| Repository labels | `./scripts/adopt-org-defaults.sh labels` |
| `.github/labeler.yml` | Copy from `.github/labeler.yml` |
| `.github/release.yml` | Copy from `.github/release.yml` (Release Drafter repos only) |
| `.github/dependabot.yml` | Copy from `.github/dependabot.yml` |
| `.github/workflows/*` | Intentionally per-repository |
| Private vulnerability reporting | `./scripts/adopt-org-defaults.sh settings` |
| Discussions | `./scripts/adopt-org-defaults.sh settings` |

### Label requirement

GitHub does **not** silently drop a template whose label is missing — it renders
the template and the label silently fails to apply, or the template is
rejected. Every label referenced by these templates must exist in the
destination repository:

`bug` · `enhancement` · `question` · `documentation` · `dependencies` · `ci` ·
`tests` · `accessibility` · `breaking-change` · `security` ·
`skip-changelog` · `discussion`

The 17-label set is defined in `scripts/adopt-org-defaults.sh` and created in
this repository already.

---

## Maintaining these files

1. Edit here, never per-repository, unless the exception is deliberate.
2. Keep the language plain and English-first. Repositories targeting Spanish
   speakers may add their own files instead of forking these.
3. Update the override table above when a repository adopts its own version.
4. Keep `SECURITY.md` and `CODE_OF_CONDUCT.md` pointing at
   `hello@florexlabs.com` — that is the single contact of record.
5. After changing a template that sets labels, run
   `./scripts/adopt-org-defaults.sh labels` so the labels exist everywhere.

### The org profile README

The organization profile rendered on [github.com/florextech](https://github.com/florextech)
comes from **`profile/README.md` in this repository**. The root `README.md`
documents this repository itself and is not shown on the profile.

Edit the public profile in `profile/README.md`. The root `README.md` is free to
be as technical as it needs to be.

### The `florextech/florextech` repository

That repository holds the same profile content at its root `README.md`. A
repository named after the organization is not a profile repository, so it was
never rendered on the profile and is now redundant.

Confirm before removing it — it may be referenced elsewhere, and it may be
serving an unconfirmed purpose.