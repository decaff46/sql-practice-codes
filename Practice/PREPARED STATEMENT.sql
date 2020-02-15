-- PREPARED STATEMENT

use classicmodels;
select * from products where productCode = ?; 

/* 
In order to use MySQL prepared statement, you use three following statements:

    PREPARE – prepare a statement for execution.
    EXECUTE – execute a prepared statement prepared by the PREPARE statement.
    DEALLOCATE PREPARE – release a prepared statement.
*/

PREPARE stmt1 FROM 
    'SELECT 
        productCode, 
		productName 
    FROM 
		products
	WHERE 
		productCode = ?';

	
SET @pc = 'S10_1678';  -- declare a variable named pc, stands for "product code", and set its value to 'S10_1678'
EXECUTE stmt1 USING @pc;

	
SET @pc = 'S12_1099';
EXECUTE stmt1 USING @pc;

	
DEALLOCATE PREPARE stmt1; -- release the prepared statement:


-- practice
PREPARE stmt2 FROM 
    'SELECT 
        productCode, 
		productName 
    FROM 
		products
	WHERE 
		productName = ?';
select distinct productName from products;
SET @pn = '1972 Alfa Romeo GTA';
EXECUTE stmt2 USING @pn;
