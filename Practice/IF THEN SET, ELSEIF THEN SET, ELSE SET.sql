USE classicmodels;

/*
The IF statement has three forms: 
	simple IF-THEN statement, 
	IF-THEN-ELSE statement, and 
	IF-THEN-ELSEIF- ELSE statement.
    
IF condition THEN 
   statements;
END IF;   


*/

DELIMITER $$
 
CREATE PROCEDURE GetCustomerLevel(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL(10,2) DEFAULT 0;
 
    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;
 
    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    END IF;
END$$
 
DELIMITER ;

-- finds all customers that have a credit limit greater than 50,000:
SELECT 
	customerNumber, 
    creditLimit
FROM 
	customers
WHERE 
	creditLimit > 50000
ORDER BY 
	creditLimit DESC;
	
-- GetCustomerLevel() stored procedure for customer 141 
-- and show the value of the OUT parameter pCustomerLevel:
CALL GetCustomerLevel(141, @level); 
### SET @TEST = select sum(xxx) from xxx ; 이런 식이여야지 procedure로는 안됨.  
select @level; 


DROP PROCEDURE IF EXISTS GetCustomerLevel;

DELIMITER $$
 
CREATE PROCEDURE GetCustomerLevel(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL DEFAULT 0;
 
    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;
 
    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    ELSE
        SET pCustomerLevel = 'NOT PLATINUM';
    END IF;
END$$
 
DELIMITER ;

-- finds customers that have credit limit less than or equal 50,000:
select customerNumber, creditLimit
from customers
where creditLimit <= 50000
order by creditLimit DESC;

-- call the stored procedure for customer number 447  
-- and show the value of the OUT parameter pCustomerLevel:

call GetCustomerLevel(447, @level); 
select @level; 


DROP PROCEDURE GetCustomerLevel;

DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
	IN pCustomerNumber INT, 
    OUT pCusotmerLevel VARCHAR(20))
BEGIN 
	DECLARE credit DEC(10,2) DEFAULT 0; 
    
    SELECT creditLimit 
	INTO credit
    FROM customers 
    where customerNumber = pCustomerNumber; 
    
    IF credit > 50000 THEN 
		set pCusotmerLevel = 'Plat'; -- 반드시 ;를 찍어 줘야함 
	elseif credit <= 50000 AND credit > 10000 THEN
		set pCusotmerLevel = 'Gold';
	else 
		set pCusotmerLevel = 'Silver';
		end if;
END $$

DELIMITER ; 

CALL GetCustomerLevel(447, @level); 
SELECT @level;
	