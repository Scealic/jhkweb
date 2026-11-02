/*=====================================================================
  rename to DEPREC_ prefix

  Database  : [VCS Content]   (Content)
  Targets   : 7 stored procedures
  Generated : 2026-10-02

  Uses sp_rename with QUOTENAME, so names containing dots are handled
  correctly (three of the 55 contain dots, e.g.
  USP_Project_InsertNew_Deprecated2025.07.30).

  Pre-flight aborts the whole batch, with a report and zero changes, if
  any source object is missing or any destination name is already taken.
  Already-renamed procedures are counted and skipped, so re-running is safe.

  !! sp_rename does NOT rewrite the module definition in sys.sql_modules.
     After this runs, OBJECT_DEFINITION() still reads the old name.
     The matching repo-side change reconciles this on the next SSDT deploy.

  !! Renaming is a breaking change. These procedures were never observed
     at runtime - SQL Agent could not be read and Query Store is off -
     so any hidden caller will fail at its next invocation.
=====================================================================*/

USE [VCS Content];
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

DECLARE @targets TABLE (SchemaName sysname NOT NULL,
                        OldName    sysname NOT NULL,
                        NewName    sysname NOT NULL);

INSERT INTO @targets (SchemaName, OldName, NewName) VALUES
  (N'dbo', N'usp_MaxLengthOfDataInField', N'DEPREC_usp_MaxLengthOfDataInField'),
  (N'dbo', N'USP_Table_Product_ReadWhereProductCodeEqualsParameter', N'DEPREC_USP_Table_Product_ReadWhereProductCodeEqualsParameter'),
  (N'dbo', N'VCS_Update_Component_UpdateDerivedFields', N'DEPREC_VCS_Update_Component_UpdateDerivedFields'),
  (N'Fabrication', N'DEVUSP_SupportType_SelectAllAsEnum', N'DEPREC_DEVUSP_SupportType_SelectAllAsEnum'),
  (N'Fabrication', N'USP_SupportType_SelectAll_v20250604', N'DEPREC_USP_SupportType_SelectAll_v20250604'),
  (N'Fabrication', N'USP_SupportType_SelectWhereTypeAndConfigurationEquals_v20250604', N'DEPREC_USP_SupportType_SelectWhereTypeAndConfigurationEquals_v20250604'),
  (N'Fabrication', N'USP_SupportTypeMaterial_SelectWhereSupportTypeIdEquals_v20250603', N'DEPREC_USP_SupportTypeMaterial_SelectWhereSupportTypeIdEquals_v20250603');

/*-- Pre-flight ----------------------------------------------------*/
DECLARE @problems TABLE (Problem varchar(40), SchemaName sysname, ObjName sysname);

INSERT INTO @problems
SELECT 'SOURCE MISSING', t.SchemaName, t.OldName
FROM @targets t
WHERE NOT EXISTS (SELECT 1 FROM sys.objects o WHERE o.type='P'
                    AND o.name = t.OldName AND SCHEMA_NAME(o.schema_id) = t.SchemaName)
  AND NOT EXISTS (SELECT 1 FROM sys.objects o WHERE o.type='P'
                    AND o.name = t.NewName   AND SCHEMA_NAME(o.schema_id) = t.SchemaName);

INSERT INTO @problems
SELECT 'DESTINATION TAKEN', t.SchemaName, t.NewName
FROM @targets t
WHERE EXISTS (SELECT 1 FROM sys.objects o WHERE o.type='P'
                AND o.name = t.OldName AND SCHEMA_NAME(o.schema_id) = t.SchemaName)
  AND EXISTS (SELECT 1 FROM sys.objects o WHERE o.name = t.NewName
                AND SCHEMA_NAME(o.schema_id) = t.SchemaName);

IF EXISTS (SELECT 1 FROM @problems)
BEGIN
    SELECT * FROM @problems;
    RAISERROR('Pre-flight failed. No procedures were renamed.', 16, 1);
    RETURN;
END

/*-- Rename --------------------------------------------------------*/
DECLARE @s sysname, @from sysname, @to sysname;
DECLARE @objname nvarchar(776);
DECLARE @done int = 0, @skipped int = 0;

DECLARE tgt CURSOR LOCAL FAST_FORWARD FOR
    SELECT SchemaName, OldName, NewName FROM @targets ORDER BY SchemaName, OldName;

BEGIN TRY
    BEGIN TRANSACTION;

    OPEN tgt;
    FETCH NEXT FROM tgt INTO @s, @from, @to;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (SELECT 1 FROM sys.objects o WHERE o.type='P'
                     AND o.name = @from AND SCHEMA_NAME(o.schema_id) = @s)
        BEGIN
            SET @objname = QUOTENAME(@s) + N'.' + QUOTENAME(@from);
            EXEC sys.sp_rename @objname = @objname, @newname = @to, @objtype = 'OBJECT';
            SET @done += 1;
        END
        ELSE
            SET @skipped += 1;   -- already renamed on a previous run

        FETCH NEXT FROM tgt INTO @s, @from, @to;
    END

    CLOSE tgt;
    DEALLOCATE tgt;

    COMMIT TRANSACTION;

    PRINT '[VCS Content] renamed: ' + CAST(@done AS varchar(10))
        + ', already done: ' + CAST(@skipped AS varchar(10))
        + ', total: 7';
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('local','tgt') >= 0 BEGIN CLOSE tgt; DEALLOCATE tgt; END
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH
GO
