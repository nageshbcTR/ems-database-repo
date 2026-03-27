CREATE TABLE [HR].[Designations]
(
    [DesignationID] [int]           IDENTITY(1,1) NOT NULL,
    [Title]         [nvarchar](150) NOT NULL,
    [Grade]         [nvarchar](10)  NOT NULL,
    [IsActive]      [bit]           NOT NULL DEFAULT ((1)),
    CONSTRAINT [PK_Designations]    PRIMARY KEY CLUSTERED ([DesignationID] ASC),
    CONSTRAINT [UQ_DesignationTitle] UNIQUE NONCLUSTERED ([Title] ASC),
    CONSTRAINT [CHK_Grade] CHECK
    (
        [Grade] IN ('L1','L2','L3','L4','L5','L6','L7')
    )
);
GO
