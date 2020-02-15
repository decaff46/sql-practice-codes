use classicmodels; 

with recursive cte_cnt(n) as
(
	select 1
    UNION ALL 
    select n + 1
    from cte_cnt
    where n <= 3
) -- the end result will be 1 ~ 4 not 3 
select n 
from cte_cnt; 

-- apply the recursive CTE to query the whole organization structure in the top-down manner as follows:
select * from employees limit 2; 

WITH RECURSIVE org_str AS
(
	SELECT 
		employeeNumber, lastName, firstName, reportsTo, jobTitle, officecode, 1 lvl
	FROM 
		employees
	WHERE 
		reportsTo IS NULL -- this is the anchor 
	
    UNION ALL -- now unioin with the others
    
    SELECT 
		e.employeeNumber, e.lastName, e.firstName, e.reportsTo, e.jobTitle, e.officecode, lvl + 1
	FROM 
		employees as e INNER JOIN org_str as os 
			ON os.employeeNumber = e.reportsTo
	WHERE  -- this where is not needed for real 
		e.reportsTo IS NOT NULL -- this is recursive
) 

SELECT 
	* 
FROM 
	org_str; 
    
-- get their city of offices  as well 
select * from offices limit 2; 
WITH RECURSIVE org_str AS
(
	SELECT 
		employeeNumber, lastName, firstName, reportsTo, jobTitle, officecode, 1 lvl
	FROM 
		employees
	WHERE 
		reportsTo IS NULL -- this is the anchor 
	
    UNION ALL -- now unioin with the others
    
    SELECT 
		e.employeeNumber, e.lastName, e.firstName, e.reportsTo, e.jobTitle, e.officecode, lvl + 1
	FROM 
		employees as e INNER JOIN org_str as os 
			ON os.employeeNumber = e.reportsTo
	WHERE  -- this where is not needed for real 
		e.reportsTo IS NOT NULL -- this is recursive
)
SELECT 
	lastName, firstName, jobTitle, lvl, city
FROM 
	org_str JOIN offices USING(officeCode); -- recursive 의 경우 바로 밑에다가 쓰지 않으면 쓸 수가 없다 


