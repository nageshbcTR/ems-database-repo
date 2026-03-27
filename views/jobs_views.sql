CREATE VIEW [Jobs].[vw_BulkUpdatePending]
AS
SELECT
    q.QueueID,
    q.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.EmployeeCode,
    q.FieldName,
    q.OldValue,
    q.NewValue,
    q.Status,
    q.QueuedAt,
    q.ProcessedAt
FROM Jobs.BulkUpdateQueue q
INNER JOIN HR.Employees   e ON q.EmployeeID = e.EmployeeID;
GO
