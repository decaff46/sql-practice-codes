-- WITH ROLLUP?
use classicmodels;


-- creates a new table named sales that stores the order values summarized by product lines and years. 
-- The data comes from the products, orders, and orderDetails tables 
show columns from products; show columns from orders; show columns from orderdetails;

create table if not exists sales
select 
	productLine, 
    year(orderDate), -- as year forgot!! 
    quantityOrdered * priceEach as quantity
from 
	orders inner join orderdetails using(orderNumber)
    inner join products using(productCode)
group by
	productLine, 
    year(orderDate);

show columns from sales;
 -- update table sales set xxx : this is for change the tuples not the column names
ALTER TABLE sales RENAME COLUMN `year(orderDate)` to `year`; -- this works ! ignore the error msg
show columns from sales;

select * from sales;

-- creates a grouping set denoted by (productline):
SELECT 
    productline, 
    SUM(quantity) totalOrderValue
FROM
    sales
GROUP BY 
    productline;

-- drop table classicmodels.sales; -- testing code!

SELECT 
    SUM(quantity) totalOrderValue
FROM
    sales;

-- If you want to generate two or more grouping sets together in one query, you may use the UNION ALL operator as follows:
SELECT 
    productline, 
    SUM(quantity) totalOrderValue
FROM
    sales
GROUP BY 
    productline 
UNION ALL
SELECT 
    NULL, 
    SUM(quantity) totalOrderValue
FROM
    sales;
    
/* Because the UNION ALL requires all queries to have the same number of columns,
 we added NULL in the select list of the second query to fullfil this requirement */
 
 /*
 This query is able to generate the total order values by product lines and also the grand total row. However, it has two problems:

    The query is quite lengthy.
    The performance of the query may not be good since the database engine has to internally execute two separate queries 
    and combine the result sets into one.

To solve those issues, you can use the ROLLUP clause.

The ROLLUP clause is an extension of the GROUP BY clause with the following syntax:

SELECT 
    select_list
FROM 
    table_name
GROUP BY
    c1, c2, c3 WITH ROLLUP;
 */
 
 -- ROLLUP
SELECT 
    productLine, 
    SUM(quantity) totalOrderValue
FROM
    sales
GROUP BY 
    productline WITH ROLLUP;
    
/*
As clearly shown in the output, the ROLLUP clause generates not only the subtotals but also the grand total of the order values.

If you have more than one column specified in the GROUP BY clause, the ROLLUP clause assumes a hierarchy among the input columns.
For example:
	
GROUP BY c1, c2, c3 WITH ROLLUP

The ROLLUP assumes that there is the following hierarchy:
	
c1 > c2 > c3

And it generates the following grouping sets:

(c1, c2, c3)
(c1, c2)
(c1)
()

And in case you have two columns specified in the GROUP BY clause:
GROUP BY c1, c2 WITH ROLLUP

then the ROLLUP generates the following grouping sets:	
(c1, c2)
(c1)
()
*/

show columns from sales;

SELECT 
    productLine, 
    year,
    SUM(quantity) totalOrderValue
FROM
    sales
GROUP BY 
    productLine, 
    year 
WITH ROLLUP; -- The ROLLUP generates the subtotal row every time the product line changes and the grand total at the end of the result.
-- here productLine > year

-- change the hierchial order to year > productLine

SELECT 
    productLine, 
    year,
    SUM(quantity) totalOrderValue
FROM
    sales
GROUP BY 
	year,
    productLine 
WITH ROLLUP;

-- To check whether NULL in the result set represents the subtotals or grand totals, you use the GROUPING() function.

SELECT 
    productLine, 
    year,
    SUM(quantity) totalOrderValue,
    grouping(year), 
    grouping(productLine)
FROM
    sales
GROUP BY 
	year,
    productLine 
WITH ROLLUP;

-- use GROUPING() function to substitute meaningful labels for super-aggregate NULL values instead of displaying it directly.
-- combine the IF() function with the GROUPING() function to substitute labels for the 
-- super-aggregate NULL values in orderYear and productLine columns:

SELECT 
	if(grouping(year), 'all years', year) as year,
    if(grouping(productLine), 'all productLines', productLine) as productLine, 
    SUM(quantity) totalOrderValue
FROM
    sales
GROUP BY 
	year,
    productLine 
WITH ROLLUP;

