use classicmodels; 

-- returns employees who work in offices located in the USA
select * from employees limit 1; 
select * from offices limit 1; 

SELECT 
	lastName, firstName
FROM 
	employees
WHERE 
	officecode IN (
			SELECT 
				officeCode
			FROM 
				offices
			WHERE 
				country = 'USA'
            );
            
-- returns the customer who has the maximum payment.
select * from payments limit 1;
select * from customers limit 1; 

SELECT 
	c.customerName,
    p.customerNumber, 
	p.checkNumber, 
    p.amount
FROM 
	payments as p INNER JOIN customers as c USING(customerNumber)
WHERE 
	p.amount = (SELECT MAX(amount) FROM payments); 
    
-- find customers whose payments are greater than the average payment using a subquery:
SELECT 
	c.customerName,
    p.customerNumber, 
	p.checkNumber, 
    p.amount
FROM 
	payments as p INNER JOIN customers as c USING(customerNumber)
WHERE 
	p.amount > (SELECT AVG(amount) FROM payments); 


-- find the customers who have not placed any orders
select * from orders limit 1; 
SELECT 
	customerNumber,
    customerName
FROM 
	customers 
WHERE
	customerNumber NOT IN 
	(
		SELECT DISTINCT customerNumber
        FROM orders
	); 
    
-- finds the maximum, minimum and average number of items in sale orders:
select * from orderdetails limit 1; 

SELECT 
	MAX(cnt), 
    MIN(cnt), 
    FLOOR(AVG(cnt))
FROM 
	(SELECT productCode, COUNT(orderNumber) as cnt
    FROM orderdetails
    GROUP BY orderNumber) as tmp; 
    
-- select products whose buy prices are greater than the average buy price of all products in each product line.
select * from products limit 1; 
-- SET @avg_price  = (select avg(buyprice) from products group by productLine); 이렇게 하면 NULL 값밖에 안나옴 리스트라서 

select @avg_price;  
SELECT
    productName, 
    productline, 
    buyPrice
FROM 
	products p1
WHERE
	buyPrice > (SELECT AVG(buyPrice) FROM products p2 WHERE p1.productLine = p2.productLine);
    
    
--  finds sales orders whose total values are greater than 60K: 
SELECT 
	orderNumber,
    SUM(quantityOrdered * priceEach) as 'total values'
FROM 
	orders JOIN orderdetails USING(orderNumber) 
GROUP BY 
	orderNumber
HAVING 
	SUM(quantityOrdered * priceEach) > 60000; 

-- find customers who placed at least one sales order with the total value greater than 60K by using the IN operator:
SELECT 
	customerName, 
    customerNumber
FROM 
	customers
WHERE customerNumber IN 
(
	SELECT 
		customerNumber
	FROM 
		orders JOIN orderdetails USING(orderNumber) 
	GROUP BY 
		orderNumber
	HAVING 
		SUM(quantityOrdered * priceEach) > 60000 
); 

-- same but using the EXISTS operator:
-- select count(*) from customers; 
SELECT 
	customerNumber, 
    customerName
FROM 
	customers
WHERE EXISTS 
(
	SELECT 
		orderNumber, SUM(priceEach * quantityOrdered) AS 'total values'
	FROM 
		orders JOIN orderdetails USING(orderNumber)
	WHERE -- 이거가 없으면 전부가 T가 되서 전체를 불러옴!!
		orders.customerNumber = customers.customerNumber
	GROUP BY 
		orderNumber
	HAVING 
		SUM(quantityOrdered * priceEach) > 60000 
); 


## SIDE NOTE on IN vs. EXISTS
/*
The query that uses the EXISTS operator is much faster than the one that uses the IN operator.

The reason is that the EXISTS operator works based on the “at least found” principle. The EXISTS stops scanning the table when a matching row found.

On the other hands, when the IN operator is combined with a subquery, MySQL must process the subquery first and then uses the result of the subquery to process the whole query.

The general rule of thumb is that if the subquery contains a large volume of data, the EXISTS operator provides better performance.

However, the query that uses the IN operator will perform faster if the result set returned from the subquery is very small.
*/

