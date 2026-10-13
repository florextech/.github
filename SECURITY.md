# Security Policy

Florex Labs takes security seriously. We appreciate the work of researchers and
users who report vulnerabilities responsibly.

> Individual repositories may extend this policy with product-specific scope. A
> repository's own `SECURITY.md` takes precedence over this default.

---

## Reporting a vulnerability

**Please do not open a public issue, pull request, or discussion for a security
vulnerability.** A public report gives attackers a head start.

Report privately through either channel:

1. **GitHub Security Advisories** — use the *Report a vulnerability* button on
   the repository's **Security** tab. This opens a private advisory visible only
   to maintainers.
2. **Email** — write to **hello@florexlabs.com**.

Please include:

- The affected repository and, if possible, the exact version or commit SHA
- A description of the vulnerability and its impact
- Steps to reproduce, ideally a proof of concept
- Any suggested mitigation you already know of

### What to expect

| Stage | Target |
| --- | --- |
| Acknowledgement | Within **48 hours** |
| Triage and severity assessment | Within **7 days** |
| Fix or mitigation plan | Agreed with you before public disclosure |
| Public advisory | After a fix is released, coordinated with you |

We will keep you updated throughout, and we will credit you in the advisory
unless you prefer to remain anonymous. If we cannot reproduce the report, we will
say so and explain why — that feedback is valuable too.

---

## Supported versions

Security fixes land on the latest release line. Older lines receive fixes only
when the exposure is severe or the upgrade path is impractical.

| Version | Supported |
| --- | --- |
| Latest release | Yes |
| Previous minor | Critical and high severity fixes |
| Anything older | Best effort, upgrade recommended |

---

## Safe defaults

The security posture we expect across Florex Labs repositories:

- Secrets live in environment variables or a secret manager — never in the
  repository, never in build logs, never in committed plan output.
- Infrastructure changes go through reviewed Terraform plans. **There are no
  automatic production applies.**
- Migrations and deploys are deliberate, human-approved operations.
- Third-party GitHub Actions are pinned to full commit SHAs.
- Container and service images are pinned by digest where reproducibility
  matters.
- Outbound calls to user-supplied URLs (crawlers, webhooks, fetchers) are
  constrained against SSRF to internal and link-local ranges.
- Subprocess invocations never interpolate user input into a shell string.

If a repository violates one of these, that is a defect — please report it.

---

## Scope

In scope:

- Authentication, authorization, and session handling
- Injection: SQL, command, template
- Path traversal and unsafe file handling
- Unsafe deserialization
- Cross-site scripting and cross-origin misconfiguration
- Server-side request forgery
- Hardcoded credentials or leaked secrets
- Vulnerable or unmaintained dependencies with a realistic exploit path
- Electron preload/IPC boundary violations in desktop apps

Out of scope:

- Vulnerabilities requiring an already-compromised host
- Findings from automated scanners with no demonstrated impact
- Denial of service through deliberate resource exhaustion
- Missing hardening headers with no concrete exploit
- Reports generated purely by a fuzzer with no reproducible crash
- Social engineering of maintainers

## Safe harbor

We support coordinated disclosure. If you follow this policy — giving us a
reasonable window to ship a fix before public disclosure — we will not pursue
action against you for your research.

---

## Security contact

**hello@florexlabs.com** · Colombia (UTC-5)