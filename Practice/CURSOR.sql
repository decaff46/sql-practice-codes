USE classicmodels ;

## CUROR

/*
To handle a result set inside a stored procedure, you use a cursor. 
A cursor allows you to iterate a set of rows returned by a query and process each row individually.

MySQL cursor is read-only, non-scrollable and asensitive.

Read-only: you cannot update data in the underlying table through the cursor.

Non-scrollable: you can only fetch rows in the order determined by the SELECT statement. You cannot fetch rows in the reversed order. 
In addition, you cannot skip rows or jump to a specific row in the result set.

Asensitive: there are two kinds of cursors: asensitive cursor and insensitive cursor. 
An asensitive cursor points to the actual data, whereas an insensitive cursor uses a temporary copy of the data. 
An asensitive cursor performs faster than an insensitive cursor because it does not have to make a temporary copy of data. 
However, any change that made to the data from other connections will affect the data that is being used by an asensitive cursor, 
therefore, it is safer if you do not update the data that is being used by an asensitive cursor. MySQL cursor is asensitive.
*/

/*
DECLARE cursor_name CURSOR FOR SELECT_statement; 
-- The cursor declaration must be after any variable declaration. 
-- If you declare a cursor before the variable declarations, MySQL will issue an error. A cursor must always associate with a SELECT statement.

OPEN cursor_name;

FETCH cursor_name INTO variables list;

CLOSE cursor_name;
*/

DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;


DELIMITER $$
CREATE PROCEDURE createEmailList (
    INOUT emailList varchar(4000)
)
BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE emailAddress varchar(100) DEFAULT "";
 
    -- declare cursor for employee email
    DEClARE curEmail 
        CURSOR FOR 
            SELECT email FROM employees;
 
    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;
 
    OPEN curEmail;
 
    getEmail: LOOP
        FETCH curEmail INTO emailAddress;
        IF finished = 1 THEN 
            LEAVE getEmail;
        END IF;
        -- build email list
        SET emailList = CONCAT(emailAddress,";",emailList);
    END LOOP getEmail;
    CLOSE curEmail;
 
END$$
DELIMITER ;

SET @emailList = ""; 
CALL createEmailList(@emailList); 
SELECT @emailList;