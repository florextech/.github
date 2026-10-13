# Florex Labs · GitHub community

The shared community resources for [Florex Labs](https://github.com/florextech):
contribution guides, support and security policies, issue templates, and the
[organization profile](profile/README.md).

Looking for our tools? Visit the [public profile](https://github.com/florextech)
or [browse the public repositories](https://github.com/search?q=org%3Aflorextech+is%3Apublic+fork%3Afalse&type=repositories).

## Community resources

| Resource | Purpose |
| --- | --- |
| [Contributing](CONTRIBUTING.md) | Contribution workflow and engineering conventions |
| [Code of conduct](CODE_OF_CONDUCT.md) | Expectations for community participation |
| [Security](SECURITY.md) | How to report vulnerabilities responsibly |
| [Support](SUPPORT.md) | Where to ask questions and report problems |
| [Accessibility](ACCESSIBILITY.md) | Accessibility goals and feedback |
| [Issue templates](.github/ISSUE_TEMPLATE) | Bug reports, feature requests, and questions |
| [Pull request template](.github/PULL_REQUEST_TEMPLATE.md) | Information to include with a contribution |
| [Discussion forms](.github/DISCUSSION_TEMPLATE) | Structured community discussions |

## How the defaults work

GitHub uses supported community files from this public `.github` repository
when a repository in the organization does not provide its own. This applies
regardless of the destination repository's visibility. Existing repository
files take precedence; the defaults are not copied into its Git history.

If a repository defines its own issue templates or template configuration,
GitHub uses that set instead of merging it with these defaults.

Licenses, workflows, labels, and repository settings require separate setup.
The [MIT license](LICENSE) covers this repository; check each project's own
license for its terms. The root `FUNDING.yml` is a reference file; GitHub requires
funding configuration in `.github/FUNDING.yml` to use it as a default.

See [GitHub's default community file documentation](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
for supported files and placement rules.

## Maintaining this repository

- Edit [profile/README.md](profile/README.md) to update the organization profile.
- Feature only public repositories, and confirm their visibility before adding links.
- Keep project descriptions specific and avoid naming private projects or internal systems.
- Update shared policies here; use repository-specific files for exceptions.
- Check relative links and labels whenever templates change.

Before changing the public profile, verify the current repository inventory:

```bash
gh repo list florextech --limit 500 --json name,visibility,url
```

## Maintainer references

- [Community file precedence](docs/COMMUNITY-HEALTH.md)
- [Engineering standards](docs/STANDARDS.md)
- [Adoption guide](docs/ADOPTION.md)
- [Adoption script](scripts/adopt-org-defaults.sh)

The adoption script can change labels, licenses, and settings across the
organization. Review the guide and preview the intended task before running it:

```bash
./scripts/adopt-org-defaults.sh labels --dry-run
```

## Contact

[florexlabs.com](https://florexlabs.com) · [hello@florexlabs.com](mailto:hello@florexlabs.com)
