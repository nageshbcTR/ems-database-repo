CREATE FUNCTION [HR].[fn_GetEmployeesByDept] (@DepartmentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        e.EmployeeID,
        e.EmployeeCode,
        e.FirstName + ' ' + e.LastName        AS FullName,
        e.Email,
        e.Salary,
        HR.fn_GetYearsOfService(e.EmployeeID) AS YearsOfService,
        des.Title   AS Designation,
        des.Grade
    FROM HR.Employees       e
    INNER JOIN HR.Designations des ON e.DesignationID = des.DesignationID
    WHERE e.DepartmentID = @DepartmentID AND e.IsActive = 1
);
GO
