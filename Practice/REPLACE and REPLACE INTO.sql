-- REPLACE 
/*
To use the REPLACE statement, you need to have at least both INSERT and DELETE privileges for the table.

REPLACE [INTO] table_name(column_list)
VALUES(value_list);
*/
use classicmodels;

CREATE TABLE cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    population INT NOT NULL
);

INSERT INTO cities(name,population)
VALUES('New York',8008278),
      ('Los Angeles',3694825),
      ('San Diego',1223405);
select * from cities;

-- to update the population of the Los Angeles city to 3696820 by using replace: 

-- use update first
update cities 
set population = 3696820
where name like "los%";
select*from cities;

-- replace 
replace into cities (id, population)
values(2, 4444444);
select* from cities;

/*
The value in the name column is NULL now. The REPLACE statement works as follows:

First, REPLACE statement attempted to insert a new row into cities the table. 
The insertion failed because the id 2 already exists in the cities table.

Then, REPLACE statement deleted the row with id 2 and inserted a new row with the same id 2 and population 3696820. 
Because no value is specified for the name column, it was set to NULL.

SO, it is better to replace values by columns like followings: 
REPLACE INTO table
SET column1 = value1,
    column2 = value2;
*/

replace into cities
set 
	id = 4, 
	name = 'Phoenix', -- city = 'Phoenix': column name does not match so should go with name 
    population = 1768980;

select * from cities;

-- this is same as the insert into () select
REPLACE INTO 
    cities(name,population)
SELECT 
    name,
    population 
FROM 
   cities 
WHERE id = 1;

select * from cities;
