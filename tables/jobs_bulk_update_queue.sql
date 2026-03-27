CREATE TABLE [Jobs].[BulkUpdateQueue]
(
    [QueueID]      [bigint]         IDENTITY(1,1) NOT NULL,
    [EmployeeID]   [int]            NOT NULL,
    [FieldName]    [nvarchar](100)  NOT NULL,
    [OldValue]     [nvarchar](500)  NULL,
    [NewValue]     [nvarchar](500)  NOT NULL,
    [Status]       [nvarchar](20)   NOT NULL DEFAULT ('Pending'),
    [QueuedAt]     [datetime2](7)   NOT NULL DEFAULT (getutcdate()),
    [ProcessedAt]  [datetime2](7)   NULL,
    [ErrorMessage] [nvarchar](1000) NULL,
    CONSTRAINT [PK_BulkUpdateQueue] PRIMARY KEY CLUSTERED ([QueueID] ASC),
    CONSTRAINT [CHK_QueueStatus]    CHECK
    (
        [Status] IN ('Pending','Processing','Processed','Failed')
    )
);
GO
