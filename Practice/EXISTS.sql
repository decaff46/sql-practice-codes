use classicmodels;
-- EXIST

-- find the customer who has at least one order:alter
describe orders;
describe orderdetails;
describe customers;

select 
	customerNumber, 
    customerName
from customers
where 
	exists( 
		select 
			* -- has at least one! here it can be anything 
		from 
			orders
		where 
			orders.customerNumber = customers.customerNumber
	);

-- find employees who work at the office in San Francisco:
describe employees;
select 
	employees.employeeNumber,
    concat_ws(", ", employees.lastName, employees.firstname) as `full name`,
    employees.extension
from employees
where 
	exists(
		select
			*
		from 
			offices
		where 
			offices.officeCode = employees.officeCode and 
            lower(city) = 'san francisco'
		);
        
/*
LIKE '%\_20%'; '%$_20%' ESCAPE '$';
-- side LIKE study 
select 
	city 
from 
	offices
where 
	city LIKE "san"; -- 0 
select 
	city 
from 
	offices
where 
	city LIKE "san%"; -- san francisco

select 
	city 
from 
	offices
where 
	city LIKE "%N%"; --
*/

-- adds the number 1 to the phone extension of employees who work at the office in San Francisco:
update employees
set 
	 extension = CONCAT(extension, '1')
where 
	exists(
		select
			1
		from 
			offices
		where 
			offices.officeCode = employees.officeCode
            and 
            city = "San Francisco");
            
describe employees;	
SET SQL_SAFE_UPDATES = 0; -- this will deal with the safe update issue that prevents me from doing the update

-- archive customers who don’t have any sales order in a separate table:
create table customer_archive
like customers;

-- insert customers who do not have any sales order into the customers_archive table:
INSERT INTO customer_archive
SELECT * 
FROM customers
WHERE 
	NOT EXISTS( 
	SELECT 1
	FROM
       orders
	WHERE
       orders.customernumber = customers.customernumber
	);

-- rename customer_archive to customers_archive;
alter table customer_archive rename customers_archive;
SELECT * FROM customers_archive;

-- delete the customers that exist in the customers_archive table from the customers table:
delete from customers
where 
	exists (
		select
			1
		from 
			customers_archive as a 
		where 
			a.customerNumber = customers.customerNumber);
 
 
 -- exists vs IN
 /* 
The query that uses the EXISTS operator is much faster than the one that uses the IN operator.
The reason is that the EXISTS operator works based on the “at least found” principle. 
The EXISTS stops scanning the table when a matching row found.
On the other hands, when the IN operator is combined with a subquery, MySQL must process the subquery 
first and then uses the result of the subquery to process the whole query.
The general rule of thumb is that if the subquery contains a large volume of data, the EXISTS operator provides better performance.
 */

EXPLAIN SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    EXISTS( 
        SELECT 
            1
        FROM
            orders
        WHERE
            orders.customernumber = customers.customernumber);
			

SELECT 
    customerNumber, customerName
FROM
    customers
WHERE
    customerNumber IN 
    (SELECT 
		customerNumber
	FROM
		orders);