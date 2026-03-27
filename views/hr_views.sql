CREATE VIEW [HR].[vw_ActiveEmployees]
WITH SCHEMABINDING
AS
SELECT
    e.EmployeeID,
    e.EmployeeCode,
    e.FirstName,
    e.LastName,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.Email,
    e.Phone,
    e.DepartmentID,
    d.DepartmentName,
    e.DesignationID,
    des.Title   AS DesignationTitle,
    des.Grade,
    e.DateOfJoining,
    e.Salary,
    e.IsActive,
    e.IsVerified,
    CASE
        WHEN e.IsVerified = 1              THEN 'Passed'
        WHEN e.VerificationStatus = 'Failed'     THEN 'Failed'
        WHEN e.VerificationStatus = 'InProgress' THEN 'InProgress'
        ELSE 'Pending'
    END AS VerificationStatus,
    e.CreatedAt,
    e.UpdatedAt
FROM HR.Employees e
INNER JOIN HR.Departments  d   ON e.DepartmentID  = d.DepartmentID
INNER JOIN HR.Designations des ON e.DesignationID = des.DesignationID
WHERE e.IsActive = 1;
GO

CREATE VIEW [HR].[vw_EmployeeFullDetails]
AS
SELECT
    e.EmployeeID,
    e.EmployeeCode,
    e.FirstName,
    e.LastName,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.Email,
    e.Phone,
    e.DepartmentID,
    e.DesignationID,
    d.DepartmentName,
    des.Title       AS DesignationTitle,
    des.Grade,
    e.DateOfJoining,
    e.Salary,
    e.IsVerified,
    e.IsActive,
    e.CreatedAt,
    bv.VerificationStatus,
    bv.VerifiedDate,
    bv.Remarks      AS VerificationRemarks,
    et.ShiftStart,
    et.ShiftEnd,
    et.ShiftType,
    DATEDIFF(YEAR, e.DateOfJoining, GETDATE()) AS YearsOfService
FROM HR.Employees                    e
LEFT JOIN HR.Departments             d   ON e.DepartmentID  = d.DepartmentID
LEFT JOIN HR.Designations            des ON e.DesignationID = des.DesignationID
LEFT JOIN HR.BackgroundVerifications bv  ON e.EmployeeID    = bv.EmployeeID
LEFT JOIN HR.EmployeeTimings         et  ON e.EmployeeID    = et.EmployeeID;
GO

CREATE VIEW [HR].[vw_PendingVerifications]
AS
SELECT
    e.EmployeeID,
    e.EmployeeCode,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.Email,
    d.DepartmentName,
    bv.VerificationStatus,
    bv.CreatedAt AS RequestedDate,
    DATEDIFF(DAY, bv.CreatedAt, GETDATE()) AS DaysPending
FROM HR.Employees                    e
INNER JOIN HR.BackgroundVerifications bv ON e.EmployeeID  = bv.EmployeeID
INNER JOIN HR.Departments             d  ON e.DepartmentID = d.DepartmentID
WHERE bv.VerificationStatus IN ('Pending','InProgress')
  AND e.IsActive = 1;
GO

CREATE VIEW [HR].[vw_EmployeeLocations]
AS
SELECT
    l.LocationID,
    l.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.EmployeeCode,
    l.AddressLine1,
    l.AddressLine2,
    l.City,
    l.State,
    l.Country,
    l.PostalCode,
    l.IsPrimary,
    l.IsActive,
    l.CreatedAt
FROM HR.EmployeeLocations l
INNER JOIN HR.Employees   e ON l.EmployeeID = e.EmployeeID
WHERE l.IsActive = 1;
GO

-- ⚠️ INTENTIONAL PROBLEM 5: View in repo but NOT deployed
-- Analyzer should flag: MISSING IN PHYSICAL DB
CREATE VIEW [HR].[vw_SalaryBands]
AS
SELECT
    des.Grade,
    des.Title       AS Designation,
    MIN(e.Salary)   AS MinSalary,
    MAX(e.Salary)   AS MaxSalary,
    AVG(e.Salary)   AS AvgSalary,
    COUNT(*)        AS HeadCount
FROM HR.Employees   e
JOIN HR.Designations des ON e.DesignationID = des.DesignationID
WHERE e.IsActive = 1
GROUP BY des.Grade, des.Title;
GO
