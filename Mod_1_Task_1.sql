WITH
	 json_string AS
	(
		SELECT '[{"employee_id": "5181816516151", "department_id": "1", "class": "src\bin\comp\json"}, 
				 {"employee_id": "925155", "department_id": "1", "class": "src\bin\comp\json"}, 
				 {"employee_id": "815153", "department_id": "2", "class": "src\bin\comp\json"}, 
				 {"employee_id": "967", "department_id": "", "class": "src\bin\comp\json"} ]' as [str]
	)
	, parse_string as(
		SELECT 
			substring([str],CHARINDEX('{', [str]),CHARINDEX('}', [str])-1) string_item_1
			,substring([str],CHARINDEX('}', [str])+6, len([str])) string_items_1
		FROM   json_string
		UNION ALL
		SELECT 
			substring(string_items_1,CHARINDEX('{', string_items_1),CHARINDEX('}', string_items_1)-1) string_item_1
			,substring(string_items_1,CHARINDEX('}', string_items_1)+6, len(string_items_1)) string_items_1
		FROM parse_string
		WHERE CHARINDEX('{', string_items_1) <> 0)
	, parsed_string1 AS (
		SELECT 
			 CAST(substring(string_item_1, 
							CHARINDEX('employee_id', string_item_1) + LEN('employee_id') +4, 
							CHARINDEX(', ', string_item_1, CHARINDEX('employee_id', string_item_1)) - CHARINDEX('employee_id', string_item_1)-LEN('employee_id')-5) AS BIGINT) AS employee_id ,
			 CAST(CASE WHEN substring(string_item_1, CHARINDEX('department_id', string_item_1) + LEN('department_id') +4, 
									  CHARINDEX(', ', string_item_1, CHARINDEX('department_id', string_item_1)) -CHARINDEX('department_id', string_item_1)-LEN('department_id')-5) = ''
				  THEN  NULL 
				  ELSE substring(string_item_1, CHARINDEX('department_id', string_item_1) + LEN('department_id') +4, 
									  CHARINDEX(', ', string_item_1, CHARINDEX('department_id', string_item_1)) -CHARINDEX('department_id', string_item_1)-LEN('department_id')-5) END AS INT) AS department_id 
		FROM  parse_string)
	SELECT 
		 employee_id 
		,department_id 
	FROM parsed_string1
	;
