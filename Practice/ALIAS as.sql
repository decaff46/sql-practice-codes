-- name alias : AS ---

use classicmodels;
show tables;

show columns from employees;

-- uses the CONCAT_WS() function to concatenate first name and last name into full name.
select concat_ws(", " , lastName, firstName) full_name -- here i can also use as full_name
from employees;

-- sort the employee’s full names alphabetically:
select concat_ws(', ', lastName, firstName) AS `full names`
from employees
order by `full names`; -- in sql `` and "", '' has no difference but take it as string


-- selects the orders whose total amount are greater than 60000. It uses column aliases in GROUP BY and HAVING clauses.
show columns from orderdetails;
select 
	orderNumber as `order #`, 
    sum(priceEach * quantityOrdered) as `total amount`
from 
	orderdetails
group by 
	orderNumber
having 
	`total amount` > 60000;
-- order by `total amount` DESC; here order by is automatic

-- assign the employees table alias as e:
select * 
from employees 
as e; -- here as is not needed

SELECT 
    e.firstName, 
    e.lastName
FROM
    employees e -- even after assinging the alias, i still need to call employees then e
ORDER BY e.firstName; 

/* Both tables have the same column name:customerNumber.
Without using the table alias to qualify the customerNumber column, you will get an error message like: 
That is, in order for me to join the tables i need to specify the tables first even though they have common names

however if i use USING instead of ON, then i do not need to alias the tables*/

show columns from customers; 
show columns from orders;

select 
	customerName, 
    count(o.orderNumber) as 'total'
from 
	customers as c
inner join orders as o on c.customerNumber = o.customerNumber
group by customerName 
order by 
	total DESC;
		
-- using method try 
select 
	customerName, 
    count(orderNumber) as 'total'
from 
	customers 
inner join orders using (customerNumber) 
group by customerName 
order by 
	total DESC;