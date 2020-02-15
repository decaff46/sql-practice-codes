use classicmodels;
show tables;

-- GROUP BY
show columns from orders;

-- returns unique occurrences of status values. It works like the DISTINCT operator as shown in the following query:
select distinct  -- here distinct is not needed
	status,
    count(*)
from orders
group by status;


-- get the total amount of all orders by status by joining with orderdetails
show columns from orderdetails;
select 
	status, 
    sum(quantityOrdered * priceEach) as total 
from orders inner join orderdetails using(orderNumber)
group by status;


--  gets the total sales for each year:
show columns from orderdetails;
show columns from orders;

select 
	year(orderDate) as year, 
    sum(quantityOrdered * priceEach) as total
from orders inner join orderdetails using(orderNumber)
where lower(status) = 'Shipped'
group by year; -- group by year(orderDate) can be done too 


-- uses the HAVING clause to select the total sales of the years after 2003:
select 
	year(orderDate) as year, 
    sum(quantityOrdered * priceEach) as total
from orders inner join orderdetails using(orderNumber)
where lower(status) = 'Shipped' and year(orderDate) > 2003 -- here if i only use year, then it will give me an error. Hence, use year()
group by year(orderDate); -- in mysql it group by year works but not in standard, even after alias to year. So, just keep on using year()


-- extracts the year from the order date:
select 
	year(orderDate) as year, 
    count(orderNumber) as 'total order' -- count(*) works too 
from orders
group by year(orderDate);

-- get the number of orders by status and sort the status in descending order:
select 
	status, 
    count(*) -- or count(status)
from orders
group by status
order by status desc;



