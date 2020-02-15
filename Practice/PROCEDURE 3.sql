USE classicmodels;

## PROCEDURE 3 
-- To redefine the default delimiter, you use the DELIMITER command:
DELIMITER // -- ; 없어야 함 ! 하고 꼭 같이 써야함 

DELIMITER //
SELECT * FROM customers //
SELECT * FROM products //

DELIMITER ; -- back to original 

/*
Using MySQL DELIMITER for stored procedures

A stored procedure typically contains multiple statements separated by semicolon (;).  
To use compile the whole stored procedure as a single compound statement, 
you need to temporarily change the delimiter from the semicolon (;) to anther delimiters 
such as $$ or //:

DELIMITER $$
 
CREATE PROCEDURE sp_name()
BEGIN
  -- statements
END $$
 
DELIMITER ;
*/