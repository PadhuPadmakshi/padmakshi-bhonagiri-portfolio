# Front-end and UI/UX case studies — resume evidence, not backend only

The DOM DoIT job description is explicit: a portfolio should show UI work,
not only backend code. Front-end, UI, and UX are about 40% of the role,
accessibility is core across all of it, and candidates must already be able
to work within an enterprise design system independently.

Every case study below is drawn only from the author's Iowa-tailored resume.
No project, metric, or client outcome is invented here. Where the resume
does not give a number, none is claimed.

## How I work from a design — the pattern across all three cases

1. **Read the specification, not just the picture.** From the UX team:
   spacing, type, breakpoints, interaction behaviour, and validation states.
   The built screen must match the specification, and gaps are closed
   before release, not after.
2. **Tokens first.** Colour, spacing, and type come from design tokens,
   not one-off styles, so a second team can adopt the same components
   without copying pages. This is the distinction the job description
   asks for: a design system is tokens + components + patterns +
   guidance + governance; a component library and a framework
   (Bootstrap, Angular Material) are only parts of it.
3. **Semantic structure before styling.** Landmarks, heading order,
   labelled controls, and plain-language error messages, then CSS.
4. **Interaction and validation states, designed, not improvised.**
   Default, focus, error, success, disabled, and loading states for
   every control, plus what happens when a step fails.
5. **Keyboard and screen reader before sign-off.** Keyboard-only
   navigation, focus management and return, JAWS and NVDA checks,
   axe (and WAVE where the resume names it) remediation — then a
   regression pass each release on high-traffic pages, in Chrome,
   Edge, Firefox, and Safari, on desktop and mobile.
6. **Demo to UX and product before release.** Walk through interaction
   behaviour, validation states, and mobile layouts, settle usability
   questions, and get acceptance criteria signed off in sprint review.

## Case 1 — Centene, St. Louis: Member Self-Service Portal Modernization
**Role:** Senior .NET & Front-End Accessibility Developer, Nov 2023–present.
**What members do:** view coverage, find providers, review claims,
manage benefits.

### The front-end work
- Turned Figma designs from the UX team into responsive pages in
  semantic HTML5, Sass/SCSS, and JavaScript, matching the spacing,
  type, and breakpoints in the specification.
- Built and extended components in Centene's shared enterprise design
  system, pulling colour, spacing, and type from design tokens instead
  of one-off styles, and documented each component in Storybook.
- Moved legacy Bootstrap screens onto design-system components while
  keeping existing business behaviour, so the portal has one consistent
  set of interaction patterns instead of drifting page by page.

### Accessibility, in the work itself
- Wrote each story to WCAG 2.1 AA and Section 508: landmarks, heading
  order, labelled controls, clear error messages, and ARIA live
  regions for content that updates on the page.
- Fixed accessibility defects in claims search filters, date pickers,
  modal dialogs, and multi-step forms — focus traps, lost focus on
  close, and low contrast — checking each fix with JAWS, NVDA, and
  axe DevTools.
- Added axe-core checks to the Azure DevOps build so new accessibility
  violations fail before code reaches QA, and ran an accessibility
  regression pass each release on high-traffic pages, re-checking
  keyboard order, focus return, screen-reader announcements, and
  layout across browsers and devices.

### What to look at in this portfolio
- `src/IowaPortal.Web/Views/Home/DesignSystem.cshtml` — tokens,
  components, and the keyboard-accessible dialog demo (the same
  focus-trap / focus-return pattern fixed in Centene modals).
- `src/IowaPortal.Web/Views/Home/UiUx.cshtml` — multi-step form with
  progress steps, inline validation, and an accessible error summary.
- `wwwroot/scss/_tokens.scss` — the token layer a design system
  actually turns on.

## Case 2 — Frontiers, Tampa: Author and Reviewer Submission Platform
**Role:** Senior Front-End & .NET Software Developer, Aug 2021–Oct 2023.
**What users do:** researchers, editors, and reviewers submit, review,
and track scholarly articles, from upload to editorial decision.

