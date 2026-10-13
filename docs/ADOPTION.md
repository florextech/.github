# Adoption runbook

Applying these defaults across the organization, in a safe order.

---

## 1. Read-only inventory

See what each repository already has before changing anything.

```bash
# Which repositories have no LICENSE?
gh repo list florextech --limit 500 \
  --json name,isPrivate,licenseInfo \
  --jq '.[] | select(.licenseInfo == null) | .name'

# Which already have community health files of their own?
for r in $(gh repo list florextech --limit 500 --json name --jq '.[].name'); do
  printf '%-32s ' "$r"
  gh api "/repos/florextech/$r/community/profile" \
    --jq '"\(.health_percentage)%  " + ([.files | to_entries[] | select(.value != null) | .key] | join(","))'
done
```

Note that the community profile API reports only files present in the
repository itself. Inherited defaults show up in the rendered UI but not in this
response — `securityPolicyUrl` is a better signal for an inherited
`SECURITY.md`.

## 2. Preview

```bash
./scripts/adopt-org-defaults.sh --dry-run
```

Takes about 30 seconds across 45 repositories. Review the output. Nothing is
written in this mode.

## 3. Apply

Run one task at a time so a failure is easy to localize.

```bash
./scripts/adopt-org-defaults.sh labels    # required before templates can label
./scripts/adopt-org-defaults.sh licenses  # adds MIT LICENSE where missing
./scripts/adopt-org-defaults.sh settings  # private vuln reporting + discussions
```

### Notes

- **`labels` must run first.** The issue templates set `bug`, `enhancement`,
  and `question`. Those labels must exist in the destination repository.
- **`licenses` commits through the API**, one commit per repository, on the
  default branch. It never touches your local working tree. Repositories that
  already have any LICENSE are skipped.
- **`settings` is the only task that changes visibility-adjacent behaviour.**
  It enables the Security tab's private reporting and Discussions. For private
  repositories this is still useful, but it does widen who can file a report.

## 4. Verify

```bash
# Security policy now resolves everywhere
for r in $(gh repo list florextech --limit 500 --json name --jq '.[].name'); do
  printf '%-32s %s\n' "$r" "$(gh repo view florextech/$r --json securityPolicyUrl --jq '.securityPolicyUrl // "MISSING"')"
done

# A sample of templates, authenticated — the public chooser needs a session
gh repo view florextech/NetWave --json issueTemplates --jq '.issueTemplates[].name'
```

Then open one repository you do not own templates for and confirm the chooser
offers Bug, Feature request, and Support question.

## 5. Per-repository configuration

These are copied individually. Copy from `.github/` in this repository.

| File | Copy to | When |
| --- | --- | --- |
| `labeler.yml` | `<repo>/.github/labeler.yml` | Any repo using auto-labeling |
| `release.yml` | `<repo>/.github/release.yml` | Any repo using Release Drafter |
| `dependabot.yml` | `<repo>/.github/dependabot.yml` | Any repo wanting automated updates |
| `LICENSE` | `<repo>/LICENSE` | Done by the `licenses` task |

To push one file without cloning:

```bash
gh api --method PUT /repos/florextech/<repo>/contents/.github/dependabot.yml \
  -f message='chore: add Dependabot configuration' \
  -f content="$(base64 <.github/dependabot.yml | tr -d '\n')" \
  -f branch=main \
  -f sha="$(gh api /repos/florextech/<repo>/contents/.github --jq '.sha' 2>/dev/null || echo '')"
```

## 6. Codeowners

Two repositories define CODEOWNERS; the rest do not. With no teams configured in
the organization, CODEOWNERS currently resolves to individual accounts. Worth
deciding whether to create teams before expanding this.

Current handles: `@devflorez`, `@florex`.

---

## Rollback

Every task is additive and skips anything that already exists:

- **Labels** — delete the individual labels in repository settings.
- **Licenses** — `git revert` the `docs: add MIT LICENSE` commit in that
  repository, or delete the file.
- **Settings** — disable private vulnerability reporting and Discussions per
  repository.

Community health files are reverted by reverting the commit here.

## Re-running

The script is idempotent. Running it twice creates nothing new.