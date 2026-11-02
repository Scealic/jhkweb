/*=====================================================================
  VERIFY - list every procedure currently carrying a 'Deprecated' property.
  Run against [VCS] and then [VCS Content].
=====================================================================*/
SET NOCOUNT ON;

SELECT
    DB_NAME()                                   AS [Database],
    SCHEMA_NAME(o.schema_id)                    AS [Schema],
    o.name                                      AS [Procedure],
    CONVERT(nvarchar(1000), ep.value)           AS [DeprecatedNote],
    CONVERT(date, o.create_date)                AS [Created],
    CONVERT(date, o.modify_date)                AS [LastModified]
FROM sys.extended_properties ep
JOIN sys.objects o
       ON o.object_id = ep.major_id
WHERE ep.class    = 1
  AND ep.minor_id = 0
  AND ep.name     = N'Deprecated'
  AND o.type      = 'P'
ORDER BY [Schema], [Procedure];

SELECT COUNT(*) AS TotalMarkedProcedures
FROM sys.extended_properties ep
JOIN sys.objects o ON o.object_id = ep.major_id
WHERE ep.class = 1 AND ep.minor_id = 0
  AND ep.name = N'Deprecated' AND o.type = 'P';
