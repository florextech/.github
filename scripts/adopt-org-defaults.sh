#!/usr/bin/env bash
#
# Adopt Florex Labs organization defaults across the `florextech` GitHub org.
#
# This script only performs what GitHub does NOT propagate from the
# organization-level `.github` repository:
#
#   labels     - create the standard label set in every repository
#   licenses   - add the MIT LICENSE where one is missing
#   settings   - enable private vulnerability reporting + discussions
#   all        - everything above
#
# It never overwrites an existing file or label, and never touches your working
# tree. Run with --dry-run first.
#
# Usage:
#   ./scripts/adopt-org-defaults.sh --dry-run
#   ./scripts/adopt-org-defaults.sh labels
#   ./scripts/adopt-org-defaults.sh licenses settings
#
# Requires: gh (https://cli.github.com) authenticated with `repo` and
# `admin:org` scopes.
#
set -euo pipefail

ORG="${FLOREX_ORG:-florextech}"
DRY_RUN=0

# --- Standard labels: name|description|color -------------------------------
LABELS=(
  "bug|Something is not working as expected|d73a4a"
  "enhancement|New feature or request|7057ff"
  "documentation|Documentation changes|0075ca"
  "dependencies|Dependency updates|0366d6"
  "ci|Build, CI, and workflow changes|c5def5"
  "tests|Test additions or changes|bfd4f2"
  "question|Request for support or information|d876e3"
  "good first issue|Good for newcomers|7057ff"
  "help wanted|Extra help wanted|008672"
  "wontfix|Will not be worked on|ffffff"
  "duplicate|Duplicate of another issue|cccccc"
  "invalid|Not a valid issue|cccccc"
  "accessibility|Accessibility barrier or improvement|1d76db"
  "breaking-change|Introduces a breaking change|b60205"
  "security|Security relevant|b60205"
  "skip-changelog|Exclude from the changelog|cfd3d7"
  "discussion|Belongs in Discussions|cfd3d7"
)

die()  { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }
info() { printf '\033[36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[33mwarn:\033[0m %s\n' "$*" >&2; }

usage() {
  sed -n '2,19p' "$0" | sed 's/^# \{0,1\}//'
}

# --- Arguments --------------------------------------------------------------
# Written for bash 3.2 (the version macOS ships) so the script runs without
# installing a newer bash.
if [ $# -eq 0 ]; then
  usage
  exit 0
fi

TASKS=""
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    labels|licenses|settings|all) TASKS="$TASKS $arg" ;;
    *) die "unknown task: $arg (expected: labels, licenses, settings, all, --dry-run)" ;;
  esac
done

