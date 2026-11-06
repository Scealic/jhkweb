/*=====================================================================
  ROLLBACK - strip DEPREC_ prefix

  Database  : [VCS]   (General)
  Targets   : 47 stored procedures
  Generated : 2026-10-02

  Uses sp_rename with QUOTENAME, so names containing dots are handled
  correctly (two of the 54 contain dots, e.g.
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

USE [VCS];
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

DECLARE @targets TABLE (SchemaName sysname NOT NULL,
                        OldName    sysname NOT NULL,
                        NewName    sysname NOT NULL);

INSERT INTO @targets (SchemaName, OldName, NewName) VALUES
  (N'dbo', N'DEVUSP_Cleanup_DeveloperRecords_OlderThanTwentyFourHours', N'DEPREC_DEVUSP_Cleanup_DeveloperRecords_OlderThanTwentyFourHours'),
  (N'dbo', N'DEVUSP_DB_GetIndexes', N'DEPREC_DEVUSP_DB_GetIndexes'),
  (N'dbo', N'DEVUSP_DeleteUsingInnerJoinAndTableAlias', N'DEPREC_DEVUSP_DeleteUsingInnerJoinAndTableAlias'),
  (N'dbo', N'DEVUSP_OperationServiceLog_UpdateCountFromOperation', N'DEPREC_DEVUSP_OperationServiceLog_UpdateCountFromOperation'),
  (N'dbo', N'DEVUSP_OperationServiceLog_UpdateModifiedCount', N'DEPREC_DEVUSP_OperationServiceLog_UpdateModifiedCount'),
  (N'dbo', N'DEVUSP_OperationServiceLog_UpdateOperationId', N'DEPREC_DEVUSP_OperationServiceLog_UpdateOperationId'),
  (N'dbo', N'DEVUSP_ProjectSession_Update_ProjectId', N'DEPREC_DEVUSP_ProjectSession_Update_ProjectId'),
  (N'dbo', N'DEVUSP_ProjectUpdatersLog_UpdaterId_Update', N'DEPREC_DEVUSP_ProjectUpdatersLog_UpdaterId_Update'),
  (N'dbo', N'DEVUSP_TransactionLog_Update_ProjectId', N'DEPREC_DEVUSP_TransactionLog_Update_ProjectId'),
  (N'dbo', N'DEVUSP_TransactionLog_Update_ProjectId_FromProjectSession', N'DEPREC_DEVUSP_TransactionLog_Update_ProjectId_FromProjectSession'),
  (N'dbo', N'DEVUSP_TransactionLog_Update_TransactionId', N'DEPREC_DEVUSP_TransactionLog_Update_TransactionId'),
  (N'dbo', N'USP_ApplicationSession_DeleteOrphans', N'DEPREC_USP_ApplicationSession_DeleteOrphans'),
  (N'dbo', N'USP_BuiltInCategory_Insert', N'DEPREC_USP_BuiltInCategory_Insert'),
  (N'dbo', N'USP_BuiltInCategory_SelectWhereNameEquals', N'DEPREC_USP_BuiltInCategory_SelectWhereNameEquals'),
  (N'dbo', N'USP_BuiltInCategory_UpdateWhereNameEquals', N'DEPREC_USP_BuiltInCategory_UpdateWhereNameEquals'),
  (N'dbo', N'USP_BuiltInCategoryMeta_Insert', N'DEPREC_USP_BuiltInCategoryMeta_Insert'),
  (N'dbo', N'USP_BuiltInCategoryMeta_SelectWhereElementIdAndRevitVersionEquals', N'DEPREC_USP_BuiltInCategoryMeta_SelectWhereElementIdAndRevitVersionEquals'),
  (N'dbo', N'USP_BuiltInCategoryMeta_UpdateWhereElementIdAndRevitVersionEquals', N'DEPREC_USP_BuiltInCategoryMeta_UpdateWhereElementIdAndRevitVersionEquals'),
  (N'dbo', N'USP_ExternalParameterDefinition_SelectAll', N'DEPREC_USP_ExternalParameterDefinition_SelectAll'),
  (N'dbo', N'USP_OperationLog_Insert_v20240905_Deprecated2025.07.30', N'DEPREC_USP_OperationLog_Insert_v20240905_Deprecated2025.07.30'),
  (N'dbo', N'USP_OperationServiceLog_Insert_v20241216', N'DEPREC_USP_OperationServiceLog_Insert_v20241216'),
  (N'dbo', N'USP_OperationServiceLog_Insert_v20250729', N'DEPREC_USP_OperationServiceLog_Insert_v20250729'),
  (N'dbo', N'USP_Project_InsertNew_Deprecated2025.07.30', N'DEPREC_USP_Project_InsertNew_Deprecated2025.07.30'),
  (N'dbo', N'USP_Table_ExternalParameterDefinition_DeleteWhereIsForceDeleteFromDocumentEqualsTrue', N'DEPREC_USP_Table_ExternalParameterDefinition_DeleteWhereIsForceDeleteFromDocumentEqualsTrue'),
  (N'dbo', N'USP_Table_ProjectUpdatersLog_Insert', N'DEPREC_USP_Table_ProjectUpdatersLog_Insert'),
  (N'dbo', N'USP_Table_User_SelectWhereEmailEquals', N'DEPREC_USP_Table_User_SelectWhereEmailEquals'),
  (N'dbo', N'USP_Table_User_UpdateWhereEmailEquals', N'DEPREC_USP_Table_User_UpdateWhereEmailEquals'),
  (N'dbo', N'USP_Terminology_SelectWhereCategory', N'DEPREC_USP_Terminology_SelectWhereCategory'),
  (N'dbo', N'USP_Terminology_SelectWhereCategoryAndInitialismEquals_v20260402', N'DEPREC_USP_Terminology_SelectWhereCategoryAndInitialismEquals_v20260402'),
  (N'dbo', N'USP_Terminology_SelectWhereInitialismEquals_v20241127', N'DEPREC_USP_Terminology_SelectWhereInitialismEquals_v20241127'),
  (N'dbo', N'USP_User_Insert_v20260408', N'DEPREC_USP_User_Insert_v20260408'),
  (N'dbo', N'USP_User_SelectWhereEmailEquals_v20260406', N'DEPREC_USP_User_SelectWhereEmailEquals_v20260406'),
  (N'dbo', N'USP_User_UpdateWhereEmailEquals_v20260406', N'DEPREC_USP_User_UpdateWhereEmailEquals_v20260406'),
  (N'department', N'USP_Table_UserLinkToUserRole_SelectWhereUserIdEquals', N'DEPREC_USP_Table_UserLinkToUserRole_SelectWhereUserIdEquals'),
  (N'department', N'USP_Table_UserRole_SelectWhereUserRoleIdEquals', N'DEPREC_USP_Table_UserRole_SelectWhereUserRoleIdEquals'),
  (N'Development', N'DEVSP_CodeTimer_Delete_OldData', N'DEPREC_DEVSP_CodeTimer_Delete_OldData'),
  (N'Development', N'DEVSP_CodeTimer_Delete_UserIsChrisHildebran', N'DEPREC_DEVSP_CodeTimer_Delete_UserIsChrisHildebran'),
  (N'Development', N'DEVSP_CodeTimer_Delete_UserIsChrisHildebranAndOlderThanOneDay', N'DEPREC_DEVSP_CodeTimer_Delete_UserIsChrisHildebranAndOlderThanOneDay'),
  (N'Development', N'DEVSP_CodeTimer_Delete_WhereNoteContains', N'DEPREC_DEVSP_CodeTimer_Delete_WhereNoteContains'),
  (N'Development', N'USP_Table_UserLinkToUserRole_SelectWhereUserIdEquals', N'DEPREC_USP_Table_UserLinkToUserRole_SelectWhereUserIdEquals'),
  (N'Development', N'USP_Table_UserRole_SelectWhereUserRoleIdEquals', N'DEPREC_USP_Table_UserRole_SelectWhereUserRoleIdEquals'),
  (N'revit', N'USP_RibbonPanel_SelectWhereIdAndRibbonTabIdEquals_v20260313', N'DEPREC_USP_RibbonPanel_SelectWhereIdAndRibbonTabIdEquals_v20260313'),
  (N'revit', N'USP_RibbonPanel_SelectWhereRibbonTabIdEquals_v20240712', N'DEPREC_USP_RibbonPanel_SelectWhereRibbonTabIdEquals_v20240712'),
  (N'revit', N'USP_RibbonPanelLinkToUserRole_SelectWhereRibbonPanelId_v20260413', N'DEPREC_USP_RibbonPanelLinkToUserRole_SelectWhereRibbonPanelId_v20260413'),
  (N'revit', N'USP_RibbonTab_SelectWhereEnabledEquals', N'DEPREC_USP_RibbonTab_SelectWhereEnabledEquals'),
  (N'revit', N'USP_RibbonTab_SelectWhereInProductionEquals_v20260403', N'DEPREC_USP_RibbonTab_SelectWhereInProductionEquals_v20260403'),
  (N'revit', N'USP_Table_RibbonPanelLinkToUserRole_SelectWhereRibbonPanelId', N'DEPREC_USP_Table_RibbonPanelLinkToUserRole_SelectWhereRibbonPanelId');

/*-- Pre-flight ----------------------------------------------------*/
DECLARE @problems TABLE (Problem varchar(40), SchemaName sysname, ObjName sysname);

