CREATE PROCEDURE [HR].[usp_InsertEmployee]
(
    @FirstName     NVARCHAR(100),
    @LastName      NVARCHAR(100),
    @Email         NVARCHAR(200),
    @Phone         NVARCHAR(20),
    @DepartmentID  INT,
    @DesignationID INT,
    @DateOfJoining DATE,
    @Salary        DECIMAL(18,2),
    @NewEmployeeID INT           OUTPUT,
    @ResultMessage NVARCHAR(500) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF HR.fn_IsEmailDuplicate(@Email, 0) = 1
        BEGIN
            SET @NewEmployeeID = -1;
            SET @ResultMessage = 'ERROR: Email already exists.';
            ROLLBACK TRANSACTION; RETURN;
        END
        INSERT INTO HR.Employees
            (FirstName,LastName,Email,Phone,DepartmentID,DesignationID,DateOfJoining,Salary)
        VALUES
            (@FirstName,@LastName,@Email,@Phone,@DepartmentID,@DesignationID,@DateOfJoining,@Salary);
        SET @NewEmployeeID = SCOPE_IDENTITY();
        INSERT INTO HR.EmployeeTimings (EmployeeID) VALUES (@NewEmployeeID);
        INSERT INTO HR.BackgroundVerifications (EmployeeID,VerificationStatus)
        VALUES (@NewEmployeeID,'Pending');
        SET @ResultMessage = 'Employee created successfully.';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @NewEmployeeID = -1;
        SET @ResultMessage = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE [HR].[usp_GetEmployeesPaged]
(
    @PageNumber INT           = 1,
    @PageSize   INT           = 20,
    @SearchTerm NVARCHAR(200) = NULL,
    @DeptFilter INT           = NULL,
    @TotalCount INT           OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @SearchTerm = LTRIM(RTRIM(@SearchTerm));
    IF @SearchTerm = '' SET @SearchTerm = NULL;
    SELECT @TotalCount = COUNT(*)
    FROM HR.vw_ActiveEmployees
    WHERE
        (@SearchTerm IS NULL
         OR FirstName    LIKE '%' + @SearchTerm + '%'
         OR LastName     LIKE '%' + @SearchTerm + '%'
         OR Email        LIKE '%' + @SearchTerm + '%'
         OR EmployeeCode LIKE '%' + @SearchTerm + '%')
        AND (@DeptFilter IS NULL OR DepartmentID = @DeptFilter);
    SELECT
        EmployeeID, EmployeeCode, FirstName, LastName, FullName,
        Email, Phone, DepartmentID, DepartmentName,
        DesignationID, DesignationTitle, Grade,
        IsVerified, DateOfJoining, Salary, VerificationStatus,
        CreatedAt, UpdatedAt
    FROM HR.vw_ActiveEmployees
    WHERE
        (@SearchTerm IS NULL
         OR FirstName    LIKE '%' + @SearchTerm + '%'
         OR LastName     LIKE '%' + @SearchTerm + '%'
         OR Email        LIKE '%' + @SearchTerm + '%'
         OR EmployeeCode LIKE '%' + @SearchTerm + '%')
        AND (@DeptFilter IS NULL OR DepartmentID = @DeptFilter)
    ORDER BY EmployeeID
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

CREATE PROCEDURE [HR].[usp_GetEmployeeByID] (@EmployeeID INT)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM HR.vw_EmployeeFullDetails  WHERE EmployeeID = @EmployeeID;
    SELECT * FROM HR.vw_EmployeeLocations    WHERE EmployeeID = @EmployeeID;
    SELECT TOP 20 LogID,Action,OldData,NewData,ChangedBy,ChangedAt
    FROM Audit.EmployeeAuditLog
    WHERE EmployeeID = @EmployeeID ORDER BY ChangedAt DESC;
END;
GO

CREATE PROCEDURE [HR].[usp_UpdateEmployee]
(
    @EmployeeID    INT,
    @FirstName     NVARCHAR(100),
    @LastName      NVARCHAR(100),
    @Phone         NVARCHAR(20),
    @DepartmentID  INT,
    @DesignationID INT,
    @Salary        DECIMAL(18,2),
    @UpdatedBy     NVARCHAR(200)  = 'System',
    @ResultMessage NVARCHAR(500)  OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM HR.Employees WHERE EmployeeID=@EmployeeID AND IsActive=1)
        BEGIN
            SET @ResultMessage = 'ERROR: Employee not found.';
            ROLLBACK TRANSACTION; RETURN;
        END
        INSERT INTO Jobs.BulkUpdateQueue (EmployeeID,FieldName,OldValue,NewValue)
        SELECT @EmployeeID,'Salary',CAST(Salary AS NVARCHAR(50)),CAST(@Salary AS NVARCHAR(50))
        FROM HR.Employees WHERE EmployeeID=@EmployeeID AND Salary<>@Salary;
        UPDATE HR.Employees
        SET FirstName=@FirstName,LastName=@LastName,Phone=@Phone,
            DepartmentID=@DepartmentID,DesignationID=@DesignationID,
            Salary=@Salary,UpdatedAt=GETUTCDATE()
        WHERE EmployeeID=@EmployeeID;
        SET @ResultMessage = 'Employee updated successfully.';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @ResultMessage = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE [HR].[usp_DeleteEmployee]
(
    @EmployeeID    INT,
    @DeletedBy     NVARCHAR(200),
    @ResultMessage NVARCHAR(500) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM HR.Employees WHERE EmployeeID=@EmployeeID AND IsActive=1)
        BEGIN
            SET @ResultMessage = 'ERROR: Employee not found or already deleted.';
            ROLLBACK TRANSACTION; RETURN;
        END
        UPDATE HR.Employees SET IsActive=0,UpdatedAt=GETUTCDATE() WHERE EmployeeID=@EmployeeID;
        SET @ResultMessage = 'Employee deleted successfully.';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @ResultMessage = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE [HR].[usp_RunBackgroundVerification] (@ProcessedCount INT OUTPUT)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE HR.BackgroundVerifications
        SET VerificationStatus='Passed',VerifiedDate=GETUTCDATE(),
            VerifiedBy='System-AutoJob',UpdatedAt=GETUTCDATE()
        WHERE VerificationStatus='Pending';
        SET @ProcessedCount = @@ROWCOUNT;
        UPDATE e SET e.IsVerified=1,e.VerificationStatus=bv.VerificationStatus,e.UpdatedAt=GETUTCDATE()
        FROM HR.Employees e
        INNER JOIN HR.BackgroundVerifications bv ON e.EmployeeID=bv.EmployeeID
        WHERE bv.VerificationStatus='Passed' AND e.IsVerified=0;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @ProcessedCount = 0;
    END CATCH
END;
GO

-- ⚠️ INTENTIONAL PROBLEM 6: Procedure in repo but NOT deployed
-- Analyzer should flag: MISSING IN PHYSICAL DB
CREATE PROCEDURE [HR].[usp_GetDepartmentHeadcount]
(
    @DepartmentID  INT = NULL,
    @IncludeInactive BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        d.DepartmentID,
        d.DepartmentName,
        COUNT(e.EmployeeID) AS HeadCount,
        SUM(e.Salary)       AS TotalSalary,
        AVG(e.Salary)       AS AvgSalary
    FROM HR.Departments d
    LEFT JOIN HR.Employees e
        ON d.DepartmentID = e.DepartmentID
        AND (@IncludeInactive = 1 OR e.IsActive = 1)
    WHERE (@DepartmentID IS NULL OR d.DepartmentID = @DepartmentID)
    GROUP BY d.DepartmentID, d.DepartmentName
    ORDER BY HeadCount DESC;
END;
GO
