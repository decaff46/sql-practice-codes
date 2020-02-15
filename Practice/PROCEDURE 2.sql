USE classicmodels;
## CREATE PROCEDURE 

-- creates a new stored procedure that wraps all products from the products table: 

DELIMITER $$ -- // ALSO WORKS

CREATE PROCEDURE GetAllProducts()
BEGIN 
	SELECT * 
    FROM products;
END $$ -- // ALSO WORKS but gotta be paired!!!

DELIMITER ; -- HERE I GOTTA HAVE A SPACE AFTER DELIMITER