INSERT INTO @problems
SELECT 'SOURCE MISSING', t.SchemaName, t.NewName
FROM @targets t
WHERE NOT EXISTS (SELECT 1 FROM sys.objects o WHERE o.type='P'
                    AND o.name = t.NewName AND SCHEMA_NAME(o.schema_id) = t.SchemaName)
  AND NOT EXISTS (SELECT 1 FROM sys.objects o WHERE o.type='P'
                    AND o.name = t.OldName   AND SCHEMA_NAME(o.schema_id) = t.SchemaName);

INSERT INTO @problems
SELECT 'DESTINATION TAKEN', t.SchemaName, t.OldName
FROM @targets t
WHERE EXISTS (SELECT 1 FROM sys.objects o WHERE o.type='P'
                AND o.name = t.NewName AND SCHEMA_NAME(o.schema_id) = t.SchemaName)
  AND EXISTS (SELECT 1 FROM sys.objects o WHERE o.name = t.OldName
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
    SELECT SchemaName, NewName, OldName FROM @targets ORDER BY SchemaName, NewName;

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

    PRINT '[VCS] renamed: ' + CAST(@done AS varchar(10))
        + ', already done: ' + CAST(@skipped AS varchar(10))
        + ', total: 47';
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('local','tgt') >= 0 BEGIN CLOSE tgt; DEALLOCATE tgt; END
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH
GO
