# Architecture

```
Browser ──► ASP.NET Core MVC / Web API (thin controllers, middleware)
              │  dependency injection (Program.cs)
              ▼
         Application layer — validation, eligibility, use cases
              │  interfaces only (IApplicationService, repositories)
              ▼
         Infrastructure — EF Core repositories, seed data, ADO.NET example
              │
              ▼
         InMemory (demo default)  or  SQL Server (UseSqlServer + connection string)
```

## Why this shape

- **Testability:** business rules live in Domain/Application, which
  reference no ASP.NET Core packages. `dotnet test` exercises validation,
  eligibility, and service paths without a web server.
- **Replaceable data access:** controllers and services depend on
  repository interfaces. Switching InMemory → SQL Server is a
  configuration change in `Program.cs`, not a code change in callers.
- **Single validation truth:** `ApplicationValidator` serves both the
  MVC form and the REST API, so the two surfaces cannot drift apart.
  Razor DataAnnotations give labels and hints; the validator decides.
- **Thin controllers, thick-enough services:** controllers translate
  HTTP ↔ DTOs and render views / status codes. They contain no business
  rules and no SQL.
- **Middleware as cross-cutting concerns:** security headers and
  exception handling (ProblemDetails + correlation id, no stack traces)
  live in middleware, not duplicated in controllers.

## Request flow: submitting a sample application

1. `POST /Applications/Apply` (MVC) or `POST /api/applications` (API)
   → `ApplicationSubmissionDto`.
2. `ApplicationService.SubmitAsync` → `ApplicationValidator.Validate`.
   On failure: MVC re-renders the form with a linked error summary;
   the API returns `400` with field-keyed errors.
3. On success: a reference number is generated, the entity is saved
   through `IApplicationRepository`, and the caller gets a redirect
   (MVC, Post/Redirect/Get) or `201 Created` with a Location header (API).
4. Status lookups read through the same repository by reference number.

## What is intentionally not here

- No authentication/authorization wiring: this demo has no user accounts,
  and inventing an auth story would imply real-user data handling.
  A production version would add ASP.NET Core Identity / OIDC and RBAC
  (both on the author's resume) behind the same service layer.
- No distributed cache, message queue, or microservice split: the demo
  is one deployable web app. Those patterns are on the resume (Kafka,
  Azure Service Bus patterns) but would be complexity without a
  requirement in a single-portal demo.
- No front-end framework in the running app: see the README's
  "deliberate non-choices" section.

## Diagram (text form — renderable in any README viewer)

```
┌─────────────┐     HTTP      ┌──────────────────────────┐
│   Browser   │ ◄────────────► │  IowaPortal.Web          │
│ (HTML/CSS/  │                │  Controllers, Middleware,│
│  JS, Sass)  │                │  Razor Views, Design Sys │
└─────────────┘                └────────────┬─────────────┘
                                            │ DI
                                   ┌────────▼─────────────┐
                                   │ IowaPortal.Application│
                                   │ Validator, Eligibility│
                                   │ Service, DTOs         │
                                   └────────┬─────────────┘
                                            │ interfaces
                                   ┌────────▼─────────────┐
                                   │ Infrastructure        │
                                   │ EF Repositories, Seed │
                                   │ ADO.NET example       │
                                   └────────┬─────────────┘
                                            │
                              ┌─────────────┴──────────────┐
                              │ InMemory (demo)            │
                              │ SQL Server (configured)    │
                              └────────────────────────────┘
```
