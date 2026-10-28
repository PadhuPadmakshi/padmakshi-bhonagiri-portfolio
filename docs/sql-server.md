# SQL Server integration

## How this demo connects

- **Default (zero setup):** EF Core InMemory provider. Submissions live
  only while the app runs. This is a demo convenience, not a production
  choice.
- **SQL Server:** set `"UseSqlServer": true` in configuration and supply
  `ConnectionStrings:PortalDb` from an environment variable or Azure Key
  Vault (see `docs/security.md`). `Program.cs` switches providers on
  that flag; no controller or service code changes.
- **Migrations (SQL Server only):** `dotnet ef migrations add Initial`
  then `dotnet ef database update`, run from `src/IowaPortal.Web`
  (EF Design package is already referenced). InMemory does not use
  migrations.

## Schema (see `samples/sql/01-create-tables.sql`)

`BenefitApplications` with a unique index on `ReferenceNumber`,
`ServicePrograms` seeded with the four fictional programs. Income is
`decimal(12,2)`; names are length-limited to match validation.

## Two data-access patterns, both shown

1. **EF Core + repository pattern** (`Infrastructure/Repositories.cs`):
   the pattern used by the running app. Callers depend on
   `IApplicationRepository`, not on EF, so the provider can change.
2. **Parameterized ADO.NET** (`Infrastructure/AdoNetExample.cs`):
   `SqlCommand` with `SqlParameter`. This is the pattern to use when a
   stored procedure or a hand-tuned query is justified.

## The injection rule, stated once and enforced by review

Never concatenate user input into SQL. The vulnerable form:

```sql
-- NEVER DO THIS:
SELECT * FROM BenefitApplications WHERE ReferenceNumber = '<user input>'
```

The correct form is always a parameter (`@ReferenceNumber`), whether
through EF Core (which parameterizes by default) or ADO.NET
(`command.Parameters.Add(...)`). The sample stored-procedure script in
`samples/sql/` uses a parameter for the same reason.
