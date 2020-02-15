/* IS NULL */

use classicmodels;
show tables;
	
SELECT 1 IS NULL,  -- 0
       0 IS NULL,  -- 0
       NULL IS NULL; -- 1
       
SHOW COLUMNS FROM customers; -- this is gotta be the table name 
select count(*)
from customers;

-- find customers who do not have a sales representative:
SELECT 
	customerName, 
    customerNumber, 
    salesRepEmployeeNumber
from customers 
where salesRepEmployeeNumber IS NULL
order by customerNumber;

-- how many customers do not have a sales representative:
SELECT COUNT(*) as 'num cust' -- num_cust
from customers 
where salesRepEmployeeNumber IS NULL;

-- find customers who do have a sales representative:
SELECT 
	customerName, 
    customerNumber, 
    salesRepEmployeeNumber
from customers 
where salesRepEmployeeNumber IS NOT NULL
order by customerNumber;

-- how many customers have a sales representative:
SELECT COUNT(DISTINCT(customerName))
from customers 
where salesRepEmployeeNumber IS NOT NULL;

/* If you specify the val column in the COUNT() function, 
the COUNT() function will count only rows with non-NULL values in the  val column: */

select count(salesRepEmployeeNumber)
from customers;

show columns from products;

-- return the number of products in each product line:
select productLine, count(*)
from products
group by productLine;

select count(productLine) -- this will not return the product line
from products
group by productLine;


-- find the number of products supplied by each vendor:
select productVendor, count(*)
from products
group by productVendor
order by count(productVendor) DESC; -- count(*)

-- find vendors who supply at least 9 products
select productVendor, count(*)
from products
group by productVendor
having count(*) >= 9
order by count(productVendor) DESC; -- having gotta come before order by 


CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT,
    title VARCHAR(255),
    begin_date DATE NOT NULL,
    complete_date DATE NOT NULL,
    PRIMARY KEY(id)
);
 
INSERT INTO projects(title,begin_date, complete_date)
VALUES('New CRM','2020-01-01','0000-00-00'),
      ('ERP Future','2020-01-01','0000-00-00'),
      ('VR','2020-01-01','2030-01-01');

select * from projects;
 
SELECT * FROM projects
WHERE complete_date IS NULL;

/* If the variable @@sql_auto_is_null is set to 1, you can get the value of a generated column 
after executing an INSERT statement by using the IS NULL operator. 
Note that by default the variable @@sql_auto_is_null is 0. Consider the following example: */

-- set the variable @@sql_auto_is_null to 1.
SET @@sql_auto_is_null = 1;

-- insert a new row into the projects table:
INSERT INTO projects(title,begin_date, complete_date)
VALUES('MRP III','2010-01-01','2020-12-31'),
('aaa', '2010-11-11', '2011-01-01');

SELECT * FROM projects
WHERE complete_date IS NOT NULL;

-- use the IS NULL operator to get the generated value of the id column
SELECT 
    id
FROM
    projects
WHERE
    id IS NULL;
    
SET @@sql_auto_is_null = 0; -- = 0 then, cannot trace back the latest inserted value 

-- EXPLAIN
EXPLAIN SELECT 
    customerNumber, 
    salesRepEmployeeNumber
FROM
    customers
WHERE
    salesRepEmployeeNumber IS NULL;

select customerNumber, salesRepEmployeeNumber
from customers
where salesRepEmployeeNumber IS NULL
limit 1,1;

