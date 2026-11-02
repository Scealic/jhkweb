/*=====================================================================
  Mark unreferenced stored procedures with a 'Deprecated' extended property.

  Database   : [VCS]   (General)
  Server     : lvsqlp03\misc
  Targets    : 48 stored procedures
  Generated  : 2026-10-02

  WHAT THIS DOES
    Attaches an extended property named 'Deprecated' to each procedure.
    It does NOT rename, alter, drop, or otherwise change any procedure.
    Execution behaviour is completely unaffected. Fully reversible via
    the matching rollback script.

  EVIDENCE BEHIND THE LIST
    - No reference in any of the four codebases: Kelly-Revit,
      Kelly-Revit-Logic, Kelly-Windows, Kelly-Windows-Data.
    - No referencing object in sys.sql_expression_dependencies.

  KNOWN GAPS - these procedures are NOT confirmed dead
    - SQL Agent jobs could not be checked (no SELECT on msdb.dbo.sysjobsteps).
    - Query Store is OFF on this database, so no execution history exists.
    - External consumers (SSIS, Power BI, Excel, linked servers, ad-hoc use)
      are not visible to any of the above.
    Treat this as a review queue, not a drop list.

  SAFE TO RE-RUN. Existing 'Deprecated' properties are updated, not duplicated.
=====================================================================*/

USE [VCS];
GO
SET NOCOUNT ON;
GO

DECLARE @PropertyName sysname = N'Deprecated';
DECLARE @Note nvarchar(1000) = N'Deprecation candidate flagged 2026-10-02. '
    + N'No caller found in Kelly-Revit, Kelly-Revit-Logic, Kelly-Windows, '
    + N'Kelly-Windows-Data, nor in sys.sql_expression_dependencies. '
    + N'NOT yet confirmed dead: SQL Agent jobs unverified and Query Store is OFF. '
    + N'Do not drop before runtime usage has been observed.';

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

/*-- Pre-flight: every target must exist as a stored procedure -------*/
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

    PRINT '[VCS] Deprecated property added: ' + CAST(@added AS varchar(10))
        + ', updated: ' + CAST(@updated AS varchar(10))
        + ', total targets: 48';
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
