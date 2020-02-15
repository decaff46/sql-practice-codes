-- having 

use classicmodels;
/*
SELECT 
    select_list
FROM 
    table_name
WHERE 
    search_condition
GROUP BY 
    group_by_expression
HAVING 
    group_condition; */

-- get order numbers, the number of items sold per order, and total sales for each from the orderdetails table:
show columns from orderdetails;
select 
	orderNumber, 
    sum(quantityOrdered) as 'number of sales', 
    sum(quantityOrdered * priceEach) as total
from orderdetails
group by orderNumber;

--  find which order has total sales greater than 1000 by using the HAVING clause as follows:
select 
	orderNumber, 
    sum(quantityOrdered) as 'number of sales', 
    sum(quantityOrdered * priceEach) as total
from orderdetails
group by orderNumber
having total > 1000; 
/* You can construct a complex condition in the HAVING clause using logical operators such as OR and AND. */

-- o find orders that have total amounts greater than 1000 and contain more than 600 items:
select 
	orderNumber, 
    sum(quantityOrdered) as `number of sales`, 
    sum(quantityOrdered * priceEach) as total
from 
	orderdetails
group by 
	orderNumber
having 
	total > 1000 and 
	`number of sales` > 600;  -- 'number of sales' > 600 does not work but why? 
     -- OK, so when i use the alise I SHOULD NOT USE '' since it will read as character, so go with `` (backticks)

-- find all orders that are in shipped status and have the total amount greater than 1500:
select
	orderNumber, 
    -- sum(quantityOrdered) as number,
    sum(quantityOrdered * priceEach) as total, 
    status 
from 
	orders 
	inner join orderdetails using(orderNumber)
group by
	status,
    orderNumber
having 
	lower(status) = 'shipped' AND
    total > 1500;
    
-- The HAVING clause is only useful when you use it with the GROUP BY clause to generate the output of the high-level reports. 
