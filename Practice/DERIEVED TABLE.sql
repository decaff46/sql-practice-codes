 -- DERIVED TABLE
 
 use classicmodels;
 /*
 A derived table is a virtual table returned from a SELECT statement. 
 A derived table is similar to a temporary table, but using a derived table in 
 the SELECT statement is much simpler than a temporary table 
 because it does not require steps of creating the temporary table.
 
 Unlike a subquery, a derived table must have a an alias so that you can reference its name later in the query.
 */
 
 -- gets the top 5 products by sales revenue in 2003 from the orders and orderdetails tables:
 
select 
	productCode, 
    round(sum(priceEach * quantityOrdered)) as `total sales` 
from 
	orderdetails
    inner join orders using(orderNumber)
where 
	year(orderDate) = 2003 -- year(shippedDate)
group by 
	productCode
order by 
	`total sales` DESC
limit 5;
 
-- use the result of this query as a derived table and join it with the products table:

select 
	productName,
    `total sales`
from 
	(
	select 
		productCode, 
		round(sum(priceEach * quantityOrdered)) as `total sales` 
	from 
		orderdetails
			inner join orders using(orderNumber)
	where 
		year(orderDate) = 2003 -- year(shippedDate)
	group by 
		productCode
	order by 
		`total sales` DESC
	limit 5	
    ) as top5tab 
    inner join products using(productCode);


/* 
Suppose you have to classify the customers in the year of 2003 into 3 groups: platinum, gold, and silver. In addition, you need to know the number of customers in each group with the following conditions:

    Platinum customers who have orders with the volume greater than 100K
    Gold customers who have orders with the volume between 10K and 100K
    Silver customers who have orders with the volume less than 10K
*/

select 
	customerNumber, 
    round(sum(priceEach * quantityOrdered)) as sales, -- sales는 그냥 칼럼 이름이 되는 것이지 when 에서는 쓸수가 없다 
	(case
		when sum(priceEach * quantityOrdered) > 100000 then 'plat'
        when sum(priceEach * quantityOrdered) between 10000 and 100000 then 'gold'
        when sum(priceEach * quantityOrdered) < 10000 then 'silver'
     end) as `customer group` 
from
	orderdetails 
	inner join orders using(orderNumber)
where 
	year(orderDate) = 2003
group by 
	customerNumber;


-- count the ppl by the level 
create table if not exists customerLevel
	select 
	customerNumber, 
    round(sum(priceEach * quantityOrdered)) as sales, -- sales는 그냥 칼럼 이름이 되는 것이지 when 에서는 쓸수가 없다 
	(case
		when sum(priceEach * quantityOrdered) > 100000 then 'plat'
        when sum(priceEach * quantityOrdered) between 10000 and 100000 then 'gold'
        when sum(priceEach * quantityOrdered) < 10000 then 'silver'
     end) as `customer group` 
from
	orderdetails 
	inner join orders using(orderNumber)
where 
	year(orderDate) = 2003
group by 
	customerNumber;

describe customerLevel;
select 
	`customer group`, -- 'customer group' 이라고 하면 모든 칼럼이 customer group으로 채워짐 
	count(`customer group`)
from customerLevel
group by
	`customer group`;

drop table if exists customerLevel;

-- do it by derived table : 
select 
	customerGroup, 
    count(cg.customerGroup) as groupCount
from 
	(select
		customerNumber, 
        round(sum(priceEach * quantityOrdered)) as sales, -- sales는 그냥 칼럼 이름이 되는 것이지 when 에서는 쓸수가 없다 
		(case
			when sum(priceEach * quantityOrdered) > 100000 then 'plat'
			when sum(priceEach * quantityOrdered) between 10000 and 100000 then 'gold'
			when sum(priceEach * quantityOrdered) < 10000 then 'silver'
		end) as `customerGroup` 
	from
		orderdetails 
		inner join orders using(orderNumber)
	where 
		year(orderDate) = 2003
	group by 
		customerNumber
	) as cg
group by
	customerGroup;
    
