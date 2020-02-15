use leetcode; 

Create table If Not Exists courses (student varchar(255), class varchar(255));
Truncate table courses;
insert into courses (student, class) values ('A', 'Math');
insert into courses (student, class) values ('B', 'English');
insert into courses (student, class) values ('C', 'Math');
insert into courses (student, class) values ('D', 'Biology');
insert into courses (student, class) values ('E', 'Math');
insert into courses (student, class) values ('F', 'Computer');
insert into courses (student, class) values ('G', 'Math');
insert into courses (student, class) values ('H', 'Math');
insert into courses (student, class) values ('I', 'Math');
-- extra 
insert into courses (student, class) values ('A', 'Computer');
insert into courses (student, class) values ('A', 'English');
insert into courses (student, class) values ("F", "Math"); 
insert into courses (student, class) values ("H", "English");
insert into courses (student, class) values ("I", "English");
insert into courses (student, class) values ("J", "English");

select * from courses;
select class, count(*) from courses group by class;


-- list out all classes which have more than or equal to 5 students.
-- fail
select 
	class
from 
	courses
group by 
	class
having count(*) >= 5; -- this does not take care of the duplicates in students

-- 
select 
	temp.class
from 
	(SELECT c1.*
FROM courses c1,
    courses c2
WHERE
    c1.student = c2.student) as temp
group by 
	temp.class
having count(class) >= 5; 

-- this case will only take care of the duplicate student
select 
	class
from 
	courses
where
    student in 
    (SELECT student from courses group by student having count(*) =1)
group by 
	class
having count(class) >= 5;  -- a has two classes enrolled but failed to count 
/*
{"headers": {"courses": ["student", "class"]}, 
"rows": {"courses": [
["A", "Math"], 
["B", "English"], 
["C", "Math"], 
["D", "Biology"], 
["E", "Math"], 
["F", "Math"], 
["G", "Math"], 
["H", "English"], 
["I", "English"], 
["J", "English"], 
["A", "English"]
]}}
*/

-- 
select 
	class
from 
	courses
group by 
	class
having count(distinct student) >= 5;


## answer 2
SELECT
    class
FROM
    (SELECT
        class, COUNT(DISTINCT student) AS num
    FROM
        courses
    GROUP BY class) AS temp_table
WHERE
    num >= 5;
