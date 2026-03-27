CREATE TABLE [HR].[EmployeeLocations]
(
    [LocationID]   [int]           IDENTITY(1,1) NOT NULL,
    [EmployeeID]   [int]           NOT NULL,
    [AddressLine1] [nvarchar](500) NOT NULL,
    [AddressLine2] [nvarchar](500) NULL,
    [City]         [nvarchar](100) NOT NULL,
    [State]        [nvarchar](100) NOT NULL,
    [Country]      [nvarchar](100) NOT NULL DEFAULT ('India'),
    [PostalCode]   [nvarchar](20)  NULL,
    [IsPrimary]    [bit]           NOT NULL DEFAULT ((0)),
    [IsActive]     [bit]           NOT NULL DEFAULT ((1)),
    [CreatedAt]    [datetime2](7)  NOT NULL DEFAULT (getutcdate()),
    CONSTRAINT [PK_EmployeeLocations] PRIMARY KEY CLUSTERED ([LocationID] ASC),
    CONSTRAINT [FK_Loc_Emp] FOREIGN KEY ([EmployeeID])
        REFERENCES [HR].[Employees]([EmployeeID]) ON DELETE CASCADE
);
GO
