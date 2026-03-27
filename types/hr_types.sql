CREATE TYPE [HR].[EmployeeCodeType] FROM [nvarchar](10) NOT NULL;
GO

CREATE TYPE [HR].[EmployeeBulkType] AS TABLE
(
    [FirstName]     [nvarchar](100)  NOT NULL,
    [LastName]      [nvarchar](100)  NOT NULL,
    [Email]         [nvarchar](200)  NOT NULL,
    [Phone]         [nvarchar](20)   NOT NULL,
    [DepartmentID]  [int]            NOT NULL,
    [DesignationID] [int]            NOT NULL,
    [DateOfJoining] [date]           NOT NULL,
    [Salary]        [decimal](18, 2) NOT NULL
);
GO

CREATE TYPE [HR].[LocationBulkType] AS TABLE
(
    [EmployeeID]    [int]            NOT NULL,
    [AddressLine1]  [nvarchar](500)  NOT NULL,
    [AddressLine2]  [nvarchar](500)  NULL,
    [City]          [nvarchar](100)  NOT NULL,
    [State]         [nvarchar](100)  NOT NULL,
    [Country]       [nvarchar](100)  NOT NULL,
    [PostalCode]    [nvarchar](20)   NULL,
    [IsPrimary]     [bit]            NOT NULL DEFAULT ((0))
);
GO

CREATE TYPE [Jobs].[BulkUpdateType] AS TABLE
(
    [EmployeeID]  [int]           NOT NULL,
    [FieldName]   [nvarchar](100) NOT NULL,
    [NewValue]    [nvarchar](500) NOT NULL
);
GO
