CREATE FUNCTION [HR].[fn_GetFullName] (@EmployeeID INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @FullName NVARCHAR(200);
    SELECT @FullName = FirstName + ' ' + LastName
    FROM HR.Employees WHERE EmployeeID = @EmployeeID;
    RETURN ISNULL(@FullName, 'Unknown');
END;
GO

CREATE FUNCTION [HR].[fn_GetYearsOfService] (@EmployeeID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Years INT;
    SELECT @Years = DATEDIFF(YEAR, DateOfJoining, GETDATE())
    FROM HR.Employees WHERE EmployeeID = @EmployeeID;
    RETURN ISNULL(@Years, 0);
END;
GO

CREATE FUNCTION [HR].[fn_GetEmployeeCount] (@DepartmentID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;
    SELECT @Count = COUNT(*) FROM HR.Employees
    WHERE DepartmentID = @DepartmentID AND IsActive = 1;
    RETURN ISNULL(@Count, 0);
END;
GO

CREATE FUNCTION [HR].[fn_IsEmailDuplicate]
(
    @Email        NVARCHAR(200),
    @ExcludeEmpID INT = 0
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;
    IF EXISTS
    (
        SELECT 1 FROM HR.Employees
        WHERE Email = @Email AND EmployeeID <> @ExcludeEmpID
    )
        SET @Result = 1;
    RETURN @Result;
END;
GO
