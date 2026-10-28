-- SQL Server schema for the Iowa Portal demo. Fictional sample data only.
-- Run against an empty database. In the demo, EF Core creates this shape
-- from PortalDbContext; this script is the reviewable, DBA-friendly form.
CREATE TABLE dbo.ServicePrograms (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Program INT NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    ShortDescription NVARCHAR(1000) NOT NULL,
    WhoItHelps NVARCHAR(1000) NOT NULL,
    HowToApply NVARCHAR(1000) NOT NULL,
    ContactNote NVARCHAR(500) NOT NULL DEFAULT 'Sample contact information only.'
);
GO

CREATE TABLE dbo.BenefitApplications (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ReferenceNumber NVARCHAR(20) NOT NULL,
    Program INT NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(254) NOT NULL,
    County NVARCHAR(100) NOT NULL,
    HouseholdSize INT NOT NULL CHECK (HouseholdSize BETWEEN 1 AND 20),
    MonthlyHouseholdIncome DECIMAL(12,2) NOT NULL CHECK (MonthlyHouseholdIncome >= 0),
    AdditionalNotes NVARCHAR(500) NULL,
    AgreesToSampleTerms BIT NOT NULL,
    Status INT NOT NULL DEFAULT 0,
    SubmittedAtUtc DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    ReviewNote NVARCHAR(1000) NULL
);
GO

CREATE UNIQUE INDEX IX_BenefitApplications_ReferenceNumber
    ON dbo.BenefitApplications (ReferenceNumber);
GO
