use classicmodels;

## ROW_NUMBER()
/*
The ROW_NUMBER() is a window function or analytic function that assigns a sequential number 
to each row to which it applied beginning with one.

ROW_NUMBER() OVER (<partition_definition> <order_definition>)

** partition  
	PARTITION BY <expression>,[{,<expression>}...]
  --> The PARTITION BY clause breaks the rows into smaller sets. 
	  The expression can be any valid expression that would be used in the GROUP BY clause. 
	  You can use multiple expressions separated by commas.  
      
** order 
	ORDER BY <expression> [ASC|DESC],[{,<expression>}...]
-->  The purpose of the ORDER BY clause is to set the orders of rows. 
     This ORDER BY clause is independent of the ORDER BY clause of the query.
*/ 

-- assign a sequential number to each row from the products table:
select * from products;
select
	row_number() over( order by productName) as row_num, -- row_number() over로 같이 묶어서 써야함  
    productName, 
    msrp
from 
	products
order by productName; -- 이거는 딱히 영향을 미치지 않음 이미 over 에서 썼기때문에 
    
select
	row_number() over( order by productName) as row_num, 
    productName, 
    msrp
from 
	products
order by productName;

-- find the top N rows for every group, for example, top three sales employees of every sales channel, 
-- top five high-performance products of every category.
-- finds the top three products that have the highest inventory of every product line:

WITH inventory
AS (SELECT 
       productLine,
       productName,
       quantityInStock,
       ROW_NUMBER() OVER (
          PARTITION BY productLine 
          ORDER BY quantityInStock DESC) row_num
    FROM 
       products
   )
   
SELECT 
   productLine,
   productName,
   quantityInStock
FROM 
   inventory
WHERE 
   row_num <= 3; 
	
-- use the ROW_NUMBER() to turn non-unique rows into unique rows and then delete the duplicate rows. 

CREATE TABLE t (
    id INT,
    name VARCHAR(10) NOT NULL
);
 
INSERT INTO t(id,name) 
VALUES(1,'A'),
      (2,'B'),
      (2,'B'),
      (3,'C'),
      (3,'C'),
      (3,'C'),
      (4,'D');

select * from t;

-- find the duplicate: 
select 
	*
from t
group by name
having count(name) >1;

-- use the common table expression (CTE) to return the duplicate rows and delete statement to remove:
SET SQL_SAFE_UPDATES = 0; -- safe mode off

WITH dups AS (SELECT 
        id,
        name,
        ROW_NUMBER() OVER(PARTITION BY id, name ORDER BY id) AS row_num
    FROM t)
 
DELETE FROM t USING t JOIN dups ON t.id = dups.id
WHERE dups.row_num <> 1;

select * from t;

-- display a list of products with 10 products per page. To get the products for the second page:
SELECT *
FROM 
    (SELECT productName,
         msrp,
         row_number()
        OVER (order by msrp) AS row_num
    FROM products) t
WHERE row_num BETWEEN 11 AND 20; 