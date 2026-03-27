CREATE TABLE [HR].[Departments]
(
    [DepartmentID]   [int]           IDENTITY(1,1) NOT NULL,
    [DepartmentName] [nvarchar](150) NOT NULL,
    [ManagerID]      [int]           NULL,
    [IsActive]       [bit]           NOT NULL DEFAULT ((1)),
    [CreatedAt]      [datetime2](7)  NOT NULL DEFAULT (getutcdate()),
    [UpdatedAt]      [datetime2](7)  NOT NULL DEFAULT (getutcdate()),
    CONSTRAINT [PK_Departments]    PRIMARY KEY CLUSTERED ([DepartmentID] ASC),
    CONSTRAINT [UQ_DepartmentName] UNIQUE NONCLUSTERED ([DepartmentName] ASC),
    CONSTRAINT [CHK_DeptName]      CHECK (LEN(LTRIM(RTRIM([DepartmentName]))) > 0)
);
GO
