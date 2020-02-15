-- DELETE

use empdb;
show tables from empdb; 
/*
To delete data from multiple tables using a single DELETE statement, you use the DELETE JOIN statement
To delete all rows in a table without the need of knowing how many rows deleted, 
you should use the TRUNCATE TABLE statement to get better performance.

For a table that has a foreign key constraint, when you delete rows from the parent table, 
the rows in the child table will be deleted automatically by using the ON DELETE CASCADE option.
*/
select * from employees;
-- delete officeCode = 4 from employees table
-- do not run the code
DELETE FROM employees
WHERE
    officeCode = 4;
    
-- delete all data from employees
delete from emoployees;
select * from employees;

-- limit the number of rows to be deleted
DELETE FROM table
LIMIT row_count;

DELETE FROM table_name
ORDER BY c1, c2, ...
LIMIT row_count;


/*
ON DELETE CASCADE referential action for a foreign key that allows you to delete data from child tables automatically 
when you delete the data from the parent table.
*/

use classicmodels;
CREATE TABLE if not exists buildings (
    building_no INT PRIMARY KEY AUTO_INCREMENT,
    building_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
);


INSERT ignore into buildings(building_name,address)
VALUES('ACME Headquaters','3950 North 1st Street CA 95134'),
      ('ACME Sales','5000 North 1st Street CA 95134');

select * from buildings;

CREATE TABLE if not exists rooms (
    room_no INT PRIMARY KEY AUTO_INCREMENT,
    room_name VARCHAR(255) NOT NULL,
    building_no INT NOT NULL,
    FOREIGN KEY (building_no)
        REFERENCES buildings (building_no)
        ON DELETE CASCADE
);

INSERT ignore INTO rooms(room_name,building_no)
VALUES('Amazon',1),
      ('War Room',1),
      ('Office of CEO',1),
      ('Marketing',2),
      ('Showroom',2);

select * from rooms;

--  Delete the building with building no. 2:
delete from buildings where  building_no = 2;
	
SELECT * FROM rooms;

/*
it is useful to know which table is affected by the ON DELETE CASCADE  referential action when you delete data from a table. 
You can query this data from the referential_constraints in the information_schema  database as follows:

USE information_schema;
 
SELECT 
    table_name
FROM
    referential_constraints
WHERE
    constraint_schema = 'database_name'
        AND referenced_table_name = 'parent_table'
        AND delete_rule = 'CASCADE'
*/ 

USE information_schema;
SELECT 
    table_name
FROM
    referential_constraints
WHERE
    constraint_schema = 'classicmodels'
        AND referenced_table_name = 'buildings'
        AND delete_rule = 'CASCADE';
        
