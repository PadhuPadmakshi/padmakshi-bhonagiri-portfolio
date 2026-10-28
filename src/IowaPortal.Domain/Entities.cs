// IowaPortal.Domain — pure domain types. No ASP.NET, no EF, no I/O here,
// so the rules below can be unit-tested without a database or web server.
namespace IowaPortal.Domain;

/// <summary>Status shown to an applicant. The UI never relies on colour alone:
/// every status is rendered as text plus an icon (see Views).</summary>
public enum ApplicationStatus
{
    Received,
    UnderReview,
    MoreInformationNeeded,
    Approved,
    NotApproved
}

/// <summary>
/// Fictional sample programs. These names are deliberately generic and the
/// data is invented for this demonstration. This is NOT a real State of Iowa
/// portal and confers no real benefit.
/// </summary>
public enum SampleProgram
{
    FoodAssistanceSample,
    HealthCoverageSample,
    ChildCareAssistanceSample,
    HomeEnergyAssistanceSample
}

public sealed class ServiceProgram
{
    public int Id { get; set; }
    public SampleProgram Program { get; set; }
    public required string Name { get; set; }
    public required string ShortDescription { get; set; }
    public required string WhoItHelps { get; set; }
    public required string HowToApply { get; set; }
    public string ContactNote { get; set; } = "Sample contact information only — see the README disclaimer.";
}

public sealed class BenefitApplication
{
    public int Id { get; set; }

    /// <summary>Public reference the applicant uses on the Status page, e.g. IA-2026-0042.</summary>
    public required string ReferenceNumber { get; set; }

    public SampleProgram Program { get; set; }

    // Demo-only fields. A production system would never store a full SSN or
    // date of birth in plain text in this table — see docs/security.md.
    // This demo collects NO SSN and NO date of birth at all, by design.
    public required string FirstName { get; set; }
    public required string LastName { get; set; }
    public required string Email { get; set; }
    public required string County { get; set; }
    public int HouseholdSize { get; set; }
    public decimal MonthlyHouseholdIncome { get; set; }
    public bool AgreesToSampleTerms { get; set; }
    public string? AdditionalNotes { get; set; }

    public ApplicationStatus Status { get; set; } = ApplicationStatus.Received;
    public DateTimeOffset SubmittedAtUtc { get; set; } = DateTimeOffset.UtcNow;
    public string? ReviewNote { get; set; }
}
