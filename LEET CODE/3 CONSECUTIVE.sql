USE leetcode;

Create table If Not Exists stadium (id int, visit_date DATE NULL, people int);
Truncate table stadium;
insert into stadium (id, visit_date, people) values ('1', '2017-01-01', '10');
insert into stadium (id, visit_date, people) values ('2', '2017-01-02', '109');
insert into stadium (id, visit_date, people) values ('3', '2017-01-03', '150');
insert into stadium (id, visit_date, people) values ('4', '2017-01-04', '99');
insert into stadium (id, visit_date, people) values ('5', '2017-01-05', '145');
insert into stadium (id, visit_date, people) values ('6', '2017-01-06', '1455');
insert into stadium (id, visit_date, people) values ('7', '2017-01-07', '199');
insert into stadium (id, visit_date, people) values ('8', '2017-01-08', '188');

select * from stadium;
delete from stadium where id = 5;

-- display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).
select 
	distinct s1.*
from 
	stadium as s1, stadium s2, stadium s3
where s1.people >= 100 
and(
	(s2.visit_date = date_add(s1.visit_date, interval 1 day) and s2.people >= 100) or
    (s3.visit_date = date_add(s2.visit_date, interval 1 day) and s3.people >= 100) 
)
order by 
	s1.id;
 
-- same as above
select distinct t1.*
from stadium t1, stadium t2, stadium t3
where t1.people >= 100 and t2.people >= 100 and t3.people >= 100
;

## Answer
select t1.* -- distinct 써야함 
from stadium t1, stadium t2, stadium t3
where t1.people >= 100 and t2.people >= 100 and t3.people >= 100
and
(
	(t1.id - t2.id = 1 and t1.id - t3.id = 2 and t2.id - t3.id =1)  -- t1, t2, t3
    or
    (t2.id - t1.id = 1 and t2.id - t3.id = 2 and t1.id - t3.id =1) -- t2, t1, t3
    or
    (t3.id - t2.id = 1 and t2.id - t1.id =1 and t3.id - t1.id = 2) -- t3, t2, t1
)
;

select distinct t1.*
from stadium t1, stadium t2, stadium t3
where t1.people >= 100 and t2.people >= 100 and t3.people >= 100
and
(
	(t1.id - t2.id = 1 and t1.id - t3.id = 2 and t2.id - t3.id =1)  -- t1, t2, t3
    or
    (t2.id - t1.id = 1 and t2.id - t3.id = 2 and t1.id - t3.id =1) -- t2, t1, t3
    or
    (t3.id - t2.id = 1 and t2.id - t1.id =1 and t3.id - t1.id = 2) -- t3, t2, t1
)
order by t1.id
;

SELECT DISTINCT S1.*
FROM stadium S1
JOIN stadium S2
JOIN stadium S3
ON ((S1.id = S2.id - 1 AND S1.id = S3.id -2)
OR (S3.id = S1.id - 1 AND S3.id = S2.id -2)
OR (S3.id = S2.id - 1 AND S3.id = S1.id -2))
WHERE S1.people >= 100
AND S2.people >= 100
AND S3.people >= 100
ORDER BY S1.id;


SELECT 
    id, visit_date, people
FROM 
    stadium
WHERE 
    3 <= (
        SELECT COUNT(s.people) 
        FROM stadium AS s
        WHERE 
            s.people >= 100
            AND s.id >= stadium.id
            AND s.id <= stadium.id+2
    ) 
    OR
    3 <= (
        SELECT COUNT(s.people) 
        FROM stadium AS s
        WHERE 
            s.people >= 100
            AND s.id >= stadium.id-1
            AND s.id <= stadium.id+1
    ) 
    OR
    3 <= (
        SELECT COUNT(s.people) 
        FROM stadium AS s
        WHERE 
            s.people >= 100
            AND s.id >= stadium.id-2
            AND s.id <= stadium.id
    )
order by id;