### The front-end work
- Built Angular and TypeScript front-end modules styled with Sass/SCSS
  for manuscript upload, reviewer assignment, and decision letters,
  working from UX prototypes; used the Bootstrap grid and Angular
  Material components, and wrote shared Sass mixins and variables so
  every team pulled from the same spacing, colour, and type values.
- Helped the team move from page-level styling to a shared component
  library, building reusable form fields, tables, and alerts with
  documented states and accessibility notes, and agreed component
  behaviour and accessibility expectations with UX and the other
  development teams, so workflows stopped drifting into different
  patterns for the same controls.
- Wrote usage guidance for the shared components — supported states,
  do and don't examples, and code snippets — so developers on other
  modules could pick them up without asking.
- Simplified the multi-step submission form with UX designers by
  adding progress steps, inline validation, and save-and-resume.

### Accessibility, in the work itself
- Cleared WCAG 2.1 AA issues in submission forms and reviewer
  dashboards, including missing labels, keyboard traps, heading
  order, and low-contrast text found with axe DevTools and WAVE.
- Checked file upload, autocomplete, and data-table components with
  NVDA and JAWS before each release.

### What to look at in this portfolio
- `Views/Home/UiUx.cshtml` — the progress-step, inline-validation,
  and save-and-resume pattern, shown as a working demo rather than
  described.
- `samples/angular/` — a representative Angular component excerpt
  (deliberately not wired into the running app; see the README for
  why a second framework here would be keyword-matching, not judgment).
- `docs/design-system.md` — system vs. library vs. framework, and
  component governance.

## Case 3 — State of New Jersey, Department of Labor & Workforce
Development, Trenton: Unemployment Insurance Claimant Services Modernization
**Role:** Senior Software Developer (.NET / UI), Dec 2019–Aug 2021.
**What residents do:** file claims, complete weekly benefit
certification, and check claim status — during the COVID-19 surge,
including Pandemic Unemployment Assistance (PUA) and other CARES Act
programs, on short federal deadlines.

### The front-end work
- Rebuilt the weekly benefit certification pages as mobile-friendly
  layouts in HTML5, CSS3, Sass, and JavaScript, keeping the existing
  eligibility rules intact.
- Built shared UI controls and styles (headers, form fields, alerts,
  buttons) to the state's web standards, so claimant pages looked and
  behaved the same across modules.
- Rewrote claimant questions and error messages in plain language
  with business analysts, for residents with limited digital
  experience — usability as a design decision, not a copy edit.
- Walked UI program staff through each change in UAT before go-live,
  checking business rules, accessibility, and claimant messaging, so
  releases during high-volume weeks went out without rollback.

### Accessibility, in the work itself
- Brought legacy Web Forms pages up to Section 508 and WCAG 2.1 AA by
  replacing layout tables with semantic markup, adding labels and
  instructions, fixing tab order, and adding error summaries.
- Tested claimant pages with JAWS, keyboard-only navigation, and axe
  scans before each release.

### What to look at in this portfolio
- `Views/Applications/Apply.cshtml` — submit it empty, then with a
  bad email: the accessible error summary, field-level errors, and
  recovery path are the NJDOL pattern, in code.
- `docs/legacy-modernization.md` — WebForms → ASP.NET Core, including
  what layout tables and control-rendered markup get wrong.
- `docs/accessibility-testing.md` — the axe + keyboard + JAWS
  workflow, with before/after fixes.

## What this portfolio deliberately does not claim

- No Figma files are included: the Figma designs in these cases came
  from UX teams on client work and are not the author's to publish.
  What is shown is the translation of a design specification into
  working, accessible interfaces — which is what the job description
  asks a developer to do.
- No accessibility certification is claimed. The Iowa-tailored resume
  documents formal WCAG training and routine JAWS/NVDA testing plus
  axe remediation, but names no specific certification, and none is
  claimed here.
- No degree in Human-Computer Interaction is claimed. The author's
  degrees are a Master of Science from Saint Louis University and a
  Bachelor of Technology in Information Technology from JNTU Hyderabad,
  plus 10+ years of professional experience — which the job description
  accepts as equivalent professional experience.
- No outcome metric is claimed for any case study, because the resume
  gives none. The evidence is the work, its accessibility checks, and
  the code that demonstrates the same patterns.
