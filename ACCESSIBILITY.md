# Accessibility

Florex Labs is committed to making our software usable by everyone, including
people with disabilities. Accessibility is a product requirement, not a
polish item.

> Individual repositories may extend this policy with product-specific targets.
> A repository's own `ACCESSIBILITY.md` takes precedence over this default.

---

## Our standard

Public Florex Labs projects target **WCAG 2.1 Level AA**, and for user interfaces
we target **Level AAA** wherever the medium allows it.

---

## How we build it in

These are defaults across Florex Labs repositories, not aspirations.

### Components and UI

- Every interactive element is reachable and operable by keyboard, with a
  visible focus indicator that meets contrast requirements.
- All functionality is available without a pointer. No mouse-only paths.
- Color is never the only carrier of meaning — pair it with text, an icon, or a
  shape.
- Text and meaningful non-text content meet minimum contrast ratios: **4.5:1**
  for body text, **3:1** for large text and UI components.
- Layouts work at **200% zoom** and reflow to **320 CSS px** without horizontal
  scrolling or loss of content.
- Status changes are announced to assistive technology, not conveyed by color
  alone.

### Design systems

- Component APIs are built on native HTML semantics first, ARIA second. ARIA is
  a supplement, never a substitute for correct markup.
- `@florexlabs/ui` components ship with accessibility baked in and are tested
  with `axe-core`. When you use them, do not strip their semantics.

### Verification

Automated checks are a floor, not a ceiling — roughly a third of accessibility
issues are not machine-detectable.

- Automated testing with `axe-core` or `@axe-core/playwright` runs in CI
- Keyboard-only walkthroughs are part of the review checklist for UI changes
- Screen reader spot-checks use VoiceOver (macOS) at minimum

---

## Known gaps

We do not yet maintain a published per-component accessibility report, and not
every repository has a formal audit on record. Where a known barrier exists in a
specific product, it is documented in that repository's documentation.

---

## Reporting a barrier

If something blocks you from using our software, **please tell us**. We treat
accessibility barriers as bugs with the same urgency as a crash.

Report through one of these channels:

1. Open an issue with the **accessibility** label — use this for barriers that
   carry no security or privacy risk
2. Email **hello@florexlabs.com** — preferred when the barrier relates to
   assistive technology you would rather not describe publicly

Please include the page, component, or command involved, the assistive
technology and browser you are using, and what you expected to happen.

We acknowledge reports within **48 hours** and aim to give a remediation plan
within **7 days**.

---

## Contributing to accessibility

If you are fixing an accessibility barrier, a small focused pull request is
ideal. Please note the barrier you resolved, the assistive technology you
verified with, and any behaviour that intentionally changed. Read
[CONTRIBUTING.md](CONTRIBUTING.md) first.