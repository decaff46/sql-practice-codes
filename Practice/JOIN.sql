-- join 

use classicmodels;
show tables;

-- orders and orderdetails will be used

--  create two tables called members and committees:

CREATE TABLE if not exists members (
    member_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (member_id)
);
 
CREATE TABLE if not exists committees (
    committee_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (committee_id)
);

--  insert some rows into the tables members and committees :
INSERT INTO members(name)
VALUES('John'),('Jane'),('Mary'),('David'),('Amelia');
 
INSERT INTO committees(name)
VALUES('John'),('Mary'),('Amelia'),('Joe');

-- query data from the tables members and committees:
select * from members;
select * from committees;

-- finds members who are also the committee members:
select name 
from members
inner join committees using (name)
order by name;

select
	m.name, 
    m.member_id,
    c.name, 
    c.committee_id
from members as m
inner join committees as c on m.name = c.name;


-- left join to join the members with the committees table: 
select 
	name,
    member_id
from members
left join committees using (name); -- 여기서 중요한게 left 조인을 하게 되면 좌측의 모든게 불러지고 오른쪽에 안 묻는거 까지 불러지게 됨

select
	m.name as member_name, 
    m.member_id, 
    c.name as committee_name, 
    c.committee_id
from members as m
left join committees as c on m.name = c.name; 

-- look for the ones only in the members:
select 
	name,
    member_id
from members
left join committees using (name)
where committee_id IS NULL;

-- right join 	
SELECT 
    m.member_id, 
    m.name member, 
    c.committee_id, 
    c.name committee
FROM
    members m
RIGHT JOIN committees c on c.name = m.name;

SELECT 
    m.member_id, 
    m.name member, 
    c.committee_id, 
    c.name committee
FROM
    members m
RIGHT JOIN committees c using (name);

-- look for only in right:
SELECT 
    m.member_id, 
    m.name member, 
    c.committee_id, 
    c.name committee
FROM
    members m
RIGHT JOIN committees c on c.name = m.name
where member_id IS NULL;

/* Unlike the inner join, left join, and right join, the cross join clause does not have a join condition. 
The right join makes a Cartesian product of rows from the joined tables. 
The cross join combines each row from the first table with every row from the right table to make the result set.

Suppose the first table has n rows and the second table has m rows. 
The cross join that joins the first with the second table will return nxm rows.*/

SELECT 
    m.member_id, 
    m.name member, 
    c.committee_id, 
    c.name committee
FROM
    members m
CROSS JOIN committees c;



-- INNER JOIN DEEP DIVE
-- Notice that for INNER JOIN clause, the condition in the ON clause is equivalent to the condition in the WHERE clause.
-- That is, for inner join where clause is not needed 

/* get:
    The productCode and productName from the products table.
    The textDescription of product lines from the productlines table.
*/

show columns from products;
show columns from productlines;

select 
	productCode,
    productName,
    textDescription
from products
inner join productlines using (productLine);

-- returns order number, order status and total sales from the orders and orderdetails tables 
-- using the INNER JOIN clause with the GROUP BYclause:

show columns from orders;
show columns from orderdetails;

select 
	t1.orderNumber, 
    t1.status, 
    sum(t2.priceEach * t2.quantityOrdered) as `total sales` -- NEVER make space between sum and (). That is, sum()
from orders as t1
inner join orderdetails as t2 on t1.orderNumber = t2.orderNumber -- using(oderNumber)
group by orderNumber
order by `total sales` DESC;

select 
	t1.orderNumber, 
    t1.status, 
    sum(t2.priceEach * t2.quantityOrdered) as `total sales` -- NEVER make space between sum and (). That is, sum()
from orders as t1
inner join orderdetails as t2 using(orderNUmber)
group by orderNumber
order by `total sales` DESC; -- alias is totally not needed


-- uses two INNER JOIN clauses to join three tables: orders, orderdetails, and products:
show columns from orders;
show columns from orderdetails;
show columns from products;

-- get following tables with columsn : orderNumber, orderDate, orderLineNumber, productName, qualityOrdered, and priceEach

select 
	orderNumber, 
    orderDate, 
    orderLineNumber,
    productName,
    priceEach
from orders
inner join orderdetails using(orderNumber)
inner join products using(productCode)
order by     
	orderNumber, 
    orderLineNumber;
    
-- get following tables with columsn : orderNumber, orderDate, customerName, orderLineNumber, productName, qualityOrdered, and priceEach
show columns from customers;
show columns from products;
show columns from orders;
show columns from orderdetails;

select 
	orderNumber, 
    orderDate, 
    customerName, 
    orderLineNumber,
    productName, 
    quantityOrdered,
    priceEach
from orders
inner join customers using(customerNumber)
inner join orderdetails using(orderNumber)
inner join products using(productCode)
order by 
	orderNumber, 
    orderlineNumber;
    
--  find sales price of the product whose code is S10_1678 that is 
-- less than the manufacturer’s suggested retail price (MSRP) for that product.
 -- show columns from orders; wrong table
show columns from orderdetails;
show columns from products;

select 
	orderNumber, 
    productName, 
    MSRP, 
    priceEach
from products
inner join  orderdetails using(productCode)
where productCode = 'S10_1678' and MSRP > priceEach;

-- another method : 
SELECT 
    orderNumber, 
    productName, 
    msrp, 
    priceEach
FROM
    products p
INNER JOIN orderdetails o 
   ON p.productcode = o.productcode
      AND p.msrp > o.priceEach -- i can put AND with inner join
WHERE
    p.productcode = 'S10_1678';

SELECT 
    orderNumber, 
    productName, 
    msrp, 
    priceEach
