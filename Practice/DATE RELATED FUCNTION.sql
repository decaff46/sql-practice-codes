use classicmodels; 

## DATE RELATED FUNCTION

-- current date: 
select curdate();

select curdate() +0; 
select 
	current_date(), 
    current_date, 
    curdate();
    
-- CURDATE vs. NOW
/*
The CURDATE() function returns the current date with date part only 
while the NOW() function returns both date and time parts of the current time.
*/

set @now = date(now()); 
set @cur_date = curdate();
select @now, @cur_date;

## DATEDIFF()
/*
The MySQL DATEDIFF function calculates the 
number of days between two  DATE,  DATETIME, or TIMESTAMP values.

DATEDIFF(date_expression_1,date_expression_2);
*/
-- ex) 
select datediff(date(now()), '1987-04-06');
-- calculate the number of days between the required date and shipped date of the orders:

select * from orders;
select 
	orderNumber,
    datediff(requiredDate, orderDate) as daysLeft
from 
	orders
order by daysLeft DESC;

-- gets all orders whose statuses are in-process and calculates the number of days between ordered date and required date:
select distinct status from orders;
select 
	orderNumber, 
    datediff(requiredDate, orderDate) as daysLeft
from
	orders
where 
	status = "In Process"
order by orderNumber;

-- calculating an interval in week or month:
select 
	orderNumber, 
    round(datediff(requireddate, orderdate) / 7,2) as weekly, 
    round(datediff(requireddate, orderdate) / 30, 2) as monthly
from orders;

## DAY() == DAYOFMONTH()
set @date = '0000-00-00';
select DAY(@date); -- here 0 is NULL
SELECT DAY('2010-01-15');

-- get the number of days in a month of a date: 
select day(last_day('2016-02-11'));
 -- select day(first_day('2016-02-11'));

-- uses the DAY() function to return the number of orders by day number in 2003: 
select * from orders;
select
	count(orderNumber), 
    day(orderDate) as dayofmonth
from 
	orders
where 
	year(orderDate) = 2003
group by dayofmonth
order by dayofmonth;

## DATE_ADD()
/*
DATE_ADD(start_date, INTERVAL expr unit);

The expr is treated as a string, therefore, you should be careful when you use a non-string value for the expr. 
For example, with an interval of HOUR_MINUTE, 5/2 evaluates to 2.5000 (not 2.5) 
and is treated as 2 hours 5000 minutes
*/
SELECT 
    DATE_ADD('1999-12-31 23:59:59',
        INTERVAL 1 SECOND) result;

SELECT 
    DATE_ADD('1999-12-31 23:59:59',
        INTERVAL 1 day) result;
-- 1 minute and 1 second
SELECT 
    DATE_ADD('1999-12-31 23:59:59',
        INTERVAL '1:1' minute_second) result;	
-- 1 day and 1 second
select 
	date_add('1999-12-31 23:59:59', 
		interval '1:1' day_second) result;
-- Add -1 day and 5 hours to
select 
	date_add('2000-01-01 00:00:00', 
		interval '-1:5' day_hour) result;
-- Add 1 second and 999999 microseconds
select
	date_add('1999-12-31 23:59:59.000002',
        INTERVAL '1.999999' SECOND_MICROSECOND) result;
select 
	date_add('2000-01-01',
        INTERVAL 5 / 2 HOUR_MINUTE) result; -- 2.5000. THat is 2 hrs 5000 min
-- To ensure the correct interpretation of a non-string interval value, use the CAST function as follows:
select 
	date_add('2000-01-01',
        INTERVAL cast(5 / 2 as decimal(3,1)) HOUR_MINUTE) result;
select cast(5/2 as decimal(3,1)); -- 2.5

## DATE_SUB()
/*
DATE_SUB(start_date,INTERVAL expr unit)
*/
SELECT DATE_SUB('2017-07-03',INTERVAL -1 DAY) result; -- THIS BECOMES +


## DATE_FORMAT()
-- select the order’s data and format the date value: 
select 
	date_format(orderdate, "%Y-%m-%d") orderDate, 
    date_format(requiredDate, '%a %D %b %Y') requiredDate, 
    DATE_FORMAT(shippedDate, '%W %D %M %Y') shippedDate
FROM orders;

SELECT 
    orderNumber,
    DATE_FORMAT(shippeddate, '%W %D %M %Y') shippeddate
FROM
    orders
WHERE
    shippeddate IS NOT NULL
ORDER BY shippeddate;
-- this way will fuck up the order by because shippeddate is used as alias. 

SELECT 
    orderNumber,
    DATE_FORMAT(shippeddate, '%W %D %M %Y') as 'shipped date'
FROM
    orders
WHERE
    shippeddate IS NOT NULL
ORDER BY shippeddate;


## DAYNAME()
SELECT DAYNAME('2000-01-01') dayname;
SELECT @@lc_time_names;
SET @@lc_time_names = 'fr_FR';
SELECT @@lc_time_names;
SELECT DAYNAME('2000-01-01') dayname;
SET @@lc_time_names = 'en_US';

## DAYOFWEEK()
SELECT DAYNAME('2012-12-01'), DAYOFWEEK('2012-12-01');

