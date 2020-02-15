use classicmodels;

alter table customers_all rename to customers;
alter table customers rename customers_shorten; -- rename table name rename (to) new_name

select count(*) from customers;
select count(*) from customers_shorten;

-- ALTER TABLE
/* ALTER TABLE table_name ADD

ALTER TABLE table_name
ADD 
    new_column_name column_definition
    [FIRST | AFTER column_name]

ALTER TABLE table_name
    ADD new_column_name column_definition
    [FIRST | AFTER column_name],
    ADD new_column_name column_definition
    [FIRST | AFTER column_name],
    ...;

*/
    
CREATE TABLE vehicles (
    vehicleId INT,
    year INT NOT NULL,
    make VARCHAR(100) NOT NULL,
    PRIMARY KEY(vehicleId)
);    

ALTER TABLE vehicles
ADD color VARCHAR(50),
ADD note VARCHAR(255);

alter table vehicles
add test varchar(1) first;

describe vehicles;

/* modify
ALTER TABLE table_name
MODIFY column_name column_definition
[ FIRST | AFTER column_name];  

ALTER TABLE table_name
    MODIFY column_name column_definition
    [ FIRST | AFTER column_name],
    MODIFY column_name column_definition
    [ FIRST | AFTER column_name],
    ...;
*/

-- modify
ALTER TABLE vehicles 
MODIFY note VARCHAR(100) NOT NULL;
	
ALTER TABLE vehicles 
MODIFY year SMALLINT NOT NULL,
MODIFY color VARCHAR(20) NULL AFTER make;

alter table vehicles
modify test smallint(2) not null;

describe vehicles;

-- column name change
ALTER TABLE vehicles 
CHANGE COLUMN note vehicleCondition VARCHAR(100) NOT NULL;

-- table name change!!!
alter table vehicles rename vehicleCondition;

/* drop column
ALTER TABLE table_name
DROP COLUMN column_name;

alter table table_name
drop column column_name, 
drop column column_name,
...;		
*/

alter table vehicles
add test2 varchar(20);

describe vehicles;
alter table vehicles
drop test, 
drop test2;


/* alter table name
ALTER TABLE table_name
RENAME TO new_table_name;
*/
	
ALTER TABLE vehicles 
RENAME TO cars; 