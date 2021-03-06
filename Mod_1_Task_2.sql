ALTER PROCEDURE [hr].[SP_table_info]
	(
	  @p_DatabaseName AS NVARCHAR(MAX)
	, @p_SchemaName AS NVARCHAR(MAX) 
	, @p_TableName AS NVARCHAR(MAX)
	)
AS
BEGIN
	DECLARE   @v_TableList TABLE ([Table_Name] VARCHAR(100), [Column_name] VARCHAR(100), [Data_type] VARCHAR(100) );
	DECLARE @v_Query NVARCHAR(MAX), @v_Query_db NVARCHAR(MAX);

	-- use required db
	SELECT @v_Query_db = 'USE ' + @p_DatabaseName;

	EXEC SP_EXECUTESQL @v_Query_db;

	INSERT 
	INTO @v_TableList
	SELECT [all_objects].[name], col.name, t.name
	FROM [sys].[all_objects]
		INNER JOIN sys.schemas on schemas.schema_id = [all_objects].schema_id
		INNER JOIN sys.columns col on col.object_id = [all_objects].object_id
		INNER JOIN sys.tables tab on col.object_id = tab.object_id
		INNER JOIN sys.types t ON t.user_type_id = col.user_type_id
	WHERE 1 = 1
	  AND schemas.name =  @p_SchemaName 
	--  AND schemas.name =  'hr'
	 -- and [all_objects].schema_id = 5 -- test
	  AND [all_objects].[type_desc] = 'USER_TABLE';


	WITH
		tbl_list AS
		(
			SELECT 
				 [Table_name]
				,[Column_name]
				,[Data_type]
				, LEAD([Table_name]) OVER (ORDER BY [Table_Name]) [leaded]
			FROM @v_TableList
		--	WHERE [Table_name] like 'regions'
			WHERE [Table_name] like @p_TableName
		),
		query_not_agg AS 
		(
			SELECT
				CASE 
					WHEN [leaded] IS NOT NULL 
						THEN 'SELECT   
								''' + @p_DatabaseName + ''' as [Database Name] 
							   ,''' + @p_SchemaName + ''' as [Schema name]
							   ,''' + tbl_list.[Table_Name] + ''' AS [Table_Name] 
							   ,COUNT(*) AS [Table total row count]
							   ,''' + tbl_list.[Column_Name] + ''' AS [Column_Name] 
							   ,''' + tbl_list.[Data_type] + ''' AS [Data_Type] 
							   , COUNT(DISTINCT ' + tbl_list.[Column_Name] + ') AS [Count of DISTINCT values]
							   , SUM(CASE WHEN ' + tbl_list.[Column_Name] + ' IS NULL THEN 1 ELSE 0 END ) AS [Count of empty/zero values]
							   , SUM(CASE WHEN CAST(UPPER(' + tbl_list.[Column_Name] + ') AS binary)  = CAST(' + tbl_list.[Column_Name] + ' AS binary) THEN 1 ELSE 0 END)  AS [Only UPPERCASE strings]	
							   , SUM(CASE WHEN CAST(LOWER(' + tbl_list.[Column_Name] + ') AS binary)  = CAST(' + tbl_list.[Column_Name] + ' AS binary) THEN 1 ELSE 0 END)  AS [Only LOWERCASE strings]	
							   , SUM(CASE WHEN ASCII(RIGHT(' + tbl_list.[Column_Name] + ', 1)) IN (0, 7, 9, 10, 13, 16) OR  ASCII(LEFT(' + tbl_list.[Column_Name] + ', 1)) IN (0, 7, 9, 10, 13, 16) THEN 1 ELSE 0 END)  AS [Rows with non-printable characters at the beginning/end]
							   , null as [Most used value]
							   , null as [% rows with most used value]
							   , CAST(MIN(CASE WHEN CAST('''+ tbl_list.[Data_type] + ''' AS binary) = CAST(''date'' AS binary) THEN CONVERT(VARCHAR(8), ' + tbl_list.[Column_Name] + ' , 112) ELSE ' + tbl_list.[Column_Name] + '  END) AS VARCHAR) as [MIN value]
							   , CAST(MAX(CASE WHEN CAST('''+ tbl_list.[Data_type] + ''' AS binary) = CAST(''date'' AS binary) THEN CONVERT(VARCHAR(8), ' + tbl_list.[Column_Name] + ' , 112) ELSE ' + tbl_list.[Column_Name] + '  END) AS VARCHAR) as [MAX value]
							  FROM [' + @p_SchemaName + '].[' + tbl_list.[Table_Name] + '] 
								UNION ALL '
						ELSE 'SELECT
								'''	+ @p_DatabaseName + ''' as [Database Name] 
							   ,''' + @p_SchemaName + '''as [Schema name]
							   ,''' + tbl_list.[Table_Name] + ''' AS [Table_Name] 
						       , COUNT(*) AS [Table total row count]
							   ,''' + tbl_list.[Column_Name] + ''' AS [Column_Name] 
							   ,''' + tbl_list.[Data_type] + ''' AS [Data_Type] 
							   , COUNT(DISTINCT ' + tbl_list.[Column_Name] + ') AS [Count of DISTINCT values]
							   , SUM(CASE WHEN ' + tbl_list.[Column_Name] + ' IS NULL THEN 1 ELSE 0 END ) AS [Count of empty/zero values]
							   , SUM(CASE WHEN CAST(UPPER(' + tbl_list.[Column_Name] + ') AS binary)  = CAST(' + tbl_list.[Column_Name] + ' AS binary) THEN 1 ELSE 0 END)  AS [Only UPPERCASE strings]	
							   , SUM(CASE WHEN CAST(LOWER(' + tbl_list.[Column_Name] + ') AS binary)  = CAST(' + tbl_list.[Column_Name] + ' AS binary) THEN 1 ELSE 0 END)  AS [Only LOWERCASE strings]
							   , SUM(CASE WHEN ASCII(RIGHT(' + tbl_list.[Column_Name] + ', 1)) IN (0, 7, 9, 10, 13, 16) OR  ASCII(LEFT(' + tbl_list.[Column_Name] + ', 1)) IN (0, 7, 9, 10, 13, 16) THEN 1 ELSE 0 END)  AS [Rows with non-printable characters at the beginning/end]
							   , null as [Most used value]
							   , null as [% rows with most used value]
							   , CAST(MIN(CASE WHEN CAST('''+ tbl_list.[Data_type] + ''' AS binary) = CAST(''date'' AS binary) THEN CONVERT(VARCHAR(8), ' + tbl_list.[Column_Name] + ' , 112) ELSE ' + tbl_list.[Column_Name] + '  END) AS VARCHAR) as [MIN value]
							   , CAST(MAX(CASE WHEN CAST('''+ tbl_list.[Data_type] + ''' AS binary) = CAST(''date'' AS binary) THEN CONVERT(VARCHAR(8), ' + tbl_list.[Column_Name] + ' , 112) ELSE ' + tbl_list.[Column_Name] + '  END) AS VARCHAR) as [MAX value]
							  FROM [' + @p_SchemaName + '].[' + tbl_list.[Table_Name] + ']'
				END [query_text]
			FROM tbl_list 
		)
	--	SELECT * FROM query_not_agg;
	SELECT 
		@v_Query = STRING_AGG([query_text], '') WITHIN GROUP (ORDER BY [query_text])
	FROM query_not_agg;

	EXEC SP_EXECUTESQL @v_Query;

END;

EXEC [hr].[SP_table_info] 
    @p_DatabaseName = 'TRN'
	,@p_SchemaName = 'hr'
	,@p_TableName = 'jobs';

EXEC [hr].[SP_table_info] 
    @p_DatabaseName = 'TRN'
	,@p_SchemaName = 'hr'
	,@p_TableName = '%';

-- for test Rows with non-printable characters at the beginning/end
insert  into  hr.jobs
values ( '	Test tab start', 0, 0), ( 'test tab end	', 0, 0);

delete from hr.jobs where job_title like '%est tab %';
