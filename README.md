# Organization defaults for Florex Labs

This repository holds the **default community health files** for every
repository in the [`florextech`](https://github.com/florextech) organization,
and the [organization profile README](profile/README.md) rendered on
[github.com/florextech](https://github.com/florextech).

GitHub applies the health files automatically to any Florex Labs repository
that does not define its own version. A repository with its own
`CONTRIBUTING.md` or `SECURITY.md` keeps that file — these are defaults, not
overrides.

## What applies automatically

| File | Scope |
| --- | --- |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | Contribution workflow, code standards, commit format |
| [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) | Contributor Covenant 2.1 |
| [`SECURITY.md`](SECURITY.md) | Vulnerability reporting, disclosure, safe harbor |
| [`SUPPORT.md`](SUPPORT.md) | Where to get help |
| [`ACCESSIBILITY.md`](ACCESSIBILITY.md) | WCAG 2.1 AA target and reporting process |
| [`FUNDING.yml`](FUNDING.yml) | Sponsor button configuration |
| [`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md) | Pull request checklist |
| [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE) | Bug, feature, and question templates |
| [`.github/DISCUSSION_TEMPLATE/`](.github/DISCUSSION_TEMPLATE) | Discussion forms |
| [`.github/VULNERABILITY_REPORT.yml`](.github/VULNERABILITY_REPORT.yml) | Private vulnerability reporting form |

These defaults apply to **private repositories too**, even though they are not
visible there in the file browser.

## What does not apply automatically

GitHub does **not** propagate `LICENSE`, workflows, or repository settings from
this repository. Each repository still needs its own:

- **`LICENSE`** — MIT. Run `scripts/adopt-org-defaults.sh licenses` to add it.
- **`.github/labeler.yml`**, **`.github/release.yml`**, **`.github/dependabot.yml`** — copy from [`.github/`](.github/).
- **`.github/workflows/*`** — CI is per-repository by design.
- **Labels** — a template that sets a label requires that label to exist in the
  target repository. The script creates the standard set.

## Adopting these defaults

```bash
# Preview what would change, across every repository in the org
./scripts/adopt-org-defaults.sh --dry-run

# Create the standard label set everywhere
./scripts/adopt-org-defaults.sh labels

# Add the MIT LICENSE to repositories that lack one
./scripts/adopt-org-defaults.sh licenses

# Enable private vulnerability reporting and discussions
./scripts/adopt-org-defaults.sh settings
```

The script only touches repositories under `florextech`, skips anything that
would overwrite an existing file or label, and never commits to your working
tree.

## Editing these defaults

Changes take effect for all repositories at once. Repositories that have already
adopted their own version of a file will not be affected.

See [`docs/COMMUNITY-HEALTH.md`](docs/COMMUNITY-HEALTH.md) for precedence rules
and override guidance, [`docs/STANDARDS.md`](docs/STANDARDS.md) for the
engineering conventions these files encode, and
[`docs/ADOPTION.md`](docs/ADOPTION.md) for the full rollout runbook.

## Repository layout

```text
profile/README.md          -> rendered on the organization profile
README.md                  -> this file
CONTRIBUTING.md            -> default contribution guide
CODE_OF_CONDUCT.md         -> default code of conduct
SECURITY.md                -> default security policy
SUPPORT.md                 -> default support channels
ACCESSIBILITY.md           -> default accessibility policy
FUNDING.yml                -> default funding links
LICENSE                    -> MIT for this repository
.github/                   -> templates and optional per-repo config
docs/                      -> reference documentation
scripts/                   -> organization-wide rollout tooling
```