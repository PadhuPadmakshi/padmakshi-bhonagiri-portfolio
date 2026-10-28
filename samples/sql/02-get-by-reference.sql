-- Parameterized lookup. NEVER concatenate the reference number into SQL.
-- Usage: EXEC dbo.GetApplicationByReference @ReferenceNumber = N'IA-2026-0001';
CREATE OR ALTER PROCEDURE dbo.GetApplicationByReference
    @ReferenceNumber NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP (1)
        ReferenceNumber, Program, FirstName, LastName, Email, County,
        HouseholdSize, MonthlyHouseholdIncome, Status, SubmittedAtUtc, ReviewNote
    FROM dbo.BenefitApplications
    WHERE ReferenceNumber = @ReferenceNumber;
END;
GO
