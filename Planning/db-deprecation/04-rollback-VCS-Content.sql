/*=====================================================================
  ROLLBACK - remove the 'Deprecated' extended property.

  Database  : [VCS Content]   (Content)
  Targets   : 7 stored procedures
  Generated : 2026-10-02

  Removes only the 'Deprecated' property, and only from the procedures
  listed by the matching marking script. Other extended properties
  (MS_Description etc.) are left untouched. Safe to re-run.
=====================================================================*/

USE [VCS Content];
GO
SET NOCOUNT ON;
GO

DECLARE @PropertyName sysname = N'Deprecated';

DECLARE @targets TABLE (SchemaName sysname NOT NULL, ObjectName sysname NOT NULL);

INSERT INTO @targets (SchemaName, ObjectName) VALUES
  (N'dbo', N'usp_MaxLengthOfDataInField'),
  (N'dbo', N'USP_Table_Product_ReadWhereProductCodeEqualsParameter'),
  (N'dbo', N'VCS_Update_Component_UpdateDerivedFields'),
  (N'Fabrication', N'DEVUSP_SupportType_SelectAllAsEnum'),
  (N'Fabrication', N'USP_SupportType_SelectAll_v20250604'),
  (N'Fabrication', N'USP_SupportType_SelectWhereTypeAndConfigurationEquals_v20250604'),
  (N'Fabrication', N'USP_SupportTypeMaterial_SelectWhereSupportTypeIdEquals_v20250603');

DECLARE @s sysname, @o sysname, @removed int = 0;

DECLARE tgt CURSOR LOCAL FAST_FORWARD FOR
    SELECT SchemaName, ObjectName FROM @targets ORDER BY SchemaName, ObjectName;

BEGIN TRY
    BEGIN TRANSACTION;

    OPEN tgt;
    FETCH NEXT FROM tgt INTO @s, @o;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (SELECT 1
                   FROM sys.extended_properties ep
                   JOIN sys.objects o ON o.object_id = ep.major_id
                   WHERE ep.class = 1 AND ep.minor_id = 0
                     AND ep.name = @PropertyName
                     AND o.name = @o
                     AND SCHEMA_NAME(o.schema_id) = @s)
        BEGIN
            EXEC sys.sp_dropextendedproperty
                 @name = @PropertyName,
                 @level0type = N'SCHEMA',    @level0name = @s,
                 @level1type = N'PROCEDURE', @level1name = @o;
            SET @removed += 1;
        END

        FETCH NEXT FROM tgt INTO @s, @o;
    END

    CLOSE tgt;
    DEALLOCATE tgt;

    COMMIT TRANSACTION;

    PRINT '[VCS Content] Deprecated property removed from ' + CAST(@removed AS varchar(10))
        + ' of 7 procedures.';
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('local', 'tgt') >= 0
    BEGIN
        CLOSE tgt;
        DEALLOCATE tgt;
    END
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH
GO
