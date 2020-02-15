use classicmodels;

--  common table expression or CTE
/* 
Unlike a derived table, a CTE can be self-referencing (a recursive CTE) or can be referenced multiple times in the same query. 
In addition, a CTE provides better readability and performance in comparison with a derived table.

WITH cte_name (column_list) AS (
    query
) 
SELECT * FROM cte_name;

Notice that the number of columns in the query must be the same as the number of columns in the column_list. 
If you omit the column_list, the CTE will use the column list of the query that defines the CTE
*/

-- example1 
describe customers;

with customers_in_usa as (
	select 
		customerNumber, 
        state,
        customerName
	from 
		customers 
	where 
		country = 'usa'
	) select
		customerName
	from 
		customers_in_usa
	where 
		state = 'ca'
	order by 
		customerName;
        
-- returns the top 5 sales rep in 2003. (emop number, first name, last name , sales)
show columns from customers;
show columns from orders;
show columns from orderdetails;
show columns from employees;

with top5_salerep_2003 as (
	select 
		salesRepEmployeeNumber as employeeNumber, 
		SUM(quantityOrdered * priceEach) as sales
	from 
		orders
        inner join orderdetails using(orderNumber)
        inner join customers using(customerNumber)
	where
		year(shippedDate) = 2003
        and status = 'shipped'
	group by 
		salesRepEmployeeNumber
	order by 
		sales DESC
	limit 5)  
    select
		employeeNumber, 
        firstName, 
        lastName, 
        sales
	from 
		employees
        inner join top5_salerep_2003 using(employeeNumber);

/*havhavee two CTEs in the same query. The first CTE ( salesrep) gets the employees whose job titles are the sales representative. 
The sSecond CTE ( customer_salesrep ) references the first CTE in the INNER JOIN clause to get the sales rep and customers of whom each sales rep is in charge.
After having the second CTE, we query data from that CTE using a simple SELECT statement with the ORDER BY clause.
*/

-- i can have two CTE with with name as (), name as()

with salesrep as
(
	select 
		employeeNumber, 
        concat(lastName, ", " , firstName) as salesrepName
	from 
		employees
	where 
		jobtitle LIKE '%rep'
),
customer_salesrep as
(
	select 
		customerName, 
		salesrepName 
	from 
		customers
		inner join salesrep on customers.salesRepEmployeeNumber = salesrep.employeeNumber
)
select 
	*
from 
	customer_salesrep
order by 
	customerName;
		
