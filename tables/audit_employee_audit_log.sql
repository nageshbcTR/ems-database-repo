CREATE TABLE [Audit].[EmployeeAuditLog]
(
    [LogID]      [bigint]        IDENTITY(1,1) NOT NULL,
    [EmployeeID] [int]           NULL,
    [TableName]  [nvarchar](100) NOT NULL,
    [Action]     [nvarchar](10)  NOT NULL,
    [OldData]    [nvarchar](max) NULL,
    [NewData]    [nvarchar](max) NULL,
    [ChangedBy]  [nvarchar](200) NOT NULL DEFAULT (SUSER_SNAME()),
    [ChangedAt]  [datetime2](7)  NOT NULL DEFAULT (getutcdate()),
    CONSTRAINT [PK_AuditLog]  PRIMARY KEY CLUSTERED ([LogID] ASC),
    CONSTRAINT [CHK_Action]   CHECK ([Action] IN ('INSERT','UPDATE','DELETE')),
    CONSTRAINT [FK_Audit_Emp] FOREIGN KEY ([EmployeeID])
        REFERENCES [HR].[Employees]([EmployeeID])
);
GO
