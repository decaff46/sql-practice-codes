use classicmodels;

-- update join

/*
UPDATE T1, T2,
[INNER JOIN | LEFT JOIN] T1 ON T1.C1 = T2. C1
SET T1.C2 = T2.C2, 
    T2.C3 = expr
WHERE condition

Let’s examine the MySQL UPDATE JOIN  syntax in greater detail:

    First, specify the main table ( T1 ) and the table that you want the main table to join to ( T2 ) after the UPDATE clause. 
    Notice that you must specify at least one table after the UPDATE  clause. 
    The data in the table that is not specified after the UPDATE  clause will not be updated.
    
    Next, specify a kind of join you want to use i.e., either INNER JOIN  or LEFT JOIN  and a join predicate. 
    The JOIN clause must appear right after the UPDATE clause.
    
    Then, assign new values to the columns in T1 and/or T2 tables that you want to update.
    
    After that, specify a condition in the WHERE clause to limit rows to rows for updating.
*/

/*
UPDATE T1, T2
SET T1.c2 = T2.c2,
      T2.c3 = expr
WHERE T1.c1 = T2.c1 AND condition

and 

UPDATE T1,T2
INNER JOIN T2 ON T1.C1 = T2.C1
SET T1.C2 = T2.C2,
      T2.C3 = expr
WHERE condition

are same
*/


--  use a new sample database named empdb in for demonstration by combining employees and merits

create database if not exists empdb;
use empdb;

-- create merits table
create table if not exists merits(
	performance int(11) not null, 
    percentage float not null, 
    primary key(performance)
);

insert into merits(performance, percentage)
values(1,0), (2,0.01), (3,0.03), (4,0.05), (5,0.08);

select * from merits;

-- create employee table
create table if not exists employees(
	emp_id int(11) not null auto_increment, 
	emp_name varchar(255) not null, 
    performance int(11) default null, 
    salary float default null, 
    primary key (emp_id), 
    constraint fk_performance foreign key(performance) references merits(performance)
);

INSERT INTO employees(emp_name,performance,salary)      
VALUES('Mary Doe', 1, 50000),
      ('Cindy Smith', 3, 65000),
      ('Sue Greenspan', 4, 75000),
      ('Grace Dell', 5, 125000),
      ('Nancy Johnson', 3, 85000),
      ('John Doe', 2, 45000),
      ('Lily Bush', 3, 55000);
select * from employees;

-- The merit’s percentages are stored in the merits table, therefore, 
-- you have to use the UPDATE INNER JOIN statement to adjust the salary of employees in the employees  table 
-- based on the percentage stored in the merits table.
-- link between the employees  and merit tables is the performance  field: 

update employees
	inner join merits on employees.performance  = merits.performance
set 
	salary = salary + salary * percentage;

select * from employees;

-- now company hires two more employees:
INSERT INTO employees(emp_name,performance,salary)
VALUES('Jack William',NULL,43000),
      ('Ricky Bond',NULL,52000);
      
/* 
To increase the salary for new hires, you cannot use the UPDATE INNER JOIN  statement 
because their performance data is not available in the merit  table. 
This is why the UPDATE LEFT JOIN  comes to the rescue.
*/

-- increase the salary for a new hire by 1.5%  using the following statement:
update employees
	left join merits using(performance)
set 
	salary = salary * 1.015
where 
	merits.percentage is null;
    
select * from employees;

delete from employees where emp_name = 'Jack William' or emp_name = 'Ricky Bond';

/* 
ALTER is used to update the structure of the table (add/remove field/index etc). 
Whereas UPDATE is used to update data.
*/

/*
DROP command deleting the table and its structure from the data base.

-- DROP TABLE tbl_user;

DELETE command used for deleting the records(rows) from the table,and it removing the table space which is allocated by the data base, 
and returns number of rows deleted.

-- DELETE FROM tbl_user WHERE id = 1;

TRUNCATE command is also delete the records but it doesn't delete the table space which is created by the data base, 
and does not return number of deleted rows.

-- TRUNCATE TABLE tbl_user;
*/

