use leetcode; 
Create table If Not Exists Customers (Id int, Name varchar(255));
Create table If Not Exists Orders (Id int, CustomerId int);
Truncate table Customers;
insert into Customers (Id, Name) values ('1', 'Joe'),('2', 'Henry'),('3', 'Sam'),('4', 'Max');

Truncate table Orders;
insert into Orders (Id, CustomerId) values ('1', '3'),('2', '1');

-- Customers Who Never Order
SELECT 
	Customers.Name as Customers
FROM 
	Customers
WHERE
	Name NOT IN (select distinct
	Name
from 
	Customers INNER JOIN Orders on Customers.ID = Orders.CustomerId);    
## this case does not take care of the sitation when there is same name (ex. [ID. NAME]=> [1,James],[2,James])

## Answer 1
SELECT 
	Customers.Name as Customers
FROM 
	Customers
WHERE
	Customers.Id NOT IN 
    (select distinct Customers.Id
from 
	Customers INNER JOIN Orders on Customers.Id = Orders.CustomerId);

## Answer 2
select customers.name as 'Customers'
from customers
where customers.id not in
(
    select customerid from orders
);

## Answer 3
SELECT Name AS Customers
FROM Customers AS c
	LEFT JOIN Orders AS o ON c.Id = o.CustomerId
WHERE o.CustomerId is null;