# Publishing this portfolio (repository + hosted demo)

## Option A — GitHub repository (recommended first step, no account approval needed beyond your own GitHub account)

```bash
cd padmakshi-bhonagiri-portfolio
git init
git add .
git commit -m "Initial portfolio: accessible ASP.NET Core public-services demo"
# Create an EMPTY repository on github.com (do not add a README there),
# then:
git remote add origin https://github.com/<your-username>/padmakshi-bhonagiri-portfolio.git
git branch -M main
git push -u origin main
```

Share the repository link on your resume and in the submission, alongside
a one-line note: "Working code-sample portfolio — ASP.NET Core, accessible
design system, fictional sample data only." The README at the repo root
is the landing page for reviewers who do not run the app.

**Before pushing, check:** no secrets in `appsettings*.json`, no real
personal data in seed data or tests, and `git status` shows only the
files you intend to publish.

## Option B — Hosted demo (optional, needs your own hosting account)

The app is a standard ASP.NET Core 8 app. The simplest honest hosting:

- **Azure App Service:** publish with `dotnet publish -c Release`,
  deploy the output, set `UseSqlServer` / connection string via App
  Service configuration (never in source). Azure DevOps pipeline in
  this repo already produces the publish artifact; add a release stage
  with your own service connection.
- **Any Linux host with .NET 8:** `dotnet publish`, run the DLL behind
  a reverse proxy with HTTPS. InMemory mode works with no database.

Do **not** present a hosted demo as a State of Iowa service. Keep the
in-app disclaimer banner visible on every page, including the hosted
version.

## Option C — Share without hosting

If you prefer not to host anything, the repository alone satisfies the
"code samples or portfolio required upfront" rule: reviewers can read
the code, run `dotnet test`, and run the app locally in minutes. A
zipped copy of this folder is equally acceptable as an attachment to a
submission — the README and this file explain how to run it.

## What was verified in the build environment

See the README section "What was actually verified" for the exact
commands run, the test count, and the items that could not be verified
here (notably, a live JAWS pass requires a Windows + JAWS environment,
and a live axe pass requires a browser extension run by a human — both
are documented as manual steps, not claimed as done).
