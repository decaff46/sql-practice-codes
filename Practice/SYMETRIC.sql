use leetcode; 

/*
Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.

Write a query to output all such symmetric pairs in ascending order by the value of X
*/

select distinct f1.x, f1.y   
from (select x, y,row_number()over(partition by x, y order by x) as cnt 
       from Functions) f1
join Functions f2
on f1.x=f2.y and f1.y=f2.x and (f1.x!=f1.y or cnt>1)
and f1.x<=f1.y                                  
order by f1.x; 

-- 결국 partition 은 union + group by x,y count(x) >1 과 같은 것 

SELECT f1.x AS x,
       f1.y AS y
FROM   functions f1,
       functions f2
WHERE  f1.x = f2.y
       AND f1.y = f2.x
       AND f1.x < f1.y
UNION
SELECT x,
       y
FROM   functions
WHERE  x = y
GROUP  BY x,
          y
HAVING Count(x) > 1
ORDER  BY x ASC 