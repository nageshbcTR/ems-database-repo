CREATE VIEW [Audit].[vw_AuditSummary]
AS
SELECT
    a.LogID,
    a.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.EmployeeCode,
    a.TableName,
    a.Action,
    a.OldData,
    a.NewData,
    a.ChangedBy,
    a.ChangedAt
FROM Audit.EmployeeAuditLog a
LEFT JOIN HR.Employees      e ON a.EmployeeID = e.EmployeeID;
GO
