use leetcode;

CREATE TABLE students (id int, NAME VARCHAR(30));
CREATE TABLE packages (id int, salary INT);
CREATE TABLE friends (id int, friend_id INT);
INSERT INTO students values (1,'John');
INSERT INTO students values (2,'Arthur');
INSERT INTO students values (3,'Pete');

INSERT INTO packages values (1,1000);
INSERT INTO packages values (2,1200);
INSERT INTO packages values (3,800);

INSERT INTO friends values (1,2);
INSERT INTO friends values (2,3);
INSERT INTO friends values (3,1);

-- Write a query to output the names of those students whose best friends got offered a higher salary than them. Names must be ordered by the salary amount offered to the best friends. It is guaranteed that no two students got same salary offer.

select 
    *
from 
    students as s 
        inner join packages as p using(id)
        inner join friends as f using (id) -- left join works too 
        inner join packages as p2 on f.friend_id = p2.id -- left join works too 
where 
    p.salary < p2.salary
order by 
    p2.salary;
    