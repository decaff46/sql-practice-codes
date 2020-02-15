use classicmodels;
show tables;

-- SUBQUERY

-- returns employees who work in offices located in the USA:
show columns from employees;
select distinct officeCode
from employees;

select * from offices limit 5;

select 
	lastName, 
    firstName
from employees
where 
	officeCode in (
		select officeCode
        from offices
        where country = "USA"); -- sql == 이 아니라 "=' 로 가야 함
        
select 
	lastName, 
    firstName
from employees
	inner join offices using(officeCode)
where country = 'USA';

--  returns the customer who has the maximum payment:
show columns from payments;
select 
	customerNumber,
    max(amount)
from payments;

select 
	customerNumber, 
    amount, 
    checkNumber
from payments
where amount = 
	(select 
		max(amount)
	from payments);
    
-- find customers whose payments are greater than the average payment using a subquery:
select 
	customerNumber, 
    checkNumber,
    amount
from payments
where amount > (select avg(amount) from payments);

/* If a subquery returns more than one value, you can use other operators such as IN or NOT IN operator in the WHERE clause. */

--  use a subquery with NOT IN operator to find the customers who have not placed any orders as follows:
select 
	customerNumber, 
    customerName, 
    orderNumber
from customers
	inner join orders using(customerNumber)
where orderNumber IS NULL; -- order table has only the ordered data so find the ones not in the order table

select 
	customerNumber, 
    customerName
from customers 
where customerNumber NOT IN (select distinct customerNumber from orders);


--  finds the maximum, minimum and average number of items in sale orders:
select 
	max(items), 
    min(items), 
    -- avg(items): this will give me double so go with floor
    floor(avg(items))
from 
	(select 
		orderNumber, 
        count(orderNumber) as items
	from orderdetails
    group by orderNumber) as temp; -- from 에서 table을 만들경우 반드시 alias 가 있어야 함 
    
-- select products whose buy prices are greater than 
-- the average buy price of all products in each product line:
show columns from products;
select 
	productName, 
    buyprice,
    productLine
from products as p1
where 
	buyprice > 
		(select 
			avg(buyprice)
		from products
        where productLine = p1.productLine);

/* When a subquery is used with the EXISTS or NOT EXISTS operator, 
a subquery returns a Boolean value of TRUE or FALSE.  
The following query illustrates a subquery used with the EXISTS operator: 
SELECT 
    *
FROM
    table_name
WHERE
    EXISTS( subquery );
if the subquery returns any rows, EXISTS subquery returns TRUE, otherwise, it returns FALSE.
*/

-- finds sales orders whose total values are greater than 60K:
select 
	orderNumber, 
    sum(quantityOrdered * priceEach) as total
from 
	orderdetails
group by orderNumber
having SUM(priceEach * quantityOrdered) > 60000;

-- find customers who placed at least one sales order 
-- with the total value greater than 60K by using the EXISTS operator

select 
	customerNumber, 
    customerName
from 
	customers
		inner join orders using(customerNumber)
        inner join orderdetails using(orderNumber)
group by orderNumber
having 
	SUM(priceEach * quantityOrdered) > 60000;


-- using exit
select
	customerNumber, 
    customerName
from customers
where 
	exists(
		select 
			orderNumber, 
            sum(priceEach * quantityOrdered) as total
		from orderdetails
			inner join orders using(orderNumber)
		where 
			customerNumber = customers.customerNumber
		group by 
			orderNumber
		having sum(priceEach * quantityOrdered) > 60000
	);
			
            