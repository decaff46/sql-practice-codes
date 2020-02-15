USE classicmodels;

## LISTING STORED PROCEDURES 
-- 	SHOW PROCEDURE STATUS [LIKE 'pattern' | WHERE search_condition]

SHOW PROCEDURE STATUS; 
SHOW PROCEDURE STATUS WHERE db = 'classicmodels';
SHOW PROCEDURE STATUS LIKE '%Get%';

/*
The routines table in the information_schema database contains all information on 
the stored procedures and stored functions of all databases in the current MySQL server.

To show all stored procedures of a particular database, you use the following query:
SELECT 
    routine_name
FROM
    information_schema.routines
WHERE
    routine_type = 'PROCEDURE'
        AND routine_schema = '<database_name>';
*/
SELECT 
    routine_name
FROM
    information_schema.routines
WHERE
    routine_type = 'PROCEDURE'
        AND routine_schema = 'classicmodels';