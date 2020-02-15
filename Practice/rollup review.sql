use classicmodels; 

/* creates a new table named sales that stores the order values summarized by product lines and years. 
The data comes from the products, orders, and orderDetails tables in the sample database. */

show columns from products; 
select * from products limit 1; 
select * from orders limit 1; 
select * from orderDetails limit 1;

drop table sales;

CREATE TABLE sales (
	SELECT 
		ProductLine, 
        YEAR(orderDate) AS orderYear,
        SUM(quantityOrdered * priceEach) AS orderValue
	FROM 
		products INNER JOIN orderDetails USING(productCode)
			INNER JOIN orders USING(orderNumber)
	GROUP BY 
		productLine, 
        YEAR(orderDate)
); 
        
select * from sales; 		

-- creates a grouping set denoted by (productline)
SELECT 
	productLine, 
    SUM(orderValue) as totalOrder
FROM 
	sales
GROUP BY
	productLine; 
    
--  generate two or more grouping sets together in one query, you may use the UNION ALL operator as follows:
SELECT 
	productLine, 
	SUM(orderValue) as total 
FROM 
	sales 
GROUP BY 
	productLine
    
UNION ALL 

SELECT 
	NULL, -- it is needed becasue UNION ALL requires the same number of columns
    SUM(orderValue) as total 
FROM 
	sales; 


-- do this roll up 
SELECT 
	productLine, 
    SUM(orderValue) as total 
FROM 
	sales
GROUP BY 
	productLine WITH ROLLUP; 

SELECT 
	productLine, 
    orderYear,
    SUM(orderValue) as total 
FROM 
	sales
GROUP BY 
	productLine, orderYear WITH ROLLUP; 


## ROLLUP generates the subtotal every time the year changes and the grand total at the end of the result set.
--  check whether NULL in the result set represents the subtotals or grand totals, you use the GROUPING() function.

SELECT 
	productLine, 
    orderYear, 
    SUM(orderValue) as total ,
    GROUPING(orderYear), 
    GROUPING(productLine)
FROM 
	sales
GROUP BY 
	orderYear, 
    productLine WITH ROLLUP; 
    
-- shows how to combine the IF() function with the GROUPING() function to substitute labels for the super-aggregate NULL values in orderYear and productLine columns:
SELECT 
	IF(GROUPING(orderYear), 'All Years', orderYear) as orderYear, 
    IF(GROUPING (productLine), 'All Product Line', productLine) as ProductLine,
    SUM(orderValue) as 'Total Value'
FROM 
	sales
GROUP BY 
	productLine, 
    orderYear WITH ROLLUP; 

SELECT 
	IF(GROUPING(orderYear), 'All Years', orderYear) as orderYear, 
    IF(GROUPING (productLine), 'All Product Line', productLine) as ProductLine,
    SUM(orderValue) as 'Total Value'
FROM 
	sales
GROUP BY 
	orderYear, productLine WITH ROLLUP;
    