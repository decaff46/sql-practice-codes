use classicmodels;

-- To get the row count of multiple tables, you use the UNION operator to combine result sets returned by each individual SELECT statement.
SELECT 
	'customers' tablename,
	count(*) as numb
FROM 
	customers
UNION ALL  
SELECT 
	'orders' tablename,
	count(*)
FROM 
	orders;
    
-- To get the row count all tables in a specific database e.g., classicmodels
-- 1. First, get all table names in the database
SELECT 
	table_name
FROM 
	information_schema.tables
WHERE
	table_schema = 'classicmodels' AND
    table_type = 'BASE TABLE';  -- its gotta be capitalized 

-- 2. construct an SQL statement that includes all SELECT COUNT(*) FROM table_name statements for all tables separated by UNION.
SELECT 
    CONCAT(GROUP_CONCAT(CONCAT('SELECT \'',
                        table_name,
                        '\' table_name,COUNT(*) rows FROM ',
                        table_name)
                SEPARATOR ' UNION '),
            ' ORDER BY table_name')
INTO @sql 
FROM
    (SELECT 
        table_name
    FROM
        information_schema.tables
    WHERE
        table_schema = 'classicmodels'
            AND table_type = 'BASE TABLE') table_list;							
    
WITH table_list AS (
SELECT
    table_name
  FROM information_schema.tables 
  WHERE table_schema = 'classicmodels' AND
        table_type = 'BASE TABLE'
) 
SELECT CONCAT(
            GROUP_CONCAT(CONCAT("SELECT '",table_name,"' table_name,COUNT(*) rows FROM ",table_name) SEPARATOR " UNION "),
            ' ORDER BY table_name'
        )
INTO @sql
FROM table_list; 

-- 3. excute the @sql 
PREPARE s FROM  @sql;
EXECUTE s;
DEALLOCATE PREPARE s;