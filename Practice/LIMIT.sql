use classicmodels;

show tables;


/* limit */
SHOW COLUMNS FROM customers;

-- get the top five customers who have the highest credit
select customerNumber, customerName, creditLimit
from customers
order by creditlimit DESC
limit 5; -- DESC; 

--  find 5 customers who have the lowest credits:
select customerNumber, customerName, creditLimit
from customers
order by creditlimit
limit 5;

/* Because there are more than 5 customers that have credits zero, the result of the query above may lead to an inconsistent result.
To fix this the issue, you need to add more column to the ORDER BY clause to constrain the row in unique order */

select customerNumber, customerName, creditLimit
from customers
order by creditlimit, customerNumber
limit 5;

-- count the rows
select count(*)
from customers;

select customerNumber, customerName, creditLimit
from customers
order by customerName
limit 10;

-- get the rows of the second page that include row 11 – 20:
select customerNumber, customerName, creditLimit
from customers
order by customerName
limit 10, 10;

-- finds the customer who has the second-highest credit: 
-- nth highest or lowest value: The clause LIMIT n-1, 1 returns 1 row starting at the row n.
select customerNumber, customerName, creditLimit
from customers
order by creditLimit DESC
limit 1,1;


-- sql row starts from 0 too !!

