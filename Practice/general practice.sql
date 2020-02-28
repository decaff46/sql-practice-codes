use classicmodels;

# returns the customer who has the maximum payment: 
select * from payments limit 1; 

select 
	customerName,
    city,
	coalesce(state, 'unknown'), 
    amount
from 
	customers join payments using(customerNumber)
where 
	amount = (select max(amount) from payments);
    
# top 3 
select 
	customerName,
    city,
	coalesce(state, 'unknown'), 
    sum(amount) as total_amount
from 
	customers join payments using(customerNumber)
group by customerName
order by amount desc
limit 3;

# N highest for each customer
select * from payments limit 1; 

select 
	*
from 
	(
		select
			*, 
			dense_rank()over(partition by customerNumber order by amount desc) as rnk
		from 
			payments
	) temp
where rnk = 3;

# customers have more than 4 business
select 
	* 
from 
	(
		select 
			*, count(*) as count
		from 
			payments
		group by customerNumber
        order by 
			count desc
    ) as temp
having 
	count > 4;
    
# find customers whose payments are greater than the average payment:
select 
	* 
from 
	payments
where 
	amount > (select avg(amount) from payments);


# find the customers who have not placed any orders: 
select
	customerName
from 
	customers
where 
	customerNumber not in (select distinct customerNumber from orders);
    
# finds the maximum, minimum and average number of items in sale orders:
select 
	max(item), 
    min(item), 
    round(avg(item),0) -- floor(avg(item))
from 
	(
		select 
			count(orderNumber) as item
		from 
			orderdetails
		group by 
			orderNumber
	) as temp;
    
# select products whose buy prices are greater than the average buy price of all products in each product line:
select * from products limit 1; 
-- select * from productlines limit 1;
select 
	productName, buyPrice
from 
	products p1
where
	buyPrice > (select avg(buyPrice) from products p2 where p1.productLine = p2.productLine);
    
# gets the top 5 products by sales revenue in 2003 from the orders and orderdetails tables:
select o1.*, o2.* from orders o1, orderdetails o2 limit 2;
select 
	productCode, 
    sum(quantityOrdered * priceEach) as revenue
from 
	orders join orderdetails using(orderNumber)
where 
	year(orderDate) = 2003 
group by 
	productCode
order by revenue desc
limit 5;

# use the above table with products table to get the product name with revenue 
select * from products limit 1; 
select 
	productName, revenue
from 
	(
		select 
			productCode, 
			sum(quantityOrdered * priceEach) as revenue
		from 
			orders join orderdetails using(orderNumber)
		where 
			year(orderDate) = 2003 
		group by 
			productCode
		order by revenue desc
		limit 5
    ) temp join products using(productCode);
    
    /*
    Suppose you have to classify the customers in the year of 2003 into 3 groups: platinum, gold, and silver. In addition, you need to know the number of customers in each group with the following conditions:

    Platinum customers who have orders with the volume greater than 100K
    Gold customers who have orders with the volume between 10K and 100K
    Silver customers who have orders with the volume less than 10K
    */
select c.*, o.*from orders c, orderdetails o limit 1; -- to get the customer name i need customers table, which i will deal with later

# first get the customer_rank! then use this table to derive the requested table
select 
	customerNumber, 
	sum(quantityOrdered * priceEach) as sales,
	(case 
		when sum(quantityOrdered * priceEach) < 10000 then 'Silver'
		when sum(quantityOrdered * priceEach) between 10000 and 100000 then 'Gold'
		when sum(quantityOrdered * priceEach) > 100000 then 'Plat'
	end
	) as customer_rank
from 
	orders join orderdetails using(orderNumber)
where
	year(orderDate) = 2003
group by 
	customerNumber;
    
select * from customers limit 1;

# counting the number of customers in each rank
select 
	customer_rank,
    count(customer_rank) as group_count
from 
	(select 
	customerNumber, 
	sum(quantityOrdered * priceEach) as sales,
	(case 
		when sum(quantityOrdered * priceEach) < 10000 then 'Silver'
		when sum(quantityOrdered * priceEach) between 10000 and 100000 then 'Gold'
		when sum(quantityOrdered * priceEach) > 100000 then 'Plat'
	end
	) as customer_rank
	from 
		orders join orderdetails using(orderNumber)
	where
		year(orderDate) = 2003
	group by 
		customerNumber) as temp
group by 
	customer_rank; 

# get the customer name with corresponding rank and sales:
select 
	customerName, 
    customer_rank, 
    sales
from 
	(select 
	customerNumber, 
	sum(quantityOrdered * priceEach) as sales,
	(case 
		when sum(quantityOrdered * priceEach) < 10000 then 'Silver'
		when sum(quantityOrdered * priceEach) between 10000 and 100000 then 'Gold'
		when sum(quantityOrdered * priceEach) > 100000 then 'Plat'
	end
	) as customer_rank
from 
	orders join orderdetails using(orderNumber)
where
	year(orderDate) = 2003
group by 
	customerNumber) as temp join customers using(customerNumber);
    
