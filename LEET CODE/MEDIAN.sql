use leetcode; 

create table station (
	lat_n int, 
    long_w int
); 

insert into station values
(1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (8,8), (9,9), (10,10), (11,11);

select * from station; 

-- Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to 4 decimal places.
SET @rowIndex := (select count(*) from station); 

SELECT COUNT(*)
INTO   @rowIndex
FROM   station;

select @rowIndex; 
select floor(@rowIndex/2);
select ceil(@rowIndex/2); 

SELECT 
    round(avg(t.lat_n), 4)
from 
(
    SELECT 
        row_number() over(order by lat_n) as rn, 
        s.LAT_N 
    FROM 
        station AS s 
) as t
WHERE t.rn IN (FLOOR(@rowIndex / 2), CEIL(@rowIndex / 2)); 


/*
For the array having odd number of elements, the median is the number at position floor(n/2) + 1. 
For the array with even number of elements, the median is the average of numbers at position n/2 and n/2 + 1. 
For example, for a sorted array with 11 integers, the median is the 6th integer. 
While, for a sorted array with 12 integers, the median is average of the 6th and 7th numbers. 

But what if we count the numbers from index 0? 
For a sorted array with 11 integers, indexes are 0, 1, 2, …, 10, and the index of the median is 5, 
which is exactly half of index of the last element. 

Additionally, for a sorted array with 12 integers, indexes are 0, 1, 2, …, 11, 
and the median is average of numbers of index 5 and 6, 
which are floor and ceil of index of last element divided by 2. 
Therefore, we can sort array and use a variable to count numbers from 0 
and filter records whose indexes are in (ceil(t/2), floor(t/2)) (t is the index of last element). 

And calculate the average as median.
*/

SELECT COUNT(*)
INTO   @rowIndex
FROM   station;

select @rowIndex; 