# Secure configuration, secrets, and sensitive data

## What this demo deliberately does NOT collect

No Social Security number, no date of birth, no bank or payment details,
no health information, and no real personal information of any kind.
The Apply form asks only for a sample name, sample email, county,
household size, and a sample income figure — and the banner on every
page tells users not to enter real information. If a real version of
this system existed, those fields would be a separate, reviewed design
decision with encryption, access control, and retention rules — not an
extension of this demo.

## Secrets: never in source

- No secret, password, connection string, or API key is committed in
  this repository. `appsettings.json` contains no connection string
  with credentials; the SQL Server connection string is expected from
  an environment variable (`ConnectionStrings__PortalDb`) or Azure Key
  Vault in a real deployment.
- The Azure pipeline uses pipeline variables / variable groups for any
  deployment credential. Reviewers should reject any PR that adds a
  secret to source, even a "test" one — test secrets become real secrets
  once they are in Git history.
- Local development uses `appsettings.Development.json` and user
  secrets (`dotnet user-secrets`) for anything sensitive, never a
  committed file.

## Encryption and transport

- The app runs behind HTTPS in any real deployment (HSTS is enabled
  outside Development; `UseHttpsRedirection` is the template default
  and is retained in spirit — see `Program.cs` notes). The local demo
  uses the ASP.NET Core development certificate / plain HTTP on
  localhost, which is appropriate for localhost only.
- At rest, a production SQL Server database would use Transparent Data
  Encryption (TDE) and column-level encryption for any sensitive field;
  this demo stores only fictional sample data in InMemory storage, so
  TDE is a deployment requirement, not something this code demonstrates.
- The security-headers middleware sets `nosniff`, `DENY` framing,
  strict referrer policy, and a same-origin Content-Security-Policy.
  Anti-forgery tokens (`ValidateAntiForgeryToken`) protect all POST
  forms. Server validation is authoritative; client-side checks are a
  convenience only.

## No government authorization is claimed

This demonstration has no FedRAMP, State of Iowa, or other government
security authorization, has not undergone a security review, and must
not be presented as an authorized government system. A production
deployment would require the owning agency's authorization process,
threat modelling, penetration testing, and audit logging — none of which
this portfolio pretends to provide.

## Future AWS note (not implemented)

The job description mentions AWS as a future direction. A future
deployment could host this ASP.NET Core app on AWS (e.g. ECS/Fargate
behind an ALB, RDS for SQL Server, Secrets Manager for configuration)
without changing application code, because configuration is
environment-based and data access is provider-abstracted. No AWS
resources, SDK calls, or credentials are included in this demo, because
adding them would be cloud complexity without a requirement behind it.
