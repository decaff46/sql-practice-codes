create database if not exists lect_4_pract;
use lect_4_pract;

CREATE TABLE course (
	course_id varchar(8),
	title varchar(50),
	dept_name varchar(20),
	credits numeric(2)
);

INSERT INTO course
VALUES ('BIO-301', 'Genetics', 'Biology', 4),
       ('CS-190', 'Game Design', 'Comp. Sci.', 4),
       ('CS-315', 'Robotics', 'Comp. Sci.', 3);

CREATE TABLE prereq (
	course_id varchar(8),
	prereq_id varchar(8)
);

INSERT INTO prereq
VALUES ('BIO-301', 'BIO-101'),
       ('CS-190', 'CS-101'),
       ('CS-347', 'CS-101');


--- --- ---

-- Join examples
SELECT * FROM course;
SELECT * FROM prereq;

-- Left Outer Join
SELECT *
FROM course NATURAL LEFT OUTER JOIN prereq;

select *
from course 
	left join prereq using(course_id);

SELECT *
FROM course
LEFT OUTER JOIN prereq
ON course.course_id = prereq.course_id;

-- Right Outer Join
SELECT *
FROM course NATURAL RIGHT OUTER JOIN prereq;

-- Full Outer Join
SELECT *
FROM course NATURAL FULL OUTER JOIN prereq;


-- Joined Relations – Examples
SELECT *
FROM course NATURAL RIGHT OUTER JOIN prereq;

SELECT *
FROM course FULL OUTER JOIN prereq USING (course_id);

SELECT *
FROM course INNER JOIN prereq
  ON course.course_id = prereq.course_id;

-- What is the difference between the above, and a natural join?
SELECT *
FROM course NATURAL JOIN prereq;

SELECT *
FROM course LEFT OUTER JOIN prereq
  ON course.course_id = prereq.course_id;

SELECT *
FROM course NATURAL RIGHT OUTER JOIN prereq;

SELECT *
FROM course FULL JOIN prereq USING (course_id);
-- FROM course FULL OUTER JOIN prereq USING (course_id);
