/*=====================================================================
  VERIFY - the "Deprecate/Delete 1/1/2027" marks, in [VCS] and [VCS Content].

  Read only. For each database it lists:
    1. every procedure whose 'Deprecated' note starts with
       "Deprecate/Delete 1/1/2027";
    2. which of this set's targets are NOT marked that way (missing, or
       carrying a different note). Empty after a successful marking run;
       every target after a rollback.
  Generated: 2026-10-22
=====================================================================*/
SET NOCOUNT ON;

/*------------------------------------------------------------- VCS --*/
USE [VCS];

SELECT
    DB_NAME()                                   AS [Database],
    SCHEMA_NAME(o.schema_id)                    AS [Schema],
    o.name                                      AS [Procedure],
    CONVERT(nvarchar(1000), ep.value)           AS [DeprecatedNote],
    CONVERT(date, o.modify_date)                AS [LastModified]
FROM sys.extended_properties ep
JOIN sys.objects o ON o.object_id = ep.major_id
WHERE ep.class = 1 AND ep.minor_id = 0
  AND ep.name = N'Deprecated'
  AND CONVERT(nvarchar(1000), ep.value) LIKE N'Deprecate/Delete 1/1/2027%'
  AND o.type = 'P'
ORDER BY [Schema], [Procedure];

SELECT DB_NAME() AS [Database], t.SchemaName, t.ObjectName, 'NOT MARKED 2027' AS [Status]
FROM (VALUES
  (N'revit', N'USP_GroupTypeId_SelectWhere_v20250110'),
  (N'dbo', N'USP_BuiltInCategory_SelectWhereDefinitionIdAndRevitVersionEquals'),
  (N'dbo', N'USP_Table_ProductRangeParameterDefaults_ReadWhereProductRangeIdEqualsId'),
  (N'core', N'USP_System_SelectWhereIdEquals'),
  (N'core', N'USP_System_SelectWhereNameAndAbbreviationEquals'),
  (N'core', N'USP_ProjectToSystem_SelectWhereNumberAndConfigurationEquals'),
  (N'dbo', N'USP_EndPreparationsWelded_Select'),
  (N'dbo', N'USP_ConnectorPreparation_Select'),
  (N'dbo', N'USP_Table_ApplicationSession_CreateOne'),
  (N'dbo', N'USP_Table_ApplicationSession_UpdateWhereIdEqualsParameter'),
  (N'dbo', N'USP_ProjectSession_Insert'),
  (N'dbo', N'USP_ProjectSession_Update'),
  (N'dbo', N'USP_Table_ProjectMetricsLog_Insert'),
  (N'Development', N'USP_CodeTimer_Insert_v20241112')
) AS t (SchemaName, ObjectName)
WHERE NOT EXISTS (SELECT 1
                  FROM sys.objects o
                  JOIN sys.extended_properties ep ON ep.major_id = o.object_id AND ep.class = 1 AND ep.minor_id = 0 AND ep.name = N'Deprecated'
                  WHERE o.type = 'P' AND o.name = t.ObjectName AND SCHEMA_NAME(o.schema_id) = t.SchemaName
                    AND CONVERT(nvarchar(1000), ep.value) LIKE N'Deprecate/Delete 1/1/2027%')
ORDER BY t.SchemaName, t.ObjectName;

/*----------------------------------------------------- VCS Content --*/
USE [VCS Content];

SELECT
    DB_NAME()                                   AS [Database],
    SCHEMA_NAME(o.schema_id)                    AS [Schema],
    o.name                                      AS [Procedure],
    CONVERT(nvarchar(1000), ep.value)           AS [DeprecatedNote],
    CONVERT(date, o.modify_date)                AS [LastModified]
FROM sys.extended_properties ep
JOIN sys.objects o ON o.object_id = ep.major_id
WHERE ep.class = 1 AND ep.minor_id = 0
  AND ep.name = N'Deprecated'
  AND CONVERT(nvarchar(1000), ep.value) LIKE N'Deprecate/Delete 1/1/2027%'
  AND o.type = 'P'
ORDER BY [Schema], [Procedure];

SELECT DB_NAME() AS [Database], t.SchemaName, t.ObjectName, 'NOT MARKED 2027' AS [Status]
FROM (VALUES
  (N'dbo', N'USP_View_ComponentAndLookups_ReadAll'),
  (N'dbo', N'USP_Table_ConnectorGrouping_ReadWhereIdEqualsParameter'),
  (N'dbo', N'USP_ConnectorMapping_SelectWhereIdEqualsParameter_v20240716'),
  (N'dbo', N'USP_SizeSymbol_SelectWhereTradeIdEqualsParameter_v20240716'),
  (N'dbo', N'USP_View_MaterialAndLookups_ReadWhereEquals'),
  (N'Fabrication', N'USP_Configuration_SelectWhereGuidEquals')
) AS t (SchemaName, ObjectName)
WHERE NOT EXISTS (SELECT 1
                  FROM sys.objects o
                  JOIN sys.extended_properties ep ON ep.major_id = o.object_id AND ep.class = 1 AND ep.minor_id = 0 AND ep.name = N'Deprecated'
                  WHERE o.type = 'P' AND o.name = t.ObjectName AND SCHEMA_NAME(o.schema_id) = t.SchemaName
                    AND CONVERT(nvarchar(1000), ep.value) LIKE N'Deprecate/Delete 1/1/2027%')
ORDER BY t.SchemaName, t.ObjectName;
