use classicmodels;
-- UNION ALL 

/*
SELECT column_list
UNION [DISTINCT | ALL]
SELECT column_list
UNION [DISTINCT | ALL]
SELECT column_list
...

To combine result set of two or more queries using the UNION operator, these are the basic rules that you must follow:

    First, the number and the orders of columns that appear in all SELECT statements must be the same.
    Second, the data types of columns must be the same or compatible.

By default, the UNION operator removes duplicate rows even if you don’t specify the DISTINCT operator explicitly.
*/

drop table if exists t1;
drop table if exists t2;

create table t1 (
	id int primary key
);

create table t2 (
	id int primary key
);

insert into t1 values (1), (2), (3);
select * from t1;

insert into t2 values (2), (3), (4);
select * from t2;

-- combines result sets returned from t1 and t2 tables:
select 
	id
from 
	t1
	union
		select id
        from t2; -- 2,3 is common so it will only spits the distinct ones automatically 
	
-- but if i use union ALL 
select 
	id
from 
	t1
	union all
		select id
        from t2; -- then this will give me everything with duplicates

-- count the ids 
with test_tab as
( select 
	id 
from 
	t1
	union all
		select id
        from t2
) 
select 
	id, count(*)
from 
	test_tab
group by
	id;


-- combine the first name and last name of employees and customers into a single result set, you can use the UNION operator as follows:
select 
	firstName, 
    lastName
from 
	employees
	union 
		select 
			contactFirstName, 
            contactLastname
		from 
			customers
order by firstName;

-- differentiate between employees and customers, you can add a column, contactType:

select 
	concat(firstName, " ", lastName) as fullname, 
    'employees' as contactType
from 
	employees
    union 
		select
			concat(contactFirstName, " ", contactLastName) as fullname,
            'customers' as contactType
		from 
			customers
order by 
	fullname;

        