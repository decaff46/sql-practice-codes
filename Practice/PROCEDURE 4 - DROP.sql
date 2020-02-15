USE classicmodels; 
## DROP PROCEDURE 

-- DROP PROCEDURE [IF EXISTS] stored_procedure_name;

-- ex:  create a new stored procedure that returns employee and office information:

delimiter $$

create procedure GetEmployees()
begin 
	select 
		firstName, lastName, city, state, country
	from 	
		employees
	inner join offices using (officeCode);
end $$

delimiter ; 
call GetEmployees();

-- DROP 
DROP PROCEDURE GetEmployees;
DROP PROCEDURE IF EXISTS abc;
SHOW WARNINGS;

DELIMITER $$
 
CREATE PROCEDURE GetPayments()
BEGIN
    SELECT 
        customerName, 
        checkNumber, 
        paymentDate, 
        amount
    FROM payments
    INNER JOIN customers 
        using (customerNumber);
END$$
 
DELIMITER ;
