-- DELETE JOIN
use classicmodels;
DROP TABLE IF EXISTS t1, t2;
 
 
 /*
DELETE T1, T2
FROM T1
INNER JOIN T2 ON T1.key = T2.key
WHERE condition;
 */
 
CREATE TABLE t1 (
    id INT PRIMARY KEY AUTO_INCREMENT
);
 
CREATE TABLE t2 (
    id VARCHAR(20) PRIMARY KEY,
    ref INT NOT NULL
);
 
INSERT INTO t1 VALUES (1),(2),(3);
select * from t1;
 
INSERT INTO t2(id,ref) VALUES('A',1),('B',2),('C',3);
select * from t2;

/* 
create table t3 like t1;
select * from t3;
insert into t3 select * from t1 where id = 1;
select * from t3;
drop table t3;
*/

-- deletes the row with id 1 in the t1 table and also row with ref 1 in the t2 table using DELETE...INNER JOIN statement:
delete t1 
	inner join t2 t1.id = t2.ref
where id = 1; -- UPDATE 와 같은 방식으로 하는 건 불가능 함! 

-- must be following structure: 
DELETE T1, T2
FROM T1
INNER JOIN T2 ON T1.key = T2.key
WHERE condition;

delete 
	t1, t2
from
	t1 inner join t2 on t1.id = t2.ref
where t1.id = 1;

-- delete rows from T1 table that does not have corresponding rows in the T2 table:
delete t1
from t1 
	left join t2 on t1.id = t2.ref
where t2.ref is null;

select * from t1;
select t1.id from t1 left join t2 on t1.id = t2.ref where t2.ref is null;


-- use DELETE statement with LEFT JOIN clause to clean up our customers master data. removes customers who have not placed any order:
create table if not exists customers_test select * from customers;
select* from customers_test;
alter table customers_test rename customers_clean;

delete 
	customers_clean
from 
	customers_clean left join orders using(customerNumber)
 where orderNumber is null;   
 
-- verify the delete by finding whether  customers who do not have any order exists: 

select
	customerName, 
    customerNumber, 
    orderNumber
from 
	customers left join orders using(customerNumber)
where 
	orderNumber is NULL;
    