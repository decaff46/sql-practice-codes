use leetcode;

-- delete the duplicates: 

/*
select * from person;

select distinct
	id, Email
from 
	person;  -- 이렇게 하면 id 때문에 계속 불려짐 

select 
	id, email
from 
	person
group by 
	email 
having 
	count(email) = 1; -- 이렇게 하면 하나만 불러짐 
*/

SET SQL_SAFE_UPDATES = 0; -- safe mode off
DELETE p1 FROM person p1
INNER JOIN person p2 
WHERE 
    p1.id != p2.id AND -- or p1.id > p2.id
    p1.email = p2.email;


DELETE FROM Person WHERE Id NOT IN 
(SELECT * FROM(
    SELECT MIN(Id) FROM Person GROUP BY Email) as p);
select * from person;


## TO SHOW THE TABLE: 
select Id, Email 
from
(select *,
row_number( ) over (partition by Email order by Id desc) as row_rank
from Person) base0
where row_rank = 1;

SELECT p1.*
FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email AND p1.Id > p2.Id;

