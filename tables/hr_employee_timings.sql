CREATE TABLE [HR].[EmployeeTimings]
(
    [TimingID]   [int]           IDENTITY(1,1) NOT NULL,
    [EmployeeID] [int]           NOT NULL,
    [ShiftStart] [time](7)       NOT NULL DEFAULT ('09:00:00'),
    [ShiftEnd]   [time](7)       NOT NULL DEFAULT ('18:00:00'),
    [ShiftType]  [nvarchar](50)  NOT NULL DEFAULT ('General'),
    [UpdatedAt]  [datetime2](7)  NOT NULL DEFAULT (getutcdate()),
    CONSTRAINT [PK_EmployeeTimings] PRIMARY KEY CLUSTERED ([TimingID] ASC),
    CONSTRAINT [UQ_EmpTiming]       UNIQUE NONCLUSTERED ([EmployeeID] ASC),
    CONSTRAINT [CHK_ShiftType]      CHECK
    (
        [ShiftType] IN ('General','Morning','Night','Rotational')
    ),
    CONSTRAINT [FK_Timing_Emp] FOREIGN KEY ([EmployeeID])
        REFERENCES [HR].[Employees]([EmployeeID])
);
GO
