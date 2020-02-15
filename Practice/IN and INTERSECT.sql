use classicmodels;
-- INTERSECT

/*
The INTERSECT operator is a set operator that returns only distinct rows of two queries or more queries.

(SELECT column_list 
FROM table_1)
INTERSECT
(SELECT column_list
FROM table_2);

Note that MySQL does not support the INTERSECT operator. 
This tutorial introduces you to how to emulate the INTERSECT operator in MySQL using join clauses.
*/

select id from t1;
select id from t2;

(select id from t1)
intersect
(select id from t2); -- this does not work cuz mysql does not provide intersect. Hence, gotta emulate it

-- emulating the intersect

-- option 1
select 
	id
from 
	t1
	inner join t2 using(id);
    
-- option 2
select 
	id
from 
	t1
where exists (
	select 
		id
	from 
		t2
	where
		t2.id = t1.id
    );

-- option 3: 
select 
	id
from 
	t1
where 
	id in (
		select id
        from t2);
        
        
-- IN 

/*
SELECT 
    column1,column2,...
FROM
    table_name
WHERE 
    (expr|column_1) IN ('value1','value2',...);
*/

-- find the offices that locate in the U.S. and France, you can use the IN operator as the following query:

select 
	officeCode, 
    city, 
    country
from 
	offices
where
	country in ('usa', 'france');

select 
	officeCode, 
    city, 
    country
from 
	offices
where
	country = 'usa' or country = 'france';
    
-- get offices that do not locate in USA and France, you use NOT IN  in the WHERE:
select 
	officeCode, 
    city, 
    country
from 
	offices
where
	country not in ('usa', 'france');
    
-- find the orders whose total values are greater than 60,000, you use the IN operator as shown in the following query:
select 
	orderNumber, 
    productCode,
    sum(priceEach * quantityOrdered) as total_value
from 
	orderdetails
group by
	orderNumber    
having 
	sum(priceEach * quantityOrdered) > 60000;
    
-- get the same but with differnt columns: orderNumber, customerNumber, status, shippedDate
select 
	orderNumber, 
    customerNumber, 
    status, 
    shippedDate -- ,
    -- sum(priceEach * quantityOrdered) as total_values
from 
	orders
where status = 'shipped' and
	orderNumber in 
    (select 
		orderNumber -- , 
        -- sum(priceEach * quantityOrdered) as total_values
	from 
		orderdetails
	group by
		orderNumber    
	having 
		sum(priceEach * quantityOrdered) > 60000);
		
-- get another table with everything same but with one more column total values: 

select 
	orderNumber, 
    customerNumber, 
    status, 
    shippedDate,
    sum(priceEach * quantityOrdered) as total_values
from 
	orders
    inner join orderdetails using(orderNumber)
group by 
	orderNumber  -- after group by i SHOULD NOT USE where but HAVING 
having 
	status = 'shipped' and 
    sum(priceEach * quantityOrdered) > 60000;
	
-- last option: run seperate 
SELECT 
    orderNumber
FROM
    orderDetails
GROUP BY 
    orderNumber
HAVING 
    SUM(quantityOrdered * priceEach) > 60000;
    
SELECT 
    orderNumber, 
    customerNumber, 
    status, 
    shippedDate
FROM
    orders
WHERE
    orderNumber IN (10165,10287,10310);
	