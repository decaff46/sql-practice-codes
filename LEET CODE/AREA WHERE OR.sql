use leetcode;

Create table If Not Exists World (name varchar(255), continent varchar(255), area int, population int, gdp int);
Truncate table World;
insert into World (name, continent, area, population, gdp) values ('Afghanistan', 'Asia', '652230', '25500100', '203430000');
insert into World (name, continent, area, population, gdp) values ('Albania', 'Europe', '28748', '2831741', '129600000');
insert into World (name, continent, area, population, gdp) values ('Algeria', 'Africa', '2381741', '37100000', '1886810000');
insert into World (name, continent, area, population, gdp) values ('Andorra', 'Europe', '468', '78115', '37120000');
insert into World (name, continent, area, population, gdp) values ('Angola', 'Africa', '1246700', '20609294', '1009900000');

select * from world;

-- A country is big if it has an area of bigger than 3 million square km 
-- or a population of more than 25 million.
-- Write a SQL solution to output big countries' name, population and area.
select 
	name, population, area
from 
	world
where
	population > 25000000 or area > 3000000;
    
## Answer 2
SELECT
    name, population, area
FROM
    world
WHERE
    area > 3000000

UNION

SELECT
    name, population, area
FROM
    world
WHERE
    population > 25000000
;