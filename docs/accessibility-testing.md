# Accessibility testing and remediation workflow

Target: **WCAG 2.1 AA and Section 508.** This document is the workflow, not a
compliance claim. No page in this project is described as "fully compliant"
on the basis of an automated tool alone.

## Honest scope

- The author's resume does **not** document formal WCAG training or an
  accessibility certification (IAAP WAS/CPACC, DHS Trusted Tester, or
  equivalent). None is claimed in this portfolio.
- What is demonstrated: hands-on WCAG 2.1 AA implementation, axe-based
  automated checks, and a manual keyboard + JAWS workflow an interviewer
  can actually run against the app.
- "axe reports no violations" means exactly that, for the pages and states
  checked. It is never rewritten as "the page is compliant."

## 1. Automated checks with axe

1. Run the app (`dotnet run --project src/IowaPortal.Web`).
2. Install the axe DevTools browser extension (Chrome/Edge/Firefox).
3. Run axe on each page **and each state**:
   - Home, Sample services, Design System
   - Apply: initial state, error state (submit empty), and valid state
   - Confirmation, Status (initial, error, result)
4. Record every finding with page, state, rule id, and fix — even if you
   fix it immediately. A finding with no record is a regression waiting
   to happen.
5. Fix, re-run axe, and confirm zero violations **for that state**.

axe catches: missing labels, missing alt text, contrast failures, invalid
ARIA, duplicate ids, heading-order problems, missing accessible names.

axe does **not** catch: whether heading text makes sense, whether focus
order matches visual order, whether error recovery is understandable,
whether a live region announces at the right time, or whether a dialog
behaves correctly with a screen reader. Those need steps 2 and 3.

## 2. Keyboard-only checklist (no mouse, no screen reader)

- [ ] Tab through every page in order: skip link first, then header nav,
      then main content, then footer — in visual order, with no jumps.
- [ ] Every interactive element shows a visible focus indicator (3px
      outline + offset in this design system). No element relies on
      `:hover` alone.
- [ ] The Apply form can be completed and submitted entirely by keyboard,
      including the county dropdown and the terms checkbox.
- [ ] On a validation failure, the error summary is reachable, each error
      link moves focus to its field, and fixing a field clears its error
      on the next submit.
- [ ] The Design System dialog: Enter opens it, Tab stays inside it,
      Shift+Tab wraps correctly, Escape closes it, focus returns to the
      button that opened it.
- [ ] No keyboard trap anywhere: Tab never gets stuck on a page or in a
      component that is not a modal dialog.
- [ ] All functionality reachable by keyboard — no hover-only menus,
      no click-only divs, no drag-only interactions.

## 3. JAWS manual script (the part automation cannot replace)

Use JAWS (or NVDA if JAWS is unavailable — record which one you used)
with the browser the team supports. Work through the Apply journey:

1. **Landmarks and headings:** Press `R` / `D` to move by region, `H` to
   move by heading. Confirm: one `h1`, headings in order, nav labelled
   "Primary navigation", main landmark present.
2. **Form entry (forms mode):** Tab to each field. Confirm JAWS announces
   the label, the hint, and whether the field is required — before you
   type, not after.
3. **Error recovery:** Submit the form empty. Confirm JAWS announces the
   error summary (role="alert"), that each error link is announced as a
   link, and that activating a link moves you to the field and announces
   its error text via `aria-describedby`.
4. **Submission:** Submit a valid form. Confirm the confirmation heading
   and the success status are announced, and the reference number is
   readable (it is real text, not an image).
5. **Status lookup:** Enter a reference number. Confirm the result
   status is announced via the live region and is also readable as
   static text (live regions supplement, never replace, visible text).
6. **Dialog:** Open the Design System dialog. Confirm JAWS announces the
   dialog name and that virtual-cursor navigation stays inside it until
   it closes; confirm focus return on close.
7. **Links:** Tab through links. Confirm every link's purpose is clear
   from its text alone — no "click here", no "read more" without context.

Record: JAWS version, browser version, date, pages/states tested, findings.
A JAWS pass with no record is not a JAWS pass.

## 4. Contrast, reflow, and zoom

- [ ] Body text, muted text, link text, error text, and button text all
      meet 4.5:1 (normal text) or 3:1 (large text / UI components).
      Token values and ratios are in `wwwroot/scss/_tokens.scss`.
- [ ] At 200% browser zoom, no content requires horizontal scrolling
      and no controls are cut off.
- [ ] At 320px viewport width, the layout reflows to a single column
      (WCAG 1.4.10) and the navigation wraps instead of overflowing.
- [ ] With Windows High Contrast / forced-colours mode, buttons, borders,
      and focus indicators remain visible (this system uses borders and
      outlines, not background colour alone, for exactly this reason).

## 5. Six before/after remediation examples (all fixed in this codebase)

| # | Failure | Fix in this project |
|---|---------|---------------------|
| 1 | Placeholder-only label | Visible `<label>` + hint span on every field (Apply page) |
| 2 | Validation shown only in red, or via `alert()` | Error summary with links + inline errors + `aria-describedby` |
| 3 | Heading level chosen for visual size | Structure-driven headings; size from CSS |
| 4 | Modal Tab cannot escape (keyboard trap) | Dialog traps Tab only while open; Escape + focus return |
| 5 | Light-grey text on white (< 4.5:1) | Checked tokens: body ≈16.5:1, muted ≈7.0:1 |
| 6 | Icon-only button with no name | No icon-only controls in this demo; every control has text |

## 6. CI smoke check (not a replacement)

`scripts/a11y-smoke-check.js` fetches the running app's pages and checks
for labels, alt text, heading order, and non-empty link text. The Azure
pipeline runs it after `dotnet test`. It is labelled "smoke check" in
the pipeline for a reason: it catches regressions early, and it proves
nothing about screen-reader behaviour.
