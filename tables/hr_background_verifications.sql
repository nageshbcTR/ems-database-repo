CREATE TABLE [HR].[BackgroundVerifications]
(
    [VerificationID]     [int]            IDENTITY(1,1) NOT NULL,
    [EmployeeID]         [int]            NOT NULL,
    [VerificationStatus] [nvarchar](20)   NOT NULL DEFAULT ('Pending'),
    [VerifiedDate]       [datetime2](7)   NULL,
    [Remarks]            [nvarchar](1000) NULL,
    [VerifiedBy]         [nvarchar](200)  NULL,
    [CreatedAt]          [datetime2](7)   NOT NULL DEFAULT (getutcdate()),
    [UpdatedAt]          [datetime2](7)   NOT NULL DEFAULT (getutcdate()),
    CONSTRAINT [PK_BackgroundVerifications] PRIMARY KEY CLUSTERED ([VerificationID] ASC),
    CONSTRAINT [CHK_VerifStatus] CHECK
    (
        [VerificationStatus] IN ('Pending','InProgress','Passed','Failed')
    ),
    CONSTRAINT [FK_BV_Emp] FOREIGN KEY ([EmployeeID])
        REFERENCES [HR].[Employees]([EmployeeID])
);
GO
