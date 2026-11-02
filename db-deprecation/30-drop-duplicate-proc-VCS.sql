/*=====================================================================
  Drop the accidental duplicate procedure [dbo].[dbo.usp_ExportTablesToJson]

  Database  : [VCS]
  Generated : 2026-10-02

  BACKGROUND
    Two procedures exist, both created 2026-06-12:

      [dbo].[usp_ExportTablesToJson]       <- the real one, KEEP
      [dbo].[dbo.usp_ExportTablesToJson]   <- this one, DROP

    The second has a literal dot in its object name, produced by a
    CREATE PROCEDURE [dbo.usp_ExportTablesToJson] quoting mistake. It can
    only be invoked as EXEC [dbo].[dbo.usp_ExportTablesToJson], which no
    code does. Kelly-Windows calls the correctly-named one.

  THIS IS DESTRUCTIVE AND NOT TRANSACTIONALLY REVERSIBLE ONCE COMMITTED.
    Recovery source:
      VCS-Database-General-Schema/project/dbo/Stored Procedures/dbo.usp_ExportTablesToJson.sql
    Do not delete that repo file until this drop has been confirmed good.

  Pre-flight refuses to drop if the duplicate is missing, if the real
  procedure is absent, or if anything in the database references the
  duplicate. Safe to re-run: a second run reports nothing to do.
=====================================================================*/

USE [VCS];
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

DECLARE @dup  sysname = N'dbo.usp_ExportTablesToJson';   -- note the dot
DECLARE @keep sysname = N'usp_ExportTablesToJson';
DECLARE @sch  sysname = N'dbo';

IF NOT EXISTS (SELECT 1 FROM sys.objects
               WHERE type='P' AND name=@dup AND SCHEMA_NAME(schema_id)=@sch)
BEGIN
    PRINT 'Nothing to do: [' + @sch + '].[' + @dup + '] does not exist.';
    RETURN;
END

IF NOT EXISTS (SELECT 1 FROM sys.objects
               WHERE type='P' AND name=@keep AND SCHEMA_NAME(schema_id)=@sch)
BEGIN
    RAISERROR('ABORT: the procedure to keep, [dbo].[usp_ExportTablesToJson], was not found. Nothing dropped.', 16, 1);
    RETURN;
END

IF EXISTS (SELECT 1
           FROM sys.sql_expression_dependencies d
           JOIN sys.objects o ON o.object_id = d.referencing_id
           WHERE d.referenced_entity_name = @dup)
BEGIN
    SELECT SCHEMA_NAME(o.schema_id) AS ReferencingSchema, o.name AS ReferencingObject
    FROM sys.sql_expression_dependencies d
    JOIN sys.objects o ON o.object_id = d.referencing_id
    WHERE d.referenced_entity_name = @dup;
    RAISERROR('ABORT: the duplicate is referenced by the objects listed above. Nothing dropped.', 16, 1);
    RETURN;
END

/*-- Capture the definition one last time before dropping -----------*/
SELECT 'Definition about to be dropped' AS Note,
       OBJECT_DEFINITION(OBJECT_ID(QUOTENAME(@sch) + N'.' + QUOTENAME(@dup))) AS [Definition];

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @sql nvarchar(max) =
        N'DROP PROCEDURE ' + QUOTENAME(@sch) + N'.' + QUOTENAME(@dup) + N';';
    EXEC sys.sp_executesql @sql;

    COMMIT TRANSACTION;
    PRINT 'Dropped [' + @sch + '].[' + @dup + ']. The real procedure [' + @sch + '].[' + @keep + '] is untouched.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH
GO

/*-- Confirm the survivor -------------------------------------------*/
SELECT SCHEMA_NAME(schema_id) AS [Schema], name AS [Procedure]
FROM sys.objects
WHERE type = 'P' AND name LIKE '%ExportTablesToJson%';
GO
