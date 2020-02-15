use classicmodels; 

## LEAVE
/*
CREATE PROCEDURE sp_name()
sp: BEGIN
    IF condition THEN
        LEAVE sp;
    END IF;
    -- other statement
END$$
*/

-- creates a new stored procedure that checks the credit of a given customer in customers table :

DELIMITER $$

CREATE PROCEDURE CheckCredit(
	inCustomerNumber INT
)
sp: BEGIN
	DECLARE  customerCount INT; 
    
    -- check if the customer exists
    SELECT 
		count(*)
	INTO customerCount
    FROM customers
    WHERE
		customerNumber = inCustomerNumber; 
	-- if the customer does not exist, terminate
    -- the stored procedure
    IF customerCount = 0 THEN
        LEAVE sp;
    END IF;
    
    -- other logic
    -- ...
END$$
 
DELIMITER ;

-- by using LOOP 
/* 
[label]: LOOP
    IF condition THEN
        LEAVE [label];
    END IF;
    -- statements
END LOOP [label]; 
*/

-- by using repeat 
/*
[label:] REPEAT
    IF condition THEN
        LEAVE [label];
    END IF;
    -- statements
UNTIL search_condition
END REPEAT [label];
*/

-- by using while 
/*
[label:] WHILE search_condition DO
    IF condition THEN
        LEAVE [label];
    END IF;
    -- statements
END WHILE [label];
*/

DELIMITER $$
 
CREATE PROCEDURE LeaveDemo(OUT result VARCHAR(100))
BEGIN
    DECLARE counter INT DEFAULT 1;
    DECLARE times INT;
    -- generate a random integer between 4 and 10
    SET times  = FLOOR(RAND()*(10-4+1)+4);
    SET result = '';
    disp: LOOP
        -- concatenate counters into the result
        SET result = concat(result,counter,',');
        
        -- exit the loop if counter equals times
        IF counter = times THEN
            LEAVE disp; 
        END IF;
        SET counter = counter + 1;
    END LOOP;
END$$
 
DELIMITER ;

CALL LeaveDemo(@result);
SELECT @result;