/*=====================================================================
  Mark stored procedures no longer called by Kelly Tools For Revit with a
  'Deprecated' extended property: "Deprecate/Delete 1/1/2027".

  Database   : [VCS Content]   (Content)
  Server     : lvsqlp03\misc
  Targets    : 6 stored procedures
  Generated  : 2026-10-22

  WHAT THIS DOES
    Attaches an extended property named 'Deprecated' to each procedure.
    It does NOT rename, alter, drop, or otherwise change any procedure.
    Execution behaviour is completely unaffected. Fully reversible via
    the matching rollback script.

  EVIDENCE BEHIND THE LIST (checked 2026-10-22)
    - Kelly Tools For Revit Generation 4 called these before 2026-10-22.
      It now reads CSV data files exported by Kelly-Data-Exporter and makes
      no SQL Server calls at all.
    - No reference in Kelly-Data-Exporter (develop), nor in Generation 5
      (the develop branches of Kelly-Revit, Kelly-Revit-Logic,
      Kelly-Windows and Kelly-Windows-Data).
    - Every target exists on lvsqlp03\misc, and no object references it
      in sys.sql_expression_dependencies.
    - None carried a 'Deprecated' property before this script.

  KNOWN GAPS - these procedures are NOT confirmed dead
    - SQL Agent jobs could not be checked (SELECT on msdb.dbo.sysjobs denied).
    - Execution history could not be checked (VIEW SERVER STATE denied), and
      Query Store is OFF.
    - Older Kelly Tools For Revit installs (Generation 3, and Generation 4
      builds before the CSV switch) still call these at startup, on project
      open and close, and in the updaters. Do not drop before every
      workstation runs the CSV build.
    - External consumers (SSIS, Power BI, Excel, linked servers, ad-hoc use)
      are not visible to any of the above.

  SAFETY
    - Stops without changes if a target is missing, or already carries a
      'Deprecated' note other than this one (for example the 2026-10-02 set).
    - SAFE TO RE-RUN: this script's own note is updated, not duplicated.
=====================================================================*/

USE [VCS Content];
GO
SET NOCOUNT ON;
GO

DECLARE @PropertyName sysname = N'Deprecated';
DECLARE @Prefix nvarchar(100) = N'Deprecate/Delete 1/1/2027';
DECLARE @Note nvarchar(1000) = @Prefix + N'. Flagged 2026-10-22: no longer called by '
    + N'Kelly Tools For Revit Generation 4 (reads CSV data files since 2026-10-22), '
    + N'Kelly-Data-Exporter or Generation 5 (develop); no referencing object in '
    + N'sys.sql_expression_dependencies. NOT checked: SQL Agent jobs, execution history, '
    + N'external consumers. Older KTR installs still call it: do not drop before every '
    + N'workstation runs the CSV build.';

DECLARE @targets TABLE (SchemaName sysname NOT NULL, ObjectName sysname NOT NULL);

INSERT INTO @targets (SchemaName, ObjectName) VALUES
  (N'dbo', N'USP_View_ComponentAndLookups_ReadAll'),
  (N'dbo', N'USP_Table_ConnectorGrouping_ReadWhereIdEqualsParameter'),
  (N'dbo', N'USP_ConnectorMapping_SelectWhereIdEqualsParameter_v20240716'),
  (N'dbo', N'USP_SizeSymbol_SelectWhereTradeIdEqualsParameter_v20240716'),
  (N'dbo', N'USP_View_MaterialAndLookups_ReadWhereEquals'),
  (N'Fabrication', N'USP_Configuration_SelectWhereGuidEquals');

/*-- Pre-flight 1: every target must exist as a stored procedure -----*/
IF EXISTS (SELECT 1 FROM @targets t
           WHERE NOT EXISTS (SELECT 1 FROM sys.objects o
                             WHERE o.type = 'P'
                               AND o.name = t.ObjectName
                               AND SCHEMA_NAME(o.schema_id) = t.SchemaName))
BEGIN
    SELECT 'NOT FOUND' AS Problem, t.SchemaName, t.ObjectName
    FROM @targets t
    WHERE NOT EXISTS (SELECT 1 FROM sys.objects o
                      WHERE o.type = 'P'
                        AND o.name = t.ObjectName
                        AND SCHEMA_NAME(o.schema_id) = t.SchemaName);
    RAISERROR('One or more target procedures do not exist. No changes made.', 16, 1);
    RETURN;
END

/*-- Pre-flight 2: never overwrite a different 'Deprecated' note -----*/
IF EXISTS (SELECT 1
           FROM @targets t
           JOIN sys.objects o ON o.name = t.ObjectName AND SCHEMA_NAME(o.schema_id) = t.SchemaName AND o.type = 'P'
           JOIN sys.extended_properties ep ON ep.major_id = o.object_id AND ep.class = 1 AND ep.minor_id = 0 AND ep.name = @PropertyName
           WHERE CONVERT(nvarchar(1000), ep.value) NOT LIKE @Prefix + N'%')
BEGIN
    SELECT 'ALREADY MARKED DIFFERENTLY' AS Problem, t.SchemaName, t.ObjectName, CONVERT(nvarchar(1000), ep.value) AS ExistingNote
    FROM @targets t
    JOIN sys.objects o ON o.name = t.ObjectName AND SCHEMA_NAME(o.schema_id) = t.SchemaName AND o.type = 'P'
    JOIN sys.extended_properties ep ON ep.major_id = o.object_id AND ep.class = 1 AND ep.minor_id = 0 AND ep.name = @PropertyName
    WHERE CONVERT(nvarchar(1000), ep.value) NOT LIKE @Prefix + N'%';
    RAISERROR('One or more targets already carry a different Deprecated note. No changes made.', 16, 1);
    RETURN;
END

DECLARE @s sysname, @o sysname, @added int = 0, @updated int = 0;

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
            EXEC sys.sp_updateextendedproperty
                 @name = @PropertyName, @value = @Note,
                 @level0type = N'SCHEMA',    @level0name = @s,
                 @level1type = N'PROCEDURE', @level1name = @o;
            SET @updated += 1;
        END
        ELSE
        BEGIN
            EXEC sys.sp_addextendedproperty
                 @name = @PropertyName, @value = @Note,
                 @level0type = N'SCHEMA',    @level0name = @s,
                 @level1type = N'PROCEDURE', @level1name = @o;
            SET @added += 1;
        END

        FETCH NEXT FROM tgt INTO @s, @o;
    END

    CLOSE tgt;
    DEALLOCATE tgt;

    COMMIT TRANSACTION;

    PRINT '[VCS Content] Deprecate/Delete 1/1/2027: added ' + CAST(@added AS varchar(10))
        + ', updated ' + CAST(@updated AS varchar(10)) + ' of 6 procedures.';
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