## EXTRACT()
/*
EXTRACT(unit FROM date)
   UNIT LIST:  
    DAY
    DAY_HOUR
    DAY_MICROSECOND
    DAY_MINUTE
    DAY_SECOND
    HOUR
    HOUR_MICROSECOND
    HOUR_MINUTE
    HOUR_SECOND
    MICROSECOND
    MINUTE
    MINUTE_MICROSECOND
    MINUTE_SECOND
    MONTH
    QUARTER
    SECOND
    SECOND_MICROSECOND
    WEEK
    YEAR
    YEAR_MONTH
*/
SELECT EXTRACT(DAY_hour from '2020-04-06 09:04:44') AS day; -- 609 day:6, hour: 09

## LAST_DAY()
SELECT LAST_DAY(CURDATE() + INTERVAL 1 MONTH);
SELECT LAST_DAY(CURDATE());
SELECT LAST_DAY(NOW());

--  illustrates how to get the first day of the month of 2017-07-14:
SELECT 
	DATE_SUB(DATE_ADD(LAST_DAY('2017-07-14'), INTERVAL 1 DAY), INTERVAL 1 MONTH) AS first_JULY;
    
-- develop a stored function named FIRST_DAY() as follows:
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$
 
CREATE FUNCTION first_day2(dt DATETIME) RETURNS date
BEGIN
    RETURN DATE_sub(DATE_ADD(LAST_DAY(dt),
                INTERVAL 1 DAY),
            INTERVAL 1 MONTH);
END $$ 

DELIMITER ;
 -- show warnings;
select first_day2('2017-02-15');


## NOW()
CREATE TABLE tmp(
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    created_on DATETIME NOT NULL DEFAULT NOW() -- or CURRENT_TIMESTAMP
);

INSERT INTO tmp(title)
VALUES('Test NOW() function');
select * from tmp;

-- gets the order’s volume by month in 2004: 
select * from orders; 
select distinct status from orders;
select * from orderdetails limit 1;
select 
	month(orderDate) as month_yr,
    round( sum(quantityOrdered * priceEach), 2) as volume
from orders inner join orderdetails using (orderNumber)
where year(orderDate) = 2004 -- and status in ('Shipped', 'In Process') this is not needed orderdetails take care
group by month_yr
order by month_yr; 

## STR_TO_DATE()
/*
STR_TO_DATE(str,fmt);

STR_TO_DATE() function ignores extra characters at the end of the input string 
sets all incomplete date values, which are not provided by the input string, to zero
it does time too 
*/    
SELECT STR_TO_DATE('21,5,2013','%d,%m,%Y');
SELECT STR_TO_DATE('21,5,2013 EXTRA WORDS','%d,%m,%Y');
SELECT STR_TO_DATE('2013','%Y');
SELECT STR_TO_DATE('113005','%h%i%s');
SELECT STR_TO_DATE('11','%h');	
SELECT STR_TO_DATE('20130101 1130','%Y%m%d %h%i') ;

## SYSDATE() 
SELECT NOW(), SLEEP(5), NOW(); -- time is constant ! after sleep 
SELECT SYSDATE(), SLEEP(5), SYSDATE(); -- time changed after sleep 

CREATE TABLE tests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    t DATETIME UNIQUE
);
 
 
INSERT INTO tests(t) 
WITH recursive times(t) AS 
( 
    SELECT now() - interval 1 YEAR as t
        UNION ALL 
    SELECT t + interval 1 hour
    FROM times
    WHERE t < now() 
)
SELECT t
FROM times;

show warnings;
set @@cte_max_recursion_depth = 100000; 

select 
	id, t
from tests
where t >= SYSDATE()- interval 1 day; 

## TIMEDIFF()  from -838:59:59 to 838:59:59.
SELECT TIMEDIFF('12:00:00','10:00:00') diff;
SELECT TIMEDIFF('2010-01-01 01:00:00','2010-01-02 01:00:00') diff;
-- IT AUTOMATICALLY TRUNCATE THE VALUES IF A VAL IS GREATER THAN MAX:
SELECT 
    TIMEDIFF('2009-03-01 00:00:00', 
             '2009-01-01 00:00:00') diff; 
SHOW WARNINGS; -- Truncated incorrect time value: '1416:00:00'
SELECT TIMESTAMPDIFF(
            HOUR, 
            '2009-01-01 00:00:00', 
            '2009-03-01 00:00:00') diff;
            
## TIMESTAMPDIFF()
/*TIMESTAMPDIFF(unit,begin,end) -->   begin - end*/            
--  returns a difference of 2010-01-01 and 2010-06-01 in months:
SELECT TIMESTAMPDIFF(MONTH, '2010-01-01', '2010-06-01') AS month_diff;

CREATE TABLE persons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL
);

INSERT INTO persons(full_name, date_of_birth)
VALUES('John Doe', '1990-01-01'),
      ('David Taylor', '1989-06-06'),
      ('Peter Drucker', '1985-03-02'),
      ('Lily Smith', '1992-05-05'),
      ('Mary William', '1995-12-01'); 

select * from persons;
-- use the TIMESTAMPDIFF to calculate the ages of each person in the  persons table:
select 
	full_name, 
    date_of_birth,
    timestampdiff(year, date_of_birth, now()) as age
from persons; 
