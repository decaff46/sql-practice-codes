USE classicmodels;
## DECLARE
-- To declare a variable inside a stored procedure, you use the DECLARE  statement as follows:
 -- DECLARE variable_name datatype(size) [DEFAULT default_value]; 
/*
    First, specify the name of the variable after the DECLARE keyword. 
    The variable name must follow the naming rules of MySQL table column names.
    
    Second, specify the data type and length of the variable. 
    A variable can have any MySQL data types such as INT, VARCHAR , and DATETIME.
    
    Third, assign a variable a default value using the DEFAULT option.  
    If you declare a variable without specifying a default value, its value is NULL.
*/


-- NOTE: 
/*
Different types of variable:
    local variables (which are not prefixed by @) are strongly typed and scoped 
    to the stored program block in which they are declared. 
    Note that, as documented under DECLARE Syntax: 
		SET @var := value
        SELECT col1, @var_name := col2 from tb_name WHERE "conditon";

DECLARE is permitted only inside a BEGIN ... END compound statement and must be at its start, before any other statements.
    User variables (which are prefixed by @) are loosely typed and scoped to the session. 
    Note that they neither need nor can be declared—just use them directly.

Declare two or more variables that share the same data type using a single DECLARE statement.
	DECLARE x, y INT DEFAULT 0;
    
    
*/

-- EX: declares a variable named totalSale with the data type DEC(10,2) and default value 0.0
DELIMITER $$
CREATE PROCEDURE test()
BEGIN
	DECLARE totalSale DEC(10,2) DEFAULT 0.0;
	select 
		count(*)
	into totalSales
    from orders;
    
    select totalSales;
    
END $$
DELIMITER ; 

DELIMITER $$
CREATE PROCEDURE GetTotalOrder()
BEGIN
    DECLARE totalOrder INT DEFAULT 0;
    
    SELECT COUNT(*) 
    INTO totalOrder
    FROM orders;
    
    SELECT totalOrder;
END$$
 
DELIMITER ;


## ASSINGING VARIABLES
/*
-- SET:
SET variable_name = value;
	DECLARE total INT DEFAULT 0;
	SET total = 10;

DECLARE productCount INT DEFAULT 0;

-- SELECT INTO: 
SELECT COUNT(*) 
INTO productCount
FROM products;
*/