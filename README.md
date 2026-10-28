# Iowa Public Services Portal — Code-Sample Portfolio

**For:** State of Iowa, Department of Management, Division of Information
Technology (DOM DoIT) — Senior .NET Developer and Front-End / UI / UX
Developer opportunity.

**By:** Padmakshi Bhonagiri, Senior Full Stack .NET Developer (10+ years).

**GitHub / Portfolio:** https://github.com/PadhuPadmakshi/padmakshi-bhonagiri-portfolio

**Live UI (GitHub Pages, static demo):** https://padhupadmakshi.github.io/padmakshi-bhonagiri-portfolio/ — this opens the UI in a browser with no install. The full ASP.NET Core app cannot run on GitHub Pages (static hosting only), so the Pages site is a static demo of the same journey; run `dotnet run --project src/IowaPortal.Web` for the full server app.

**What this is:** a complete, runnable ASP.NET Core demonstration
application — a fictional public-services eligibility and benefits portal
with an accessible Apply → Confirmation → Status journey, a token-based
enterprise design system, a REST API, SQL Server integration examples,
automated tests, and an Azure DevOps pipeline.

**What this is not:** a State of Iowa system, a production service, or a
system with government security authorization. It is an independent
portfolio demonstration. All data is fictional. Do not enter real personal
information. See [Honest limits](#honest-limits) below.

---

## Quick start

### Prerequisites

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- Node.js 18+ (only for the accessibility smoke check and for recompiling
  Sass; the app itself runs without Node)
- No database, cloud account, or secret is required. The demo uses EF Core
  InMemory storage by default.

### Run

```bash
dotnet run --project src/IowaPortal.Web
# Open the URL printed on startup, e.g. http://localhost:5000
```

### Test

```bash
dotnet test
```

### Recompile the styles (optional — compiled CSS is committed)

```bash
cd src/IowaPortal.Web
npx sass wwwroot/scss/main.scss wwwroot/css/site.css
```

### Accessibility smoke check (requires the app running)

```bash
node scripts/a11y-smoke-check.js http://localhost:5000
```

This is a smoke check only. It does not replace axe or JAWS testing —
see `docs/accessibility-testing.md`.

## Try it: the complete user journey

1. **Home** (`/`) — portfolio landing, architecture, JD mapping, author
   background (resume only).
2. **Sample services** (`/Services`) — four fictional programs.
3. **Apply** (`/Applications/Apply`) — submit the form validly, then try
   it empty and with a bad email to see the accessible error summary,
   field-level errors, and recovery path.
4. **Confirmation** — note your reference number (e.g. `IA-2026-0001`).
5. **Check status** (`/Applications/Status`) — look the reference up.
6. **Design System** (`/Home/DesignSystem`) — tokens, components, and the
   keyboard-accessible dialog demo (Tab, Shift+Tab, Escape, focus return).
7. **Accessibility** (`/Home/Accessibility`) — what is built in, what
   automation cannot prove, and six before/after fixes.
8. **Code Samples** (`/Home/CodeSamples`) — the interviewer index.

## REST API contract

Base URL is the same as the web app. All responses are JSON.

| Method & path | Success | Failure |
|---|---|---|
| `GET /api/services` | `200` — array of sample services | — |
| `GET /api/applications/{reference}` | `200` — application status | `404` — `{ "error": "No sample application was found…" }` |
| `POST /api/applications` | `201` + `Location: /api/applications/{reference}` | `400` — `{ "error": "Validation failed.", "errors": { "Email": "…" } }` |

Example:

```bash
curl -X POST http://localhost:5000/api/applications \
  -H 'Content-Type: application/json' \
  -d '{"program":0,"firstName":"Jordan","lastName":"Sample",
       "email":"jordan@example.com","county":"Polk","householdSize":3,
       "monthlyHouseholdIncome":2000,"agreesToSampleTerms":true}'
```

Server errors return RFC 7807-style ProblemDetails with a correlation id
for `/api/*` callers (see `Middleware/Middleware.cs`). Stack traces are
never sent to clients.

## Project structure

```
padmakshi-bhonagiri-portfolio/
├── IowaPortal.sln
├── azure-pipelines.yml            # Azure DevOps CI: restore, build, test, a11y smoke check, publish
├── README.md                      # this file
├── docs/
│   ├── architecture.md              # Layer diagram, request flow, deliberate non-choices
│   ├── accessibility-testing.md   # axe + keyboard + JAWS workflow, checklist, before/after
│   ├── design-system.md           # system vs. library vs. framework; tokens; governance
│   ├── legacy-modernization.md    # WebForms vs. ASP.NET Core MVC; strangler sequence
│   ├── sql-server.md              # EF Core + ADO.NET; InMemory → SQL Server switch
│   ├── security.md                # secrets, encryption, what is NOT collected, no authorization claimed
│   └── deployment.md              # GitHub publishing, Azure App Service, future AWS note
├── samples/
│   ├── legacy/                    # Representative WebForms page + code-behind (not compiled)
│   ├── angular/                   # Representative Angular component excerpt (not wired in)
│   └── sql/                       # Table + parameterized stored-procedure scripts
├── scripts/
│   └── a11y-smoke-check.js        # CI smoke check (labels, headings, link text)
├── src/
│   ├── IowaPortal.Domain/         # Entities, enums — no framework dependencies
│   ├── IowaPortal.Application/    # Validation, eligibility, services, DTOs, interfaces
│   ├── IowaPortal.Infrastructure/ # EF Core context, repositories, seed, ADO.NET example
│   └── IowaPortal.Web/            # MVC, API, middleware, Razor views, Sass, JS
│       ├── Controllers/
│       ├── Views/                 # Home, Applications, Services, Shared/_Layout
│       └── wwwroot/
│           ├── scss/              # _tokens, _mixins, _base, _components, main
│           ├── css/site.css       # Compiled from SCSS with Dart Sass (committed)
│           └── js/site.js         # Vanilla JS: dialog focus trap, form hints
└── tests/
    └── IowaPortal.Tests/          # xUnit: validation, eligibility, service paths
```

## Architecture

```
Browser ──► ASP.NET Core MVC / Web API (thin controllers)
              │  dependency injection
              ▼
         Application layer (validation, eligibility, use cases)
              │  interfaces only
              ▼
         Infrastructure (EF Core repositories / ADO.NET example)
              │
              ▼
         InMemory (demo default)  or  SQL Server (by configuration)
```

Dependency flow is one-way: Web → Application → Domain. Infrastructure
implements Application interfaces. Domain and Application reference no
ASP.NET Core packages, so business rules are unit-testable without a
web server or database.

## How each part maps to the DOM DoIT job description

| JD requirement (weight) | Where it is demonstrated |
|---|---|
| .NET / C# (~40%) | ASP.NET Core 8, MVC + Web API, DI, SOLID services, EF Core, legacy modernization sample |
| Front-end, UI / UX (~40%) | Semantic HTML5, Sass design system, responsive layouts, full Apply → Confirmation → Status journey, UX copy and error recovery |
| Middleware and APIs (~10%) | Security-headers + exception middleware, REST API with 201/400/404 + ProblemDetails |
| SQL Server (~10%) | EF Core (SQL Server provider by configuration), repository pattern, parameterized ADO.NET, SQL scripts |
| Accessibility (core, across all) | WCAG 2.1 AA target, axe + JAWS workflow, before/after remediation, keyboard/dialog/form-error checklist |
| Azure DevOps / CI/CD | `azure-pipelines.yml`: restore, build, test, accessibility smoke check, publish artifact |
| Enterprise design system | Token-based system in `wwwroot/scss/`; written distinction from a component library and from Bootstrap/Material; multi-team adoption plan |
| Modernizing (not just greenfield) | Legacy WebForms sample + strangler-sequence doc; resume evidence: .NET 6 → .NET 8 at Centene (Member Self-Service Portal Modernization, early 2024), .NET Core 3.1 → .NET 6 at Frontiers (Author and Reviewer Submission Platform), and Web Forms Section 508/WCAG remediation + mainframe batch interfaces at the State of New Jersey Department of Labor & Workforce Development (Unemployment Insurance Claimant Services Modernization) |
| Government / healthcare experience | Resume: State of New Jersey Department of Labor & Workforce Development, Trenton (government, 2019–2021); Centene, St. Louis, Missouri (healthcare, 2023–present). This demo itself is not government work and does not claim to be. |
| Angular (preferred, not required) | On resume (Angular and TypeScript at Frontiers); representative excerpt in `samples/angular/`. Deliberately not wired into the running app — see below. |
| AWS (preferred, future) | Documented as a future-deployment note in `docs/security.md`. No AWS resources are created here. |
| GitHub (preferred) | Repository-ready layout; publishing steps in `docs/deployment.md`. |

## Technology choices — and deliberate non-choices

- **Razor + vanilla JS, not Angular, for the running app.** Angular is
  verified on the resume, but the DOM DoIT environment described is
  Bootstrap/Material transitioning to an enterprise design system. A
  Razor + token-system implementation demonstrates that transition more
  directly than adding a second front-end framework. Adding Angular
  here would have been keyword-matching, not judgment.
- **No Bootstrap or Material in the running app.** The design system is
  built from tokens so it stands alone and can be evaluated on its own
  merits. In a real DOM DoIT team, the same tokens would theme
  Bootstrap/Material during the transition — the tokens are the
  portable part.
- **InMemory by default, SQL Server by configuration.** Zero-setup demo
  that still shows the real SQL Server wiring, without requiring a
  database server to evaluate the portfolio.
- **No cloud services.** Nothing in this demo needs Azure, AWS, or any
  account, so a reviewer can run it anywhere.

## SQL Server setup (optional)

```bash
# 1. Create a SQL Server database and set the connection string
#    via an environment variable (never commit it):
export ConnectionStrings__PortalDb="Server=localhost;Database=IowaPortal;Trusted_Connection=True;TrustServerCertificate=True"

# 2. In appsettings.json (or an environment override), set:
#    "UseSqlServer": true

# 3. Apply migrations (from src/IowaPortal.Web):
dotnet ef migrations add Initial
dotnet ef database update
```

See `docs/sql-server.md` for the schema and the parameterized-query rule.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `dotnet: command not found` | Install the .NET 8 SDK (link above) and reopen your terminal. |
| Port already in use | `dotnet run --project src/IowaPortal.Web --urls http://localhost:5001` |
| Status lookup finds nothing | The demo store is in-memory and resets on restart. Submit a fresh sample application first, and use its reference number in the same run. |
| Sass command fails | Not required to run the app — `site.css` is already compiled and committed. Install Sass with `npm i -g sass` only if you want to change styles. |
| Tests fail on first run | Run `dotnet restore` first, then `dotnet test`. Network access is needed once to restore NuGet packages. |

## Honest limits — read before submitting this portfolio

1. **No WCAG certification is claimed.** The Iowa-tailored resume
   documents formal WCAG training and routine keyboard and screen-reader
   testing with JAWS and NVDA, plus axe remediation — but it names no
   specific certification (for example, IAAP WAS/CPACC or DHS Trusted
   Tester), and none is claimed here. This portfolio demonstrates WCAG
   2.1 AA implementation and a documented axe + JAWS workflow.
2. **No page is claimed to be "fully compliant."** Automated checks
   (axe, the CI smoke check) are reported as automated results only.
   A live JAWS pass and a live axe pass by a human tester are still
   required and are documented as manual steps in
   `docs/accessibility-testing.md` — they were not performed in the
   Linux build environment used to create this project, which has no
   JAWS installation.
3. **No previous work for the State of Iowa is claimed.** The author's
   government experience is the State of New Jersey Department of Labor
   & Workforce Development role on her resume.
   This demo is an independent portfolio piece, not Iowa work product.
4. **No degree in Human-Computer Interaction is claimed.** The author's
   degrees are a Master of Science from Saint Louis University, St. Louis,
   Missouri, and a Bachelor of Technology in Information Technology (JNTU
   Hyderabad, 2011–2015), plus 10+ years of professional experience.
5. **No government security authorization.** This demo has not been
   security-reviewed and must not be presented as an authorized system.
6. **Eligibility screening is fictional.** Thresholds and outcomes in
   `EligibilityService` are invented for demonstration and are not real
   benefit rules. The UI says so, in plain language, on the confirmation
   and status pages.
7. **Screenshots:** none are included in this repository, because
   screenshots in a repo go stale the moment styles change. Run the app
   and capture current screenshots if a submission form requires them —
   the Design System and Apply pages are the best candidates.

## What was actually verified (in the build environment, 2026-10-27)

- **Build:** `dotnet build IowaPortal.sln -c Release` — succeeded, 0 warnings, 0 errors (after one fix: a missing `Microsoft.EntityFrameworkCore` using in `SeedData.cs`).
- **Styles:** `wwwroot/scss/` compiled to `wwwroot/css/site.css` with Dart Sass 1.106.1, no errors.
- **Running app:** started on `http://localhost:5000`. Home, Services, Apply, Design System, Accessibility, and Code Samples pages returned 200. API: `GET /api/services` 200 with 4 programs, `POST /api/applications` valid → 201 with reference `IA-2026-0001`, invalid → 400 with the documented field-keyed error shape, unknown reference → 404.
- **Full MVC journey:** empty form POST re-rendered with the error summary and a link to `#FirstName`; valid form POST redirected to Confirmation (`IA-2026-0002` in that run) and the Status page then found that reference.
- **Accessibility smoke check:** `node scripts/a11y-smoke-check.js` passed on 6 pages (labels, skip link, landmarks, headings, link text). This is a smoke check, not an axe or JAWS pass.
- **Business logic:** all 11 checks mirroring the xUnit tests passed when run in-process through a temporary verification harness (validation success/failure, eligibility thresholds, submit/retrieve, unknown reference, seeded programs).
- **NOT verified here — please run on your own machine:**
  - `dotnet test` (xUnit runner): in this sandbox, the vstest testhost process connected but its message loop then failed with a deserialization / end-of-stream error, and `vstest.console` never received results within 280 seconds. The test code itself is standard xUnit and the same cases pass in the harness above, but do not treat `dotnet test` as verified until you run it locally. This is a sandbox limitation, not a code change you need to make.
  - **axe and JAWS:** not run here (no JAWS, no browser extension in this Linux sandbox). Follow `docs/accessibility-testing.md` for the manual pass.
  - **Screenshots:** headless Chrome in this sandbox failed to render pages (empty output), so no screenshots are included. Run the app and capture Home, Apply, and Design System pages if a submission form asks for them.
  - **SQL Server provider:** the SQL Server code path is wired but was not run against a live SQL Server here (no server in the sandbox); the demo ran on InMemory. Test `UseSqlServer` against a real instance before claiming that path.

## Publishing

See `docs/deployment.md` for the exact GitHub steps, Azure App Service
option, and the pre-push secrets check. In short: create an empty GitHub
repository, push this folder, and share the link on your resume and in
the submission. No account authorization beyond your own GitHub account
is required for the repository step; hosting a live demo requires your
own hosting account and is optional.
