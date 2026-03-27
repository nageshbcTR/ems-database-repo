CREATE TABLE [Audit].[ChangeTracker]
(
    [TrackID]    [bigint]        IDENTITY(1,1) NOT NULL,
    [EmployeeID] [int]           NOT NULL,
    [FieldName]  [nvarchar](100) NOT NULL,
    [OldValue]   [nvarchar](500) NULL,
    [NewValue]   [nvarchar](500) NULL,
    [ChangedAt]  [datetime2](7)  NOT NULL DEFAULT (getutcdate()),
    [ChangedBy]  [nvarchar](200) NOT NULL DEFAULT (SUSER_SNAME()),
    CONSTRAINT [PK_ChangeTracker] PRIMARY KEY CLUSTERED ([TrackID] ASC)
);
GO

-- ⚠️ INTENTIONAL PROBLEM 1:
-- This table is in the repo but will NOT be deployed to physical DB
-- Analyzer should flag: MISSING IN PHYSICAL DB
CREATE TABLE [Audit].[SchemaVersionLog]
(
    [VersionID]   [int]           IDENTITY(1,1) NOT NULL,
    [ScriptName]  [nvarchar](200) NOT NULL,
    [AppliedAt]   [datetime2](7)  NOT NULL DEFAULT (getutcdate()),
    [AppliedBy]   [nvarchar](200) NOT NULL DEFAULT (SUSER_SNAME()),
    CONSTRAINT [PK_SchemaVersionLog] PRIMARY KEY CLUSTERED ([VersionID] ASC)
);
GO
