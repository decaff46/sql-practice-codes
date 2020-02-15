use classicmodels;

-- CTE works only after 8.0 so if i use before then should go with recursive
/*
WITH RECURSIVE cte_name AS (
    initial_query  -- anchor member
    UNION ALL
    recursive_query -- recursive member that references to the CTE name
)
SELECT * FROM cte_name;

The execution order of a recursive CTE is as follows:

    First, separate the members into two: anchor and recursive members.
    Next, execute the anchor member to form the base result set ( R0) and use this base result set for the next iteration.
    Then, execute the recursive member with Ri result set as an input and make Ri+1 as an output.
    After that, repeat the third step until the recursive member returns an empty result set, in other words, the termination condition is met.
    Finally, combine result sets from R0 to Rn using UNION ALL operator.


Recursive member restrictions

The recursive member must not contain the following constructs:

    Aggregate functions e.g., MAX, MIN, SUM, AVG, COUNT, etc.
    GROUP BY clause
    ORDER BY clause
    LIMIT clause
    DISTINCT

In addition, the recursive member can only reference the CTE name once and in its FROM clause, not in any subquery.
*/    
WITH RECURSIVE cte_count (n) 
AS (
      SELECT 1
      UNION ALL
      SELECT n + 1 
      FROM cte_count 
      WHERE n < 3
    )
SELECT n 
FROM cte_count;

/*
In this example, the following query:
SELECT 1 is the anchor member that returns 1 as the base result set.


SELECT n + 1
FROM cte_count 
WHERE n < 3  is the recursive member because it references to the name of the CTE which is cte_count.

*/

-- apply the recursive CTE to query the whole organization structure in the top-down manner as follows:

WITH RECURSIVE employee_paths AS
  ( SELECT employeeNumber,
           reportsTo as managerNumber,
           officeCode, 
           1 lvl
   FROM employees
   WHERE reportsTo IS NULL
     UNION ALL
     SELECT e.employeeNumber,
            e.reportsTo,
            e.officeCode,
            lvl+1
     FROM employees e
     INNER JOIN employee_paths as ep ON ep.employeeNumber = e.reportsTo )
SELECT employeeNumber,
       managerNumber,
       lvl,
       city
FROM employee_paths ep
INNER JOIN offices o USING (officeCode)
ORDER BY lvl, city;


