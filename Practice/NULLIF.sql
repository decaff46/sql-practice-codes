use classicmodels; 

# NULLIF <> IFNULL 
/*
NULLIF => 
CASE WHEN expression_1 = expression_2
   THEN NULL
ELSE
   expression_1
END;
*/

# get all orders created in June 2003
SELECT 
	orderNumber, orderDate, requiredDate, shippedDate, status
FROM 
	orders
WHERE 
	orderDate BETWEEN '2003-06-01' AND '2003-06-30';
    
# calculate the number of shipped orders / the number of cancelled orders in June 2003:
SELECT 
	SUM(IF(status = 'Shipped',1,0)) / SUM(IF(status = 'Cancelled',1,0))
FROM 
	orders
WHERE 
	orderDate BETWEEN '2003-06-01' AND '2003-06-30';
    -- nothing shows? 
Select status, COUNT(*) 
from (select * from orders where orderDate BETWEEN '2003-06-01' AND '2003-06-30') as a  
group by status; -- the reason was because there is no cancelled in 2003 june
# fix the above code
SELECT 
	SUM(IF(status = 'Shipped',1,0)) / NULLIF(SUM(IF(status = 'Cancelled',1,0)),0)
FROM 
	orders
WHERE 
	orderDate BETWEEN '2003-06-01' AND '2003-06-30'; 
-- SUM(IF(status = 'Cancelled',1,0) expression returns zero, which also makes the NULLIF(SUM(IF(status = 'Cancelled',1,0),0) expression returns a NULL
-- SELECT NULLIF(0,0);
