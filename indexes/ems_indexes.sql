-- ✅ GOOD: Actively used indexes
CREATE NONCLUSTERED INDEX [IX_Employees_DepartmentID]
    ON [HR].[Employees] ([DepartmentID] ASC)
    INCLUDE ([FirstName],[LastName],[Email],[IsActive]);
GO

CREATE NONCLUSTERED INDEX [IX_Employees_IsActive]
    ON [HR].[Employees] ([IsActive] ASC)
    INCLUDE ([EmployeeID],[FirstName],[LastName],[Email],[DepartmentID],[DesignationID]);
GO

CREATE NONCLUSTERED INDEX [IX_Employees_Email]
    ON [HR].[Employees] ([Email] ASC)
    WHERE ([IsActive] = 1);
GO

CREATE NONCLUSTERED INDEX [IX_Employees_DesignationID]
    ON [HR].[Employees] ([DesignationID] ASC)
    INCLUDE ([FirstName],[LastName],[Salary]);
GO

CREATE NONCLUSTERED INDEX [IX_Employees_DateOfJoining]
    ON [HR].[Employees] ([DateOfJoining] DESC)
    INCLUDE ([EmployeeID],[FirstName],[LastName]);
GO

CREATE NONCLUSTERED INDEX [IX_BV_Status]
    ON [HR].[BackgroundVerifications] ([VerificationStatus] ASC)
    INCLUDE ([EmployeeID],[CreatedAt])
    WHERE ([VerificationStatus] = 'Pending');
GO

CREATE NONCLUSTERED INDEX [IX_Locations_EmployeeID]
    ON [HR].[EmployeeLocations] ([EmployeeID] ASC, [IsActive] ASC)
    INCLUDE ([AddressLine1],[City],[State],[Country],[IsPrimary]);
GO

CREATE NONCLUSTERED INDEX [IX_AuditLog_EmployeeID]
    ON [Audit].[EmployeeAuditLog] ([EmployeeID] ASC, [ChangedAt] DESC);
GO

CREATE NONCLUSTERED INDEX [IX_Queue_Pending]
    ON [Jobs].[BulkUpdateQueue] ([Status] ASC, [QueuedAt] ASC)
    WHERE ([Status] = 'Pending');
GO

-- ⚠️ INTENTIONAL PROBLEM 2: Unused index — analyzer should flag REMOVE
CREATE NONCLUSTERED INDEX [IX_Employees_Phone]
    ON [HR].[Employees] ([Phone] ASC);
GO

-- ⚠️ INTENTIONAL PROBLEM 3: Duplicate leading column — analyzer should flag DUPLICATE
CREATE NONCLUSTERED INDEX [IX_Employees_DeptID_Salary]
    ON [HR].[Employees] ([DepartmentID] ASC, [Salary] DESC);
GO

-- ⚠️ INTENTIONAL PROBLEM 4: Never queried — analyzer should flag REVIEW
CREATE NONCLUSTERED INDEX [IX_ChangeTracker_EmployeeID]
    ON [Audit].[ChangeTracker] ([EmployeeID] ASC, [ChangedAt] DESC);
GO
