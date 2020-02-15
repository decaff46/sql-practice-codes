-- Q2.  Employees Earning More Than Their Managers:
Create table If Not Exists Employee (Id int, Name varchar(255), Salary int, ManagerId int);
Truncate table Employee;
show columns from Employee;

insert into Employee (Id, Name, Salary, ManagerId) 
values ('1', 'Joe', '70000', '3'),
('2', 'Henry', '80000', '4'),
('3', 'Sam', '60000', NULL),
('4', 'Max', '90000', NULL);

select * from employee;

## Answer 
select 
	emp.Name as 'Employee'
from 
	employee as emp,
    employee as man
where
	man.Salary < emp.Salary And emp.ManagerId = man.Id;
    
## Answer 2
select 
	emp.Name as Employee
from 
	employee as emp
where
	exists(
		select 
			1
		from 
			Employee
		where Id = emp.ManagerId AND emp.Salary > Salary);
        
## Answer 3
select 
	emp.Name as Employee
from 
	employee as emp join employee as man on emp.ManagerId = man.Id
where
	emp.Salary > man.Salary;
