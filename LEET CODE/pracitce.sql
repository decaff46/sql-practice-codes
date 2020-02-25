#create database interview;
use interview; 


# get the first 3
select substring('hello world!', 1,3);

# get the last 3
select substring('hello world!', -3);

create table managers(
	ID INT auto_increment primary key, 
    NAME varchar(30) not null, 
    SALARY int not null
);

#select * from managers; 

insert into managers (NAME, SALARY) values 
('Harpett', 20000), 
("Ravi", 30000), 
("Vinay", 10000), 
('Ravi', 30000), 
('Harpett', 20000), 
('Vinay', 10000), 
('Rajeev', 40000), 
('Ravi', 30000); 
	
 select * from managers;
# show uniq: 
select distinct NAME, SALARY  from managers; 
-- in this case, i cannot simply use distinct * because ID is uniq 
-- sql will take all of them as uniq due to the id

# to show the table with all fields: 
## using row_number() over()
select * 
from
(select *,
row_number( ) over (partition by Name order by Id desc) as rn
from managers) base0
where rn = 1;

# fine the only one with no duplicates:   
select * 
from managers
group by NAME
having count(name) =1;

select *
from managers
where name not in 
(select 
	distinct m1.name
from 
	managers m1, managers m2
where 
	m1.NAME = m2.NAME and m1.ID > m2.ID);

# delete the duplicates! 

SET SQL_SAFE_UPDATES = 0; -- this is for dealing with the safe mode! 
delete m1
from managers m1, managers m2
where m2.name = m1.name and m1.ID > m2.ID; 

select * from managers; 

# drop table managers; 

create table employee(
	id int auto_increment primary key, 
    fname varchar(20), 
    sname varchar(20), 
    lname varchar(20), 
    salary int
); 

insert into employee (fname, sname, lname, salary) values
('har', 'preet', 'singh', 30000), 
('ashu', NULL, 'rana', 50000), 
(NULL, 'vinay', 'thakur', 40000), 
(NULL, 'vinay', NULL, 10000), 
(NULL, NULL, 'rajveer', 60000), 
('manjeet', 'singh', NULL, 60000);

select * from employee; 
# Finding the name of Employees where First Name, Second Name and Last Name are all given: 
select fname, sname, lname
from employee
where 
	fname is not null and 
	sname is not null and 
	lname is not null; 

# find the name regardless of the name is fname, sname, lname:
SELECT ID, COALESCE(FName, SName, LName) as Name 
FROM employee; 

# Finding the Employees who have been hire in the last n years. Here we get desire output by using TIMESTAMPDIFF() mysql function.
Select *, TIMESTAMPDIFF (year, Hiredate, current_date()) as DiffYear 
From employees
Where TIMESTAMPDIFF (year, Hiredate, current_date()) between 1 and 4 
order by Hiredate desc;

# same but days 
Select *, DATEDIFF (current_date(), Hiredate) as DiffDay 
From employees
Where DATEDIFF (current_date(), Hiredate) between 1 and 100 
order by Hiredate desc; 

# same but month: 
Select *, TIMESTAMPDIFF (month, Hiredate, current_date()) as DiffMonth 
From employees
Where TIMESTAMPDIFF (month, Hiredate, current_date()) 
Between 1 and 5 
Order by Hiredate desc; 

create table logs(
	id int primary key auto_increment, 
    num int
); 

insert into logs (num) values
(1), (1), (1), (2),(2),(1),(1);

select * from logs; 

# find 3 consectutive:


select distinct Num 
from 
	(select *, (id -
			row_number() over (partition by Num order by id)
			) as rn
	from logs as temp) as temp
group by rn, Num
having count(*) >= 3;

## simply using where by comparing num and id 
select 
	distinct a.num 
from 
	logs a, logs b, logs c
where 
	a.num = b.num 
    and b.num = c.num
    and a.id = b.id -1 
    and b.id = c.id -1; 
    
# using joins
select 
	distinct a.num
from 
	logs a 
		join logs b on a.num = b.num  and a.id = b.id -1
			join logs c on a.num = c.num and a.id = c.id -2;
drop table if exists employee ; 
create table employee(
	id int primary key auto_increment, 
    name varchar(20), 
    salary int, 
    department int
); 

insert into employee (name, salary, department) values
('joe', 7000, 1), 
('jim', 9000, 1),
('henry', 8000, 2), 
('sam', 6000, 2),
('max', 9000, 1);

create table department(
	id int, 
    name varchar(20)
); 

insert into department values
(1,'it'), (2, 'sales');

# find employees who have the highest salary in each of the departments:
select 
    d.name as Department, e.name as Employee, e.salary 
from 
    (select *, dense_rank()over(partition by Department order by salary desc) as rnk 
     from employee) as e 
     join department as d on e.department = d.Id
where
    rnk = 1; 
    
# same but with no rank() over()
select 
    d.name as Department, e.name as Employee, e.Salary 
from 
    employee as e inner join department as d on e.department = d.Id
where 
    (department, salary) in 
    (select department, max(salary) from employee group by department);

## Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows (order of rows does not matter):


# first update the table
update employee
set salary = 8500
where name = 'joe';

# add new ppl
insert into employee (name, salary, department) values
('janet', 6900, 1), 
('randy', 8500, 1), 
('will', 7000, 1);

select 
	d.name as department, 
    e.name as employee, 
    e.salary
from 
	(select *, 
	dense_rank() over(partition by department order by salary desc) as rnk
    from employee) as e 
		join department as d on e.department = d.id
where
	rnk <=3;
    
    
SELECT 
    b.Name AS Department, 
    a.Name AS Employee, 
    Salary
FROM 
    Employee a 
    JOIN Department b ON a.Department = b.Id
WHERE 3 > (SELECT COUNT(DISTINCT Salary) 
           FROM Employee c 
           WHERE c.Salary > a.Salary AND c.Department = a.Department); 