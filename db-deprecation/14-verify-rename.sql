/*=====================================================================
  VERIFY the DEPREC_ rename. Run against [VCS] then [VCS Content].
=====================================================================*/
SET NOCOUNT ON;

SELECT DB_NAME() AS [Database], SCHEMA_NAME(schema_id) AS [Schema],
       name AS [Procedure], CONVERT(date, modify_date) AS [Modified]
FROM sys.objects
WHERE type = 'P' AND is_ms_shipped = 0 AND name LIKE 'DEPREC[_]%'
ORDER BY [Schema], [Procedure];

SELECT COUNT(*) AS RenamedProcedures
FROM sys.objects
WHERE type = 'P' AND is_ms_shipped = 0 AND name LIKE 'DEPREC[_]%';

/*-- Expected: 48 in [VCS], 7 in [VCS Content] --------------------*/

/*-- Procedures whose stored definition no longer matches their name.
     This is expected after sp_rename and is corrected by deploying
     the updated repo definitions. ---------------------------------*/
SELECT SCHEMA_NAME(o.schema_id) AS [Schema], o.name AS [Procedure],
       'definition still names the pre-rename object' AS Note
FROM sys.objects o
JOIN sys.sql_modules m ON m.object_id = o.object_id
WHERE o.type = 'P' AND o.name LIKE 'DEPREC[_]%'
  AND m.definition NOT LIKE '%DEPREC[_]%';
