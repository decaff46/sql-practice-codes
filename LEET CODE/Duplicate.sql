use leetcode; 
drop table if exists employee; 

Create table If Not Exists Person (Id int, Email varchar(255));
Truncate table Person;
insert into Person (Id, Email) values ('1', 'a@b.com'),('2', 'c@d.com'),('3', 'a@b.com');

select * from Person;

-- find all duplicate emails in a table named Person.
SELECT 
	Email
FROM 
	Person
GROUP BY
	Email
HAVING 
	COUNT(*) >1;