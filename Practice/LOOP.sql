use classicmodels;
## LOOP 
/*
[begin_label:] LOOP
    statement_list
END LOOP [end_label]

[label]: LOOP
    ...
    -- terminate the loop
    IF condition THEN
        LEAVE [label];
    END IF;
    ...
END LOOP;
*/

DROP PROCEDURE LoopDemo;
 
DELIMITER $$
CREATE PROCEDURE LoopDemo()
BEGIN
    DECLARE x  INT;
    DECLARE str  VARCHAR(255);
        
    SET x = 1;
    SET str =  '';
        
    loop_label:  LOOP
        IF  x > 10 THEN 
            LEAVE  loop_label;
        END  IF;
            
        SET  x = x + 1;
        IF NOT (x mod 2) THEN -- IF NOT(x mod 2)  == ODD; IF (x mod 2) == EVEN number
            ITERATE  loop_label; -- If the value of the x is an odd number, the ITERATE ignores everything below it and starts a new loop iteration.
        ELSE
            SET  str = CONCAT(str,x,',');
        END  IF;
    END LOOP;
    SELECT str;
END$$
 
DELIMITER ;

call LoopDemo();