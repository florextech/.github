# Florex Labs engineering standards

The conventions encoded in this repository's community health files, distilled
from how the organization actually builds. A repository may go stricter; it
should not silently go looser without a reason.

---

## Language and runtime

| Concern | Standard | Rationale |
| --- | --- | --- |
| Language | TypeScript first | One shared language across product, tooling, and infra |
| Node | 24.x, pinned in `.node-version` | Single version across the org, read by CI via `node-version-file` |
| Modules | ESM (`"type": "module"`) | Consistent resolution across repos |
| Package manager | `pnpm` for new work, `npm` where a lockfile exists | Never `yarn`, never `bun` |
| Lockfile | Always committed, installed with `--frozen-lockfile` / `npm ci` | Reproducible builds |

Pin the package manager in `packageManager` when setting up a new repository.

## Tooling

| Tool | Standard | Note |
| --- | --- | --- |
| Linting | ESLint flat config | No legacy `.eslintrc.*` |
| Formatting | Prettier | `semi`, `tabWidth: 2`, `trailingComma: "all"`, `singleQuote: true` |
| Unit tests | Vitest | `node:test` is acceptable for infra and policy scripts |
| E2E | Playwright | Where end-to-end coverage exists |
| Accessibility | `axe-core` / `@axe-core/playwright` in CI | Plus keyboard and screen-reader walkthroughs |
| CI | GitHub Actions | Only provider in use |
| Workflow validation | `actionlint` | Catches workflow syntax errors before they run |
| Secrets | `scan-secrets.mjs` or equivalent | No credentials in logs, plans, or state |

ESLint never enforces formatting. Prettier owns formatting; ESLint owns
correctness. Do not enable `eslint-plugin-prettier`.

## The quality gate

Every repository runs these in this order, and CI must match the local order so
failures reproduce:

```bash
pnpm format:check   # where Prettier is configured
pnpm lint
pnpm typecheck
pnpm test
pnpm build
```

Nothing merges with a red gate. A skipped gate is a documented decision, not a
default.

## TypeScript

- `strict: true`. Where practical, `noUncheckedIndexedAccess` and
  `exactOptionalPropertyTypes`.
- **No explicit `any`.** No unsafe casts, no suppressions without a written
  reason.
- Model domain state with discriminated unions and exhaustive handling.
- `import type` for type-only imports.

## Architecture

Dependencies point inward. `domain` and `application` layers must not import
framework or infrastructure code — no `@nestjs/*`, `react`, `pg`, or `ioredis`
inside a domain folder. Enforce this with `no-restricted-imports`, not by
convention.

## CI and supply chain

The following CI and supply-chain practices are the target for every new
repository:

- `runs-on: ubuntu-24.04`, never `latest`
- Workflow-level `permissions:` block, least privilege per job
- `timeout-minutes` set on every job
- **Third-party Actions pinned to a full commit SHA** with the version in a
  trailing comment
- Service and container images pinned by digest
- `pnpm audit --audit-level=critical` and container scanning on critical findings

Floating `@v4` tags and `ubuntu-latest` are the main gap in the older
repositories.

## Commits and pull requests

- Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`,
  `chore:`, with a scope when the module boundary is clear.
- One commit, one reason. One pull request, one problem.
- Subject in the imperative mood, under 72 characters.
- The body explains *why*, not *what*.

## Releases

Four mechanisms are in use; pick deliberately and document it.

| Case | Mechanism |
| --- | --- |
| npm package | Publish on GitHub Release with `id-token: write` and `--provenance` |
| Container | Tag by `github.sha` and push to GHCR |
| Desktop app | Tag `v*.*.*` and build signed artifacts |
| Changelog-only | Release Drafter driven by PR labels |

## Deployment

**There are no automatic production deploys.** Terraform plans are reviewed,
production applies are deliberate human actions, and migrations never run
automatically. Container deploys go to Dokploy through an explicit, gated
workflow.

## Security baseline

- Credentials only from environment or a secret manager. Never in a repository,
  a log, or committed plan output.
- Terraform state and plan output stay out of Git. Never printed.
- Outbound requests to user-supplied URLs are constrained against SSRF to
  internal and link-local ranges.
- Subprocess calls never interpolate user input into a shell string.
- Private vulnerability reporting is enabled on every public repository.

## AI-assisted contributions

Florex Labs uses AI agents as leverage, not as decoration. Two rules apply:

1. **Do not claim work you did not verify.** Never state that tests passed, a
   build succeeded, or a deploy completed unless you actually ran it and saw it
   pass.
2. **The human owns the change.** The author of a pull request is accountable
   for every line in it, including the ones a tool produced.

## Working with agents in a repository

Repositories that rely on agent workflows may carry an `AGENTS.md` at the root
describing the working protocol. Where present, it takes precedence over this
document for agent behaviour.