use leetcode; 

-- creating Employee table in Oracle
CREATE TABLE Employee (name varchar(10), salary int);

-- inserting sample data into Employee table
INSERT INTO Employee VALUES ('Rick', 3000);
INSERT INTO Employee VALUES ('John', 4000);
INSERT INTO Employee VALUES ('Shane', 3000);
INSERT INTO Employee VALUES ('Peter', 5000);
INSERT INTO Employee VALUES ('Jackob', 7000);

select * from Employee;

-- select the Nth highest!
select salary from Employee order by salary DESC limit 3; 

SELECT name, salary 
FROM Employee e1
WHERE 3-1 = (SELECT COUNT(DISTINCT salary) FROM Employee e2
WHERE e2.salary > e1.salary);
drop table employee;

