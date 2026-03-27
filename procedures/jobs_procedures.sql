CREATE PROCEDURE [Jobs].[usp_ProcessBulkUpdateQueue] (@ProcessedCount INT OUTPUT)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE Jobs.BulkUpdateQueue SET Status='Processing' WHERE Status='Pending';
        SET @ProcessedCount = @@ROWCOUNT;
        UPDATE e SET e.Salary=TRY_CAST(q.NewValue AS DECIMAL(18,2)),e.UpdatedAt=GETUTCDATE()
        FROM HR.Employees e
        INNER JOIN Jobs.BulkUpdateQueue q ON e.EmployeeID=q.EmployeeID
        WHERE q.Status='Processing' AND q.FieldName='Salary'
          AND TRY_CAST(q.NewValue AS DECIMAL(18,2)) IS NOT NULL;
        UPDATE Jobs.BulkUpdateQueue
        SET Status='Processed',ProcessedAt=GETUTCDATE() WHERE Status='Processing';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        UPDATE Jobs.BulkUpdateQueue
        SET Status='Failed',ErrorMessage=ERROR_MESSAGE() WHERE Status='Processing';
        SET @ProcessedCount = 0;
    END CATCH
END;
GO
