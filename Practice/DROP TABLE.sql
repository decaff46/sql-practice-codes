USE	classicmodels;

-- DROP TABLE
/*
DROP [TEMPORARY] TABLE [IF EXISTS] table_name [, table_name] ...
[RESTRICT | CASCADE]

The TEMPORARY option allows you to remove temporary tables only. It ensures that you do not accidentally remove non-temporary tables.
Note that the DROP TABLE statement only drops tables. It doesn’t remove specific user privileges associated with the tables. 
Therefore, if you create a table with the same name as the dropped one.


*/

CREATE TABLE insurances (
    id INT AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    effectiveDate DATE NOT NULL,
    duration INT NOT NULL,
    amount DEC(10 , 2 ) NOT NULL,
    PRIMARY KEY(id)
);

DROP TABLE insurances;

CREATE TABLE CarAccessories (
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DEC(10 , 2 ) NOT NULL,
    PRIMARY KEY(id)
);
 
CREATE TABLE CarGadgets (
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DEC(10 , 2 ) NOT NULL,
    PRIMARY KEY(id)
);

DROP TABLE CarAccessories, CarGadgets;

-- try to drop non-exists table
DROP TABLE IF EXISTS aliens;
SHOW WARNINGS;

/* table can be dropped with patter
DROP TABLE LIKE '%pattern%'
*/

CREATE TABLE test1(
  id INT AUTO_INCREMENT,
  PRIMARY KEY(id)
);
 
CREATE TABLE IF NOT EXISTS test2 LIKE test1;
CREATE TABLE IF NOT EXISTS test3 LIKE test1;

-- set table schema and pattern matching for tables
SET @schema := 'classicmodels'; -- both := and = work
SET @pattern = 'test%';
/* side note := vs = 
Unlike =, the := operator is never interpreted as a comparison operator. 
This means you can use := in any valid SQL statement (not just in SET statements) to assign a value to a variable.
*/

-- to see the variable: 
select @schema;
select @pattern;

-- construct dynamic sql (DROP TABLE tbl1, tbl2...;)
-- drop table  concat('classicmodels', '.', 'test%'); will not work 
-- show warnings;
SELECT CONCAT('DROP TABLE ',GROUP_CONCAT(CONCAT(@schema,'.',table_name)),';') -- the whole expression gotta be coded. 
INTO @droplike
FROM information_schema.tables
WHERE @schema = database()
AND table_name LIKE @pattern;

-- display the dynamic sql statement
SELECT @droplike;

-- execute dynamic sql
PREPARE stmt FROM @droplike;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


