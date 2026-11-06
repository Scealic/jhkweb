/*=====================================================================
  ROLLBACK - remove the "Deprecate/Delete 1/1/2027" 'Deprecated' property.

  Database  : [VCS Content]   (Content)
  Targets   : 6 stored procedures
  Generated : 2026-10-22

  Removes the 'Deprecated' property only from the procedures listed by the
  matching marking script, and only where its note starts with
  "Deprecate/Delete 1/1/2027". A different 'Deprecated' note (for example
  from the 2026-10-02 set) and other extended properties (MS_Description
  etc.) are left untouched. Safe to re-run.
=====================================================================*/

USE [VCS Content];
GO
SET NOCOUNT ON;
GO

DECLARE @PropertyName sysname = N'Deprecated';
DECLARE @Prefix nvarchar(100) = N'Deprecate/Delete 1/1/2027';

DECLARE @targets TABLE (SchemaName sysname NOT NULL, ObjectName sysname NOT NULL);

INSERT INTO @targets (SchemaName, ObjectName) VALUES
  (N'dbo', N'USP_View_ComponentAndLookups_ReadAll'),
  (N'dbo', N'USP_Table_ConnectorGrouping_ReadWhereIdEqualsParameter'),
  (N'dbo', N'USP_ConnectorMapping_SelectWhereIdEqualsParameter_v20240716'),
  (N'dbo', N'USP_SizeSymbol_SelectWhereTradeIdEqualsParameter_v20240716'),
  (N'dbo', N'USP_View_MaterialAndLookups_ReadWhereEquals'),
  (N'Fabrication', N'USP_Configuration_SelectWhereGuidEquals');

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
                     AND CONVERT(nvarchar(1000), ep.value) LIKE @Prefix + N'%'
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

    PRINT '[VCS Content] Deprecate/Delete 1/1/2027 property removed from ' + CAST(@removed AS varchar(10))
        + ' of 6 procedures.';
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
