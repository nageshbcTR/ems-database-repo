CREATE TABLE [HR].[Employees]
(
    [EmployeeID]         [int]            IDENTITY(1,1) NOT NULL,
    [EmployeeCode]       AS (CONVERT([nvarchar](10),
                            'EMP' + RIGHT('00000' + CONVERT([varchar](5),[EmployeeID]),(5))))
                         PERSISTED,
    [FirstName]          [nvarchar](100)  NOT NULL,
    [LastName]           [nvarchar](100)  NOT NULL,
    [Email]              [nvarchar](200)  NOT NULL,
    [Phone]              [nvarchar](20)   NOT NULL,
    [DepartmentID]       [int]            NOT NULL,
    [DesignationID]      [int]            NOT NULL,
    [DateOfJoining]      [date]           NOT NULL,
    [Salary]             [decimal](18, 2) NOT NULL DEFAULT ((0.00)),
    [IsActive]           [bit]            NOT NULL DEFAULT ((1)),
    [IsVerified]         [bit]            NOT NULL DEFAULT ((0)),
    [CreatedAt]          [datetime2](7)   NOT NULL DEFAULT (getutcdate()),
    [UpdatedAt]          [datetime2](7)   NOT NULL DEFAULT (getutcdate()),
    [RowVer]             [timestamp]      NOT NULL,
    [VerificationStatus] [nvarchar](50)   NULL,
    CONSTRAINT [PK_Employees]      PRIMARY KEY CLUSTERED ([EmployeeID] ASC),
    CONSTRAINT [UQ_Employee_Email] UNIQUE NONCLUSTERED ([Email] ASC),
    CONSTRAINT [CHK_Email_Format]  CHECK ([Email] LIKE '%_@_%.__%'),
    CONSTRAINT [CHK_Phone_Length]  CHECK (LEN([Phone]) >= 7),
    CONSTRAINT [CHK_Salary]        CHECK ([Salary] >= 0),
    CONSTRAINT [FK_Emp_Dept]       FOREIGN KEY ([DepartmentID])
        REFERENCES [HR].[Departments]([DepartmentID]),
    CONSTRAINT [FK_Emp_Desig]      FOREIGN KEY ([DesignationID])
        REFERENCES [HR].[Designations]([DesignationID])
);
GO
