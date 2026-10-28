# Enterprise design system — how this one works, and how teams adopt it

## The distinction (the interview question, answered in code)

- **CSS framework (e.g. Bootstrap):** utility and layout classes you
  compose in markup. It speeds up a page, but visual decisions live in
  every page, so two teams drift apart even when both "use Bootstrap."
- **Component library (e.g. Material UI):** ready-made components with
  their own styles and APIs. Reusable, but without shared tokens and
  guidance, teams still drift in colour, spacing, language, and
  accessibility behaviour.
- **Enterprise design system:** tokens + components + patterns +
  guidance + governance. The system is the shared language and the
  ownership model, not just the code. A component library is one part
  of it; Bootstrap can be *themed by* it (tokens mapped onto Bootstrap
  variables) without being replaced overnight.

DOM DoIT's stated direction — Bootstrap and Material today, enterprise
design system as it rolls out — is exactly the transition this project
is built for: tokens first, components next, patterns last, no big-bang
rewrite (see the Design System page in the app for the step-by-step plan).

## What is in this system

| Piece | File | Rule |
|---|---|---|
| Tokens | `wwwroot/scss/_tokens.scss` | Single source of truth for colour, spacing, breakpoints, type. No component hard-codes a value. |
| Mixins | `wwwroot/scss/_mixins.scss` | `respond()` (breakpoints), `focus-ring()` (never removed without replacement), `button-base()`, `sr-only()`. |
| Base | `wwwroot/scss/_base.scss` | Landmarks, skip link, link/focus defaults, reduced-motion. |
| Components | `wwwroot/scss/_components.scss` | Buttons, alerts, forms, cards, tables, badges, dialog, swatches. |
| Compiled CSS | `wwwroot/css/site.css` | Built with Dart Sass: `npx sass wwwroot/scss/main.scss wwwroot/css/site.css`. Committed so the app runs without a Sass toolchain. |

## Sass practices demonstrated

- **Variables and maps:** `$spacing` and `$breakpoints` maps, read with
  `map.get()` — one place to change spacing or breakpoints.
- **Mixins with content blocks:** `respond(md) { ... }` wraps a media
  query without repeating breakpoint values.
- **Responsible nesting:** at most one level for a component's children
  (e.g. `.site-header a`), never deep descendant chains that cannot be
  overridden without `!important`.
- **Modular files:** tokens, mixins, base, and components are separate
  partials imported by `main.scss` in dependency order.
- **No framework dependency in the running app:** the app deliberately
  does not load Bootstrap, to prove the system stands alone. In a real
  DOM DoIT team, the same tokens would theme Bootstrap/Material during
  the transition — the tokens are the portable part, not the CSS output.

## Governance (what makes it "enterprise" rather than "a stylesheet")

1. Token changes require a contrast re-check and a keyboard pass.
2. New components must ship with: token-based styles, a keyboard test,
   an error/empty state, and a usage example on the Design System page.
3. No team forks tokens locally. A local override is a proposed token
   change, reviewed centrally.
4. Accessibility is an acceptance gate, not a backlog item: a component
   that fails the checklist in `docs/accessibility-testing.md` does not
   ship, however good it looks.
