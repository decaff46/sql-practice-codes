-- To get the whole organization structure:
use classicmodels;
show columns from employees;
-- reportsto column is used to determine the manager id of an employee.
select * from employees limit 5;

/* // Result: LastName, FirstName (MiddleName)
CONCAT_WS( '', LastName, ', ', FirstName, ' (', MiddleName, ')' ) */

select 
	concat(e1.lastName, ', ', e1.firstName, '-', e1.jobTitle) as manager,
    concat_ws('', e2.lastName, ', ', e2.firstName, '-', e2.jobTitle) as director
from 
	employees as e1
    inner join employees as e2
    on e2.employeeNumber  = e1.reportsTo
order by manager;

--  you don’t see the President because his name is filtered out due to the INNER JOIN clause.
--  to make it happen use leftjoin and set the ifnull for the manager. 

select 
    ifnull(concat(m.lastName, ', ', m.firstName, '-', m.jobTitle), 'top manager') as manager,
    concat_ws('', e.lastName, ', ', e.firstName, '-', e.jobTitle) as 'direct report'
from 
	employees as e
    left join employees as m
    on m.employeeNumber  = e.reportsTo
order by manager DESC;
