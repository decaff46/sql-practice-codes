use classicmodels;

## REPEAT LOOP
/*
[begin_label:] REPEAT
    statement
UNTIL search_condition
END REPEAT [end_label]

The REPEAT executes the statement until the search_condition evaluates to true.
*/

DELIMITER $$
 
CREATE PROCEDURE RepeatDemo()
BEGIN
    DECLARE counter INT DEFAULT 1;
    DECLARE result VARCHAR(100) DEFAULT '';
    
    REPEAT
        SET result = CONCAT(result,counter,',');
        SET counter = counter + 1;
    UNTIL counter >= 10
    END REPEAT;
    
    -- display result
    SELECT result;
END$$
 
DELIMITER ;

	
CALL RepeatDemo();