FROM
    products p
INNER JOIN orderdetails o 
   ON p.productcode = o.productcode
      AND p.msrp > o.priceEach 
      AND p.productcode = 'S10_1678';


-- DEEP DIVE INTO LEFT JOIN

-- uses the LEFT JOIN to find customers who have no order:
show columns from customers;
show columns from orders;

/* select 
	distinct(status),
    distinct(orderNumber)
from orders
group by status; */ -- SELECT DISTINCT a,b 이런 형태로 써야 함 

select distinct
	status, 
    orderNumber
from orders
group by status;

select 
	customerNumber,
    customerName, 
    orderNumber, 
    status
from customers
left join orders using(customerNumber) 
where status IS NULL OR status = 'Cancelled';


-- join the three tables: employees, customers, and payments.
show columns from employees;
show columns from customers;
show columns from payments;

-- get the table with following columns: last,fist name, customerName, checkNumber, amount
select 
	 lastName,
     firstName,
     customerName, 
     checkNumber, 
     amount
from employees as e
left join customers as c on e.employeeNumber = c.salesRepEmployeeNumber
left join payments as p using(customerNumber)
-- where customerName IS NULL
order by customerName, checkNumber;
    
/* Condition in WHERE clause vs. ON clause 

*/
SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails 
    USING (orderNumber)
WHERE
    orderNumber = 10123;

SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails d 
    ON o.orderNumber = d.orderNumber AND 
       o.orderNumber = 10123; 
-- In this case, the query returns all orders but only the order 10123 will have line items associated with it 
       
       
-- DEEP DIVE CROSS JOIN
CREATE DATABASE IF NOT EXISTS salesdb;
USE salesdb;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(13,2 )
);
 
CREATE TABLE stores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(100)
);
 
CREATE TABLE sales (
    product_id INT,
    store_id INT,
    quantity DECIMAL(13 , 2 ) NOT NULL,
    sales_date DATE NOT NULL,
    PRIMARY KEY (product_id , store_id),
    FOREIGN KEY (product_id)
        REFERENCES products (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (store_id)
        REFERENCES stores (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO products(product_name, price)
VALUES('iPhone', 699),
      ('iPad',599),
      ('Macbook Pro',1299);
 
INSERT INTO stores(store_name)
VALUES('North'),
      ('South');
 
INSERT INTO sales(store_id,product_id,quantity,sales_date)
VALUES(1,1,20,'2017-01-02'),
      (1,2,15,'2017-01-05'),
      (1,3,25,'2017-01-05'),
      (2,1,30,'2017-01-02'),
      (2,2,35,'2017-01-05');


-- returns total sales for each store and product, you calculate the sales and group them by store and product as follows:
show columns from products;
show columns from sales;
show columns from stores;

select 
	store_name, 
    product_name, 
    round(sum(price * quantity), 1) as sales
from stores as st
	inner join sales as sa on st.id = sa.store_id
    inner join products as p on p.id = sa.product_id
group by 
	store_name, 
    product_name;
    
-- which store had no sales of a specific product. The inner join could not answer this question: 
-- to do this, should run the cross join 

select 
	store_name,
    product_name
from stores
	cross join products;
    
-- first make this table then combine with the above one by left join 
select 
	st.store_name,
    p.product_name,
    ifnull(sales, 0) as revenue
from products as p
	cross join stores as st
    left join (
		select 
			stores.store_name, 
            stores.id as store_id, -- here both store id and product id have the column names ID so need to change it. 
            products.id as product_id, -- otherwise, it will error, saying duplicate ID. 
            products.product_name,
            round(sum(quantity * price),1) as sales
		from sales
			inner join products on products.id = sales.product_id
			inner join stores on stores.id = sales.store_id
		group by store_name, product_name
    ) as rev
	on st.id = rev.store_id and p.id = rev.product_id
order by st.store_name;


/* DEEP DIVE SELF JOIN

The self join is often used to query hierarchical data or to compare a row with other rows within the same table.
To perform a self join, you must use table aliases to not repeat the same table name twice in a single query. 
Note that referencing a table twice or more in a query without using table aliases will cause an error.
*/

-- To get the whole organization structure:
use classicmodels;
show columns from employees;
-- reportsto column is used to determine the manager id of an employee.
select * from employees limit 5;

/* // Result: LastName, FirstName (MiddleName)
CONCAT_WS( '', LastName, ', ', FirstName, ' (', MiddleName, ')' ) */

select 
	concat(e1.lastName, ', ', e1.firstName, '-', e1.jobTitle) as manager,
    concat_ws('', e2.lastName, ', ', e2.firstName, '-', e2.jobTitle) as director
from 
	employees as e1
    inner join employees as e2
    on e2.employeeNumber  = e1.reportsTo
order by manager;

--  you don’t see the President because his name is filtered out due to the INNER JOIN clause.
-- to make it happen use leftjoin and set the ifnull for the manager. 

select 
    ifnull(concat(m.lastName, ', ', m.firstName, '-', m.jobTitle), 'top manager') as manager,
    concat_ws('', e.lastName, ', ', e.firstName, '-', e.jobTitle) as 'direct report'
from 
	employees as e
    left join employees as m
    on m.employeeNumber  = e.reportsTo
order by manager DESC;


-- display a list of customers who locate in the same city by joining the customers table to itself.
SELECT 
    c1.city, 
    c1.customerName, 
    c2.customerName
FROM
    customers c1
INNER JOIN customers c2 ON 
    c1.city = c2.city
    AND c1.customername > c2.customerName -- ensures that no same customer is included
ORDER BY 
    c1.city;
    