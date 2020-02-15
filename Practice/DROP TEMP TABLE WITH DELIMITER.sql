use classicmodels;

-- TEMPORARY TABLE
/*
a temporary table is a special type of table that allows you to store a temporary result set. User can reuse several times in a single session.

A temporary table is very handy when it is impossible or expensive to query data that requires 
a single SELECT statement with the JOIN clauses. 
In this case, you can use a temporary table to store the immediate result and use another query to process it.

MySQL removes the temporary table automatically when the session ends or the connection is terminated. 
Of course, you can use the  DROP TABLE statement to remove a temporary table explicitly when you are no longer use it.

A temporary table is only available and accessible to the client that creates it. 
Different clients can create temporary tables with the same name without causing errors because only the client that creates the temporary table can see it. 
However, in the same session, two temporary tables cannot share the same name.

A temporary table can have the same name as a normal table in a database. 
For example, if you create a temporary table named employees in the sample database, the existing employees table becomes inaccessible. 
Every query you issue against the employees table is now referring to the temporary table employees. 
But, it is not recommeded, of course. 

When you drop the employees temporary table, the permanent employees table is available and accessible.
*/ -- create temporary table if not exists a; does will not work since it allows duplicates

/* create temporary table
CREATE TEMPORARY TABLE table_name(
   column_1_definition,
   column_2_definition,
   ...,
   table_constraints
);

CREATE TEMPORARY TABLE ... LIKE statement. Instead, you use the following syntax:

CREATE TEMPORARY TABLE temp_table_name
SELECT * FROM original_table
LIMIT 0;

*/ -- it is exactly same as create table, but cannot use create table ** like **

create temporary table pay_test
select * from payments;

drop table if exists pay_test;



CREATE TEMPORARY TABLE credits(
    customerNumber INT PRIMARY KEY,
    creditLimit DEC(10,2)
);


INSERT INTO credits(customerNumber,creditLimit)
SELECT customerNumber, creditLimit
FROM customers
WHERE creditLimit > 0;

select * from credits;

-- creates a temporary table that stores the top 10 customers by revenue. 
create temporary table top_customers
select 
	customerNumber, 
    customerName,
    round(sum(amount),2) as sale
from 
	customers inner join payments using(customerNumber)
group by 
	customerNumber
order by round(sum(amount),2) DESC
limit 10;

-- select top customers from the table:
select 
	customerNumber, 
    customerName, 
    sale
from 
	top_customers
order by 
	sale;
    
-- drop the temp table 
-- DROP TEMPORARY TABLE top_customers;

-- checks if a temporary table exists or not as follows:
-- function start keyword : DELLIMITER // END // DELIMTER ; 
DELIMITER // 
CREATE PROCEDURE check_table_exists(table_name VARCHAR(100)) 
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET @err = 1;
    SET @err = 0;
    SET @table_name = table_name;
    SET @sql_query = CONCAT('SELECT 1 FROM ',@table_name);
    PREPARE stmt1 FROM @sql_query;
    IF (@err = 1) THEN
        SET @table_exists = 0;
    ELSE
        SET @table_exists = 1;
        DEALLOCATE PREPARE stmt1;
    END IF;
END //
DELIMITER ;

CALL check_table_exists('credits');
SELECT @table_exists;

drop temporary table top_customers;
call check_table_exists('top_customers');
select @table_exists;