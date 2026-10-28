# Legacy maintenance and modernization: WebForms → ASP.NET Core

## When legacy maintenance is the right call

Maintain a WebForms application in place when: it is stable and
business-critical, the change is small and well-isolated, the team
cannot yet fund a rewrite, or the page depends on a control with no
Core equivalent and no budget to rebuild it. Modernize when: the app
needs new accessibility behaviour WebForms controls fight against,
security or framework support is ending, performance or testability
blocks delivery, or — as in this portfolio's scenario — the organization
is standardizing on modern practices and the page is being actively
enhanced anyway.

The author's Iowa-tailored resume shows both sides of this judgment:
.NET 6 → .NET 8 at Centene (Member Self-Service Portal Modernization),
.NET Core 3.1 → .NET 6 at Frontiers (Author and Reviewer Submission
Platform), and bringing Web Forms pages up to Section 508 and WCAG 2.1 AA
at the State of New Jersey Department of Labor & Workforce Development
(Unemployment Insurance Claimant Services Modernization), while also
maintaining WebForms applications at Tradelab and New Jersey. Modernization here means moving business logic out of
code-behind into testable services — not just changing the UI framework.

## WebForms vs. modern ASP.NET Core MVC — the differences that matter

| Concern | WebForms (legacy) | ASP.NET Core MVC (this project) |
|---|---|---|
| Page model | Event-driven, postback, ViewState round-trips the page state | Request/response, explicit GET/POST, no ViewState |
| Testability | Code-behind is tightly coupled to page lifecycle; hard to unit-test | Controllers are thin; rules live in Application services, unit-tested with xUnit |
| HTML control | Server controls render their own markup; accessible markup often requires fighting the control | Razor gives full control of semantic HTML, labels, ARIA |
| State | ViewState + Session by default (large payloads, stale-state bugs) | Explicit, minimal state; reference numbers instead of session blobs |
| Routing | File-based `.aspx` URLs | Attribute/conventional routing, clean REST URLs |
| Dependency injection | Bolted on, awkward | First-class in `Program.cs` |

## The sample: what it shows, and what is wrong with it on purpose

`samples/legacy/BenefitApplication.aspx` + `.aspx.cs` is a
representative WebForms page: a dropdown, textboxes, a submit button,
ViewState, and business logic inline in the click handler. It is
**not** compiled into the solution — WebForms does not run on .NET 8 —
and that is the point: it is reviewable evidence of legacy fluency,
not a runtime dependency.

Its deliberate flaws, and the modern fixes already in this project:

1. **Business logic in the click handler** → moved to
   `ApplicationService` + `ApplicationValidator`, tested without a page.
2. **No server-side validation visible, no error summary** → field-keyed
   validation with an accessible error summary (Apply page).
3. **ViewState carrying form state** → stateless POST + redirect to a
   confirmation page keyed by reference number (Post/Redirect/Get).
4. **Control-rendered markup with no label association** → explicit
   `<label for>` in Razor.

## A safe modernization sequence (strangler, not big-bang)

1. Extract business logic from code-behind into a service class that
   both the old page and a new API can call.
2. Put the service under test before changing any behaviour.
3. Build the new page/API alongside the old one; route one workflow
   at a time.
4. Retire the old page only when its workflow's tests and accessibility
   checklist pass on the new implementation.
5. Keep the old page running untouched for workflows not yet migrated —
   a half-migrated system that works beats a half-rewritten system
   that does not.