# shellcheck disable=SC2086
set -- $TASKS
[ $# -eq 0 ] && set -- all

command -v gh >/dev/null 2>&1 || die "gh CLI not found. Install it from https://cli.github.com"
gh auth status >/dev/null 2>&1 || die "gh is not authenticated. Run: gh auth login"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LICENSE_SRC="$SCRIPT_DIR/../LICENSE"
[ -f "$LICENSE_SRC" ] || die "LICENSE template not found at $LICENSE_SRC"

info "Organization: $ORG"
[ "$DRY_RUN" -eq 1 ] && info "Dry run — nothing will be changed"

# --- Repository inventory (one API call) ------------------------------------
# `licenseInfo` tells us which repos already carry a LICENSE without needing a
# per-repo contents lookup.
REPO_JSON="$(gh repo list "$ORG" --limit 500 --json name,isPrivate,licenseInfo,defaultBranchRef)"
REPO_COUNT="$(printf '%s' "$REPO_JSON" | jq 'length')"
[ "$REPO_COUNT" -gt 0 ] || die "no repositories found in $ORG"

info "Found $REPO_COUNT repositories"

# --- Task: labels ----------------------------------------------------------
# One paginated call per repo to list existing labels, instead of one call per
# label per repo.
apply_labels() {
  info "Creating standard labels"

  local created=0 skipped=0 repo existing

  for repo in $(printf '%s' "$REPO_JSON" | jq -r '.[].name'); do
    existing="$(gh api "/repos/$ORG/$repo/labels?per_page=100" --jq '.[].name' 2>/dev/null || echo "")"

    for entry in "${LABELS[@]}"; do
      IFS='|' read -r name desc color <<<"$entry"

      if printf '%s\n' "$existing" | grep -qxF "$name"; then
        skipped=$((skipped + 1))
        continue
      fi

      if [ "$DRY_RUN" -eq 1 ]; then
        printf '   [dry-run] %-28s + %s\n' "$repo" "$name"
        continue
      fi

      if gh api --method POST "/repos/$ORG/$repo/labels" \
        -f "name=$name" -f "color=$color" -f "description=$desc" >/dev/null 2>&1; then
        created=$((created + 1))
      else
        warn "$repo: could not create label '$name'"
      fi
    done
  done

  info "Labels — created: $created, already present: $skipped"
}

# --- Task: licenses --------------------------------------------------------
# Commits through the contents API so no local clone is required.
apply_licenses() {
  info "Adding MIT LICENSE to repositories that lack one"

  local created=0 skipped=0 sha
  local license_b64
  license_b64="$(base64 <"$LICENSE_SRC" | tr -d '\n')"

  while IFS=$'\t' read -r repo branch; do
    [ -n "$repo" ] || continue

    if [ "$DRY_RUN" -eq 1 ]; then
      printf '   [dry-run] %-28s + MIT LICENSE\n' "$repo"
      continue
    fi

    sha="$(gh api "/repos/$ORG/$repo/git/ref/heads/$branch" --jq '.object.sha' 2>/dev/null || echo "")"
    if [ -z "$sha" ]; then
      warn "$repo: could not resolve '$branch', skipping LICENSE"
      continue
    fi

    if gh api --method PUT "/repos/$ORG/$repo/contents/LICENSE" \
      -f "message=docs: add MIT LICENSE" \
      -f "content=$license_b64" \
      -f "branch=$branch" -f "sha=$sha" >/dev/null 2>&1; then
      created=$((created + 1))
    else
      warn "$repo: could not create LICENSE"
    fi
  done <<EOF
$(printf '%s' "$REPO_JSON" | jq -r '
  .[]
  | select(.licenseInfo == null)
  | select(.defaultBranchRef != null)
  | "\(.name)\t\(.defaultBranchRef.name)"')
EOF

  skipped=$((REPO_COUNT - created))
  info "Licenses — created: $created, already present or skipped: $skipped"
}

# --- Task: settings --------------------------------------------------------
apply_settings() {
  info "Enabling private vulnerability reporting and discussions"

  local repo enabled=0
  for repo in $(printf '%s' "$REPO_JSON" | jq -r '.[].name'); do
    if [ "$DRY_RUN" -eq 1 ]; then
      printf '   [dry-run] %-28s + private-vulnerability-reporting, discussions\n' "$repo"
      continue
    fi

    if gh api --method PUT "/repos/$ORG/$repo/private-vulnerability-reporting" >/dev/null 2>&1; then
      enabled=$((enabled + 1))
    else
      warn "$repo: could not enable private vulnerability reporting"
    fi

    gh api --method PATCH "/repos/$ORG/$repo" \
      -F has_discussions=true >/dev/null 2>&1 \
      || warn "$repo: could not enable discussions"
  done

  info "Private vulnerability reporting enabled on $enabled repositories"
}

# --- Run requested tasks ---------------------------------------------------
for task in "$@"; do
  case "$task" in
    all)
      apply_labels
      apply_licenses
      apply_settings
      ;;
    labels)   apply_labels ;;
    licenses) apply_licenses ;;
    settings) apply_settings ;;
  esac
done

info "Done"