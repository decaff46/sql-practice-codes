USE classicmodels;

## EXPORTING TABLE TO CSV
show tables from classicmodels;

-- selects cancelled orders from the  orders table:
select * from orders limit 1;
select distinct(status) from orders;

-- Answer: 
select 
	orderNumber, status, orderDate, requiredDate, comments
from 
	orders
where 
	status = "Cancelled";
    
-- Export the table to csv
SELECT 
    orderNumber, status, orderDate, requiredDate, comments
FROM
    orders
WHERE
    status = 'Cancelled' 
INTO OUTFILE 'C:/tmp/cancelled_orders.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ';' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n';

## export the whole orders table into a CSV file with timestamp as a part of the file name.
SET @TS = DATE_FORMAT(NOW(),'_%Y_%m_%d_%H_%i_%s');
 
SET @FOLDER = 'c:/tmp/';
SET @PREFIX = 'orders';
SET @EXT    = '.csv';
 
SET @CMD = CONCAT("SELECT * FROM orders INTO OUTFILE '",@FOLDER,@PREFIX,@TS,@EXT,
                   "' FIELDS ENCLOSED BY '\"' TERMINATED BY ';' ESCAPED BY '\"'",
                   "  LINES TERMINATED BY '\r\n';");
 
PREPARE statement FROM @CMD;
 
EXECUTE statement;



## Exporting data with column headings
/* 
It would be convenient if the CSV file contains the first line as the column headings so that the file is more understandable.
To add the column headings, you need to use the UNION statement as follows:
*/

(SELECT 'Order Number','Order Date','Status')
UNION 
(SELECT orderNumber,orderDate, status
FROM orders
INTO OUTFILE 'C:/tmp/orders.csv'
FIELDS ENCLOSED BY '"' TERMINATED BY ';' ESCAPED BY '"'
LINES TERMINATED BY '\r\n');

## Handling NULL values
/*
In case the values in the result set contain NULL values, the target file will contain  "N instead of NULL. 
To fix this issue, you need to replace the NULL value by another value e.g., not applicable ( N/A ) 
by using the IFNULL function as the following query:
*/
SELECT 
    orderNumber, orderDate, IFNULL(shippedDate, 'N/A')
FROM
    orders INTO OUTFILE 'C:/tmp/orders2.csv' 
    FIELDS ENCLOSED BY '"' 
    TERMINATED BY ';' 
    ESCAPED BY '"' LINES 
    TERMINATED BY '\r\n';