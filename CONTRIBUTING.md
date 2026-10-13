# Contributing to Florex Labs

Thanks for your interest in contributing. Florex Labs builds independent software
products, developer tooling, and open-source systems. This guide describes the
defaults that apply across every repository in the organization.

> Individual repositories may add stricter rules. When a repository ships its own
> `CONTRIBUTING.md`, that file wins — read it first.

---

## Where to start

| I want to… | Go to |
| --- | --- |
| Report a bug | [Bug report template](.github/ISSUE_TEMPLATE/bug_report.yml) |
| Propose a feature | [Feature request template](.github/ISSUE_TEMPLATE/feature_request.yml) |
| Report a vulnerability | [SECURITY.md](SECURITY.md) — **do not open a public issue** |
| Ask a question | [SUPPORT.md](SUPPORT.md) |
| Send a patch | The fork → branch → pull request flow below |

Issues that only touch documentation, tests, or tooling are good first
contributions. Look for issues labelled `good first issue` or `help wanted`.

---

## Development environment

Florex Labs is **TypeScript-first**. Most repositories run on Node.js 24.

```bash
# Use the Node version pinned by the repository
nvm install && nvm use

# Install dependencies — match the repository's lockfile
pnpm install --frozen-lockfile   # pnpm repositories
npm ci                           # npm repositories

# Run the quality gates in order
pnpm lint
pnpm typecheck
pnpm test
pnpm build
```

**Conventions**

- **Package manager** — `pnpm` for new repositories; `npm` where a lockfile
  already exists. Never `yarn` or `bun`. Commit the lockfile.
- **Node version** — pin it in `.node-version` and have CI read it with
  `node-version-file`. Do not hardcode a version inside a workflow.
- **Modules** — use ESM (`"type": "module"`).
- **Tests** — Vitest for unit tests, Playwright for end-to-end. Plain
  `node:test` is acceptable for infrastructure and policy scripts.
- **Formatting** — Prettier. `semi: true`, `tabWidth: 2`,
  `trailingComma: "all"`, `singleQuote: true`.
- **Linting** — ESLint flat config. Never legacy `.eslintrc.*`.

---

## Code standards

These are the defaults. They come from how we actually build, not from
preference for its own sake.

### TypeScript

- `strict: true`. Add `noUncheckedIndexedAccess` and
  `exactOptionalPropertyTypes` where you can.
- **No explicit `any`.** No unsafe casts, no `@ts-ignore`, no
  `@ts-expect-error` without a comment explaining why it is unavoidable.
- Model domain data with discriminated unions and exhaustive handling.
- Prefer `import type` for type-only imports.

### Architecture

- Keep layers separated. Domain and application code must not import framework
  or infrastructure packages (no `@nestjs/*`, `react`, `pg`, `ioredis` in a
  domain folder).
- Dependencies point inward. Presentation and infrastructure depend on the
  domain, never the reverse.

### Testing

- Write the failing test first (**RED → GREEN → REFACTOR**).
- New behavior ships with tests. A bug fix ships with a regression test.
- Avoid snapshot tests of whole component trees; assert behavior instead.

### Security

- Never print or commit credentials, tokens, Terraform state, or plan output.
- Keep `actionlint` and secret scanning clean.
- Pin third-party GitHub Actions to a full commit SHA and comment the version.
- **There are no automatic production deploys.** Applying infrastructure,
  running migrations, and shipping to production are always deliberate,
  human-approved actions.

---

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org/):

```text
feat: add avatar component
fix: resolve tooltip positioning on scroll
docs: document the crawler extension interfaces
refactor: extract the embedding provider boundary
test: cover retry backoff in the crawler
chore: bump tailwind to v4
```

- Use a scope when the repository has a clear module boundary: `feat(cli): ...`.
- Keep commits small and single-purpose. One commit, one reason.
- Write the subject in the imperative mood, under 72 characters.
- Explain *why* in the body, not *what* — the diff already shows the what.

---

## Pull requests

1. **Fork** the repository and create a branch off `main`.
2. **Make the change.** Add tests and update documentation in the same PR.
3. **Run the gates locally** — `lint`, `typecheck`, `test`, `build` must all pass.
4. **Open the PR** against `main` using the [PR template](.github/PULL_REQUEST_TEMPLATE.md).
5. **Respond to review.** Push follow-up commits rather than force-pushing a
   branch someone is reviewing, unless you are asked to.

### What we look for

- One PR solves one problem. Split unrelated changes.
- CI is green.
- Tests cover the new behavior.
- Public APIs, flags, and configuration are documented.
- No secrets, tokens, or customer data in the diff.
- Accessibility is preserved for any UI change.

### Review expectations

Reviews are about the code, never the person. Expect direct, specific feedback.
A request for changes is not a rejection of the idea.

---

## Reporting bugs

A good bug report includes the repository name, the exact version or commit, your
operating system and runtime version, reproducible steps, what you expected to
happen, and what actually happened. The [bug template](.github/ISSUE_TEMPLATE/bug_report.yml)
walks you through it.

If you cannot reproduce it, say so — that is genuinely useful information.

---

## Code of Conduct

Participation in Florex Labs projects is governed by our
[Code of Conduct](CODE_OF_CONDUCT.md). By contributing you agree to follow it.

---

## Licensing

Contributions to Florex Labs repositories are accepted under the **MIT License**.
See [LICENSE](LICENSE).

---

## Security

Do **not** report vulnerabilities through public issues or pull requests. Follow
[SECURITY.md](SECURITY.md) so we can protect users while we prepare a fix.