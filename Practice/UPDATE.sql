-- UPDATE
use classicmodels;

-- DIFF BTW ALTER AND UPDATE
/*

ALTER is a DDL (Data Definition Language) statement. 
Whereas UPDATE is a DML (Data Manipulation Language) statement. 

ALTER is used to update the structure of the table (add/remove field/index etc). 
Whereas UPDATE is used to update data.

*/

/*
The UPDATE statement modifies existing data in a table. 
You can also use the UPDATE statement change values in one or more columns of a single row or multiple rows.

UPDATE [LOW_PRIORITY] [IGNORE] table_name 
SET 
    column_name1 = expr1,
    column_name2 = expr2,
    ...
[WHERE
    condition];
*/
-- update the email of Mary Patterson to the new email mary.patterso@classicmodelcars.com:
describe employees;

select email from employees where firstName = 'Mary' and lastName = 'Patterson';

SET SQL_SAFE_UPDATES = 0;
update employees 
set email = 'mary.patterso@classicmodelcars.com'
where firstName = 'Mary' and lastName = 'Patterson'; -- employeeNumber = 1056

select email from employees where employees.employeeNumber = 1056;

-- updates the domain parts of emails of all Sales Reps with office code 6:
update employees
set email = replace(email, '@classicmodelcars.com', '@mysqltutorial.org')
where 
	employees.jobTitle = 'Sales Rep' and 
    employees.officeCode = 6;

select email from employees where employees.jobTitle = 'Sales Rep' and employees.officeCode = 6;


--  in the customers table, for the customers do not have any sale representative:
SELECT 
    customername, 
    salesRepEmployeeNumber
FROM
    customers_archive
WHERE
    salesRepEmployeeNumber IS NULL;
    
-- select a random employee whose job title is Sales Rep from the  employees table and update it for the  employees table:
select
	employeeNumber
from 
	employees
where 
	jobTitle = 'Sales Rep'
order by
	rand()
limit 10;

-- plug into customers who do not have salesRep
update customers_archive
set customers_archive.salesRepEmployeeNumber = (
	select
		employeeNumber
	from 
		employees
	where 
		jobTitle = 'Sales Rep'
	order by
		rand()
	limit 1
    )
where 
	customers_archive.salesRepEmployeeNumber is null;
    
SELECT 
	salesRepEmployeeNumber
FROM
    customers_archive
WHERE
    salesRepEmployeeNumber IS NULL;