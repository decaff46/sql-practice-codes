use classicmodels;

select t1.*, t2.* from t1, t2;

INSERT INTO t2(title,note)
VALUES('new row 4','new');

SELECT
	id, title
FROM 
	(
		select id, title from t1
        UNION 
        select id, title from t2
	) as temp
GROUP BY id, title
HAVING COUNT(*) = 1;


-- get the row count of customers and orders tables in a single query:
SELECT 
	'customers' tablename,
	COUNT(*)
FROM 
	customers
UNION 
SELECT 
	'orders' tablename,
	COUNT(*)
FROM 
	orders;
    
-- get all table names of a database:
SELECT 
	table_name
FROM 
	information_schema.tables
WHERE 
	table_schema = 'classicmodels' AND table_type = 'BASE TABLE';
    
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
            
PREPARE s FROM  @sql;
EXECUTE s;
DEALLOCATE PREPARE s;


SELECT 
    table_name, 
    table_rows
FROM
    information_schema.tables
WHERE
    table_schema = 'classicmodels'
ORDER BY table_name;

 SELECT 
    CONCAT_WS(CHAR(13),
            CONCAT_WS(' ', contactLastname, contactFirstname),
            addressLine1,
            addressLine2,
            CONCAT_WS(' ', postalCode, city),
            country,
            CONCAT_WS(CHAR(13), '')) AS Customer_Address
FROM
    customers;
    
SELECT CONCAT('MySQL',"_",'CONCAT');    