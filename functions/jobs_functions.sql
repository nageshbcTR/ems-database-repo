CREATE FUNCTION [Jobs].[fn_GetPendingQueueByEmployee] (@EmployeeID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT QueueID, FieldName, OldValue, NewValue, QueuedAt
    FROM Jobs.BulkUpdateQueue
    WHERE EmployeeID = @EmployeeID AND Status = 'Pending'
);
GO
