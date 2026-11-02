/*=====================================================================
  ROLLBACK - remove the 'Deprecated' extended property.

  Database  : [VCS]   (General)
  Targets   : 48 stored procedures
  Generated : 2026-10-02

  Removes only the 'Deprecated' property, and only from the procedures
  listed by the matching marking script. Other extended properties
  (MS_Description etc.) are left untouched. Safe to re-run.
=====================================================================*/

USE [VCS];
GO
SET NOCOUNT ON;
GO

DECLARE @PropertyName sysname = N'Deprecated';

DECLARE @targets TABLE (SchemaName sysname NOT NULL, ObjectName sysname NOT NULL);

INSERT INTO @targets (SchemaName, ObjectName) VALUES
  (N'dbo', N'dbo.usp_ExportTablesToJson'),
  (N'dbo', N'DEVUSP_Cleanup_DeveloperRecords_OlderThanTwentyFourHours'),
  (N'dbo', N'DEVUSP_DB_GetIndexes'),
  (N'dbo', N'DEVUSP_DeleteUsingInnerJoinAndTableAlias'),
  (N'dbo', N'DEVUSP_OperationServiceLog_UpdateCountFromOperation'),
  (N'dbo', N'DEVUSP_OperationServiceLog_UpdateModifiedCount'),
  (N'dbo', N'DEVUSP_OperationServiceLog_UpdateOperationId'),
  (N'dbo', N'DEVUSP_ProjectSession_Update_ProjectId'),
  (N'dbo', N'DEVUSP_ProjectUpdatersLog_UpdaterId_Update'),
  (N'dbo', N'DEVUSP_TransactionLog_Update_ProjectId'),
  (N'dbo', N'DEVUSP_TransactionLog_Update_ProjectId_FromProjectSession'),
  (N'dbo', N'DEVUSP_TransactionLog_Update_TransactionId'),
  (N'dbo', N'USP_ApplicationSession_DeleteOrphans'),
  (N'dbo', N'USP_BuiltInCategory_Insert'),
  (N'dbo', N'USP_BuiltInCategory_SelectWhereNameEquals'),
  (N'dbo', N'USP_BuiltInCategory_UpdateWhereNameEquals'),
  (N'dbo', N'USP_BuiltInCategoryMeta_Insert'),
  (N'dbo', N'USP_BuiltInCategoryMeta_SelectWhereElementIdAndRevitVersionEquals'),
  (N'dbo', N'USP_BuiltInCategoryMeta_UpdateWhereElementIdAndRevitVersionEquals'),
  (N'dbo', N'USP_ExternalParameterDefinition_SelectAll'),
  (N'dbo', N'USP_OperationLog_Insert_v20240905_Deprecated2025.07.30'),
  (N'dbo', N'USP_OperationServiceLog_Insert_v20241216'),
  (N'dbo', N'USP_OperationServiceLog_Insert_v20250729'),
  (N'dbo', N'USP_Project_InsertNew_Deprecated2025.07.30'),
  (N'dbo', N'USP_Table_ExternalParameterDefinition_DeleteWhereIsForceDeleteFromDocumentEqualsTrue'),
  (N'dbo', N'USP_Table_ProjectUpdatersLog_Insert'),
  (N'dbo', N'USP_Table_User_SelectWhereEmailEquals'),
  (N'dbo', N'USP_Table_User_UpdateWhereEmailEquals'),
  (N'dbo', N'USP_Terminology_SelectWhereCategory'),
  (N'dbo', N'USP_Terminology_SelectWhereCategoryAndInitialismEquals_v20260402'),
  (N'dbo', N'USP_Terminology_SelectWhereInitialismEquals_v20241127'),
  (N'dbo', N'USP_User_Insert_v20260408'),
  (N'dbo', N'USP_User_SelectWhereEmailEquals_v20260406'),
  (N'dbo', N'USP_User_UpdateWhereEmailEquals_v20260406'),
  (N'department', N'USP_Table_UserLinkToUserRole_SelectWhereUserIdEquals'),
  (N'department', N'USP_Table_UserRole_SelectWhereUserRoleIdEquals'),
  (N'Development', N'DEVSP_CodeTimer_Delete_OldData'),
  (N'Development', N'DEVSP_CodeTimer_Delete_UserIsChrisHildebran'),
  (N'Development', N'DEVSP_CodeTimer_Delete_UserIsChrisHildebranAndOlderThanOneDay'),
  (N'Development', N'DEVSP_CodeTimer_Delete_WhereNoteContains'),
  (N'Development', N'USP_Table_UserLinkToUserRole_SelectWhereUserIdEquals'),
  (N'Development', N'USP_Table_UserRole_SelectWhereUserRoleIdEquals'),
  (N'revit', N'USP_RibbonPanel_SelectWhereIdAndRibbonTabIdEquals_v20260313'),
  (N'revit', N'USP_RibbonPanel_SelectWhereRibbonTabIdEquals_v20240712'),
  (N'revit', N'USP_RibbonPanelLinkToUserRole_SelectWhereRibbonPanelId_v20260413'),
  (N'revit', N'USP_RibbonTab_SelectWhereEnabledEquals'),
  (N'revit', N'USP_RibbonTab_SelectWhereInProductionEquals_v20260403'),
  (N'revit', N'USP_Table_RibbonPanelLinkToUserRole_SelectWhereRibbonPanelId');

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

    PRINT '[VCS] Deprecated property removed from ' + CAST(@removed AS varchar(10))
        + ' of 48 procedures.';
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
