CREATE FUNCTION [Audit].[fn_GetEmployeeAuditTrail]
(
    @EmployeeID INT,
    @TopN       INT = 20
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP (@TopN)
        LogID, Action, OldData, NewData, ChangedBy, ChangedAt
    FROM Audit.EmployeeAuditLog
    WHERE EmployeeID = @EmployeeID
    ORDER BY ChangedAt DESC
);
GO
