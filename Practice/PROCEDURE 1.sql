USE classicmodels;

## ADV. STORED PROCEDURE
-- partial table from customers
SELECT 
    customerName, 
    city, 
    state, 
    postalCode, 
    country
FROM
    customers
ORDER BY customerName;

/*
If you want to save this query on the database server for execution later, one way to do it is to use a stored procedure.
The following CREATE PROCEDURE statement creates a new stored procedure that wraps the query 
*/

DELIMITER $$

CREATE PROCEDURE GetCustomers()
BEGIN
	SELECT  -- this is the same code as above!
    customerName, city, state, postalCode, country
	FROM
		customers
	ORDER BY customerName;
END$$
DELIMITER ;
		
-- CALL THE FUNCTINO BY CALL()
CALL GetCustomers();