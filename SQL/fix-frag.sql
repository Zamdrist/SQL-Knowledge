DECLARE @sql AS NVARCHAR(MAX)
DECLARE @preview AS BIT = 1

SELECT
	@sql =
	STRING_AGG(
				  'ALTER INDEX ' + [I].[name] + ' ON ' + [S].[name] + '.' + [T].[name]
				  + CASE WHEN [DDIPS].[avg_fragmentation_in_percent] > 29 THEN ' REBUILD'
						ELSE ' REORGANIZE'
					END
				  ,CHAR(13)
			  )
FROM [sys].dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS [DDIPS]
	 INNER JOIN [sys].[tables]										   [T] ON [T].[object_id] = [DDIPS].[object_id]
	 INNER JOIN [sys].[schemas]										   [S] ON [T].[schema_id] = [S].[schema_id]
	 INNER JOIN [sys].[indexes]										   [I] ON [I].[object_id] = [DDIPS].[object_id] AND [DDIPS].[index_id] = [I].[index_id]
WHERE [DDIPS].[database_id] = DB_ID() AND [I].[name] IS NOT NULL 

IF @preview = 1
	PRINT @sql
ELSE EXECUTE [sp_executesql] @statement = @sql
