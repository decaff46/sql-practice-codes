use classicmodels; 

## CASE WHEN 
/*
CASE case_value
   WHEN when_value1 THEN statements
   WHEN when_value2 THEN statements
   ...
   [ELSE else-statements]
END CASE;

-- AVOIDING ERROR WITH case_value not equal to when_value
CASE case_value
    WHEN when_value1 THEN ...
    WHEN when_value2 THEN ...
    ELSE 
        BEGIN
        END;
END CASE;
The simple CASE statement tests for equality ( =), 
you cannot use it to test equality with NULL; because NULL = NULL returns FALSE.
*/

DELIMITER $$
 
CREATE PROCEDURE GetCustomerShipping(
    IN  pCustomerNUmber INT, 
    OUT pShipping       VARCHAR(50)
)
BEGIN
    DECLARE customerCountry VARCHAR(100);
 
SELECT 
    country
INTO customerCountry FROM
    customers
WHERE
    customerNumber = pCustomerNUmber;
 
    CASE customerCountry
        WHEN  'USA' THEN
           SET pShipping = '2-day Shipping';
        WHEN 'Canada' THEN
           SET pShipping = '3-day Shipping';
        ELSE
           SET pShipping = '5-day Shipping';
    END CASE;
END$$
 
DELIMITER ;

CALL GetCustomerShipping(112,@shipping);
select @shipping

DELIMITER $$
 
CREATE PROCEDURE GetDeliveryStatus(
    IN pOrderNumber INT,
    OUT pDeliveryStatus VARCHAR(100)
)
BEGIN
    DECLARE waitingDay INT DEFAULT 0;
    SELECT 
        DATEDIFF(requiredDate, shippedDate)
    INTO waitingDay
    FROM orders
    WHERE orderNumber = pOrderNumber;
    
    CASE 
        WHEN waitingDay = 0 THEN 
            SET pDeliveryStatus = 'On Time';
        WHEN waitingDay >= 1 AND waitingDay < 5 THEN
            SET pDeliveryStatus = 'Late';
        WHEN waitingDay >= 5 THEN
            SET pDeliveryStatus = 'Very Late';
        ELSE
            SET pDeliveryStatus = 'No Information';
    END CASE;    
END$$
DELIMITER ;

CALL GetDeliveryStatus(10100,@delivery);
select @delivery;


/*
MySQL CASE vs. IF

Both IF and CASE statements allow you to execute a block of code based on a specific condition. 
Choosing between IF or CASE sometimes is just a matter of personal preference. Here are some guidelines:

	A simple CASE statement is more readable and efficient than an IF statement 
    when you compare a single expression against a range of unique values.
   
   When you check complex expressions based on multiple values, the IF statement is easier to understand.
   
   If you use the CASE statement, you have to make sure that at least one of the CASE condition is matched. Otherwise, you need to define an error handler to catch the error. Note that you do not have to do this with the IF statement.
   
   In some situations, you can use both IF and CASE to make the code more readable and efficient.
*/