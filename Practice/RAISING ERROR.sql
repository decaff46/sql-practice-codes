use classicmodels; 

## RAISING ERRORS

/*
SIGNAL SQLSTATE | condition_name;
SET condition_information_item_name_1 = value_1,
    condition_information_item_name_1 = value_2, etc;
*/

DELIMITER $$
 
CREATE PROCEDURE AddOrderItem(
                 in orderNo int, in productCode varchar(45), in qty int, in price double,in lineNo int, 
                 out result int)
BEGIN
    DECLARE C INT;
 
    SELECT COUNT(orderNumber) INTO C
    FROM orders 
    WHERE orderNumber = orderNo;
 
    -- check if orderNumber exists
    IF(C != 1) THEN 
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order No not found in orders table';
            set result = orderNo;
    END IF;
    -- more code below
    -- ...
END $$

DELIMITER ; 

select * from orders limit 1;
CALL AddOrderItem(10,'S10_1678',1,95.7,1, @result);
select @result;

/*
Besides the SIGNAL  statement, MySQL also provides the RESIGNAL  statement used to raise a warning or error condition.

The RESIGNAL  statement is similar to SIGNAL  statement in term of functionality and syntax, except that:

You must use the RESIGNAL  statement within an error or warning handler, otherwise, 
you will get an error message saying that “RESIGNAL when handler is not active”. 
Notice that you can use SIGNAL  statement anywhere inside a stored procedure.

You can omit all attributes of the RESIGNAL statement, even the SQLSTATE value.
*/

DELIMITER $$
 
CREATE PROCEDURE Divide(IN numerator INT, IN denominator INT, OUT result double)
BEGIN
    DECLARE division_by_zero CONDITION FOR SQLSTATE '22012';
 
    DECLARE CONTINUE HANDLER FOR division_by_zero 
    RESIGNAL SET MESSAGE_TEXT = 'Division by zero / Denominator cannot be zero';
    -- 
    IF denominator = 0 THEN
        SIGNAL division_by_zero;
    ELSE
        SET result := numerator / denominator;
    END IF;
END $$

-- Unlike =, the := operator is never interpreted as a comparison operator. 
-- This means you can use := in any valid SQL statement (not just in SET statements) to assign a value to a variable.

DELIMITER ; 

call Divide(10, 4, @test);
select @test;