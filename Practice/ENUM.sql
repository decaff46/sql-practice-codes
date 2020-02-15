-- ENUM 

USE classicmodels;
/*
ENUM is a string object whose value is chosen from a list of permitted values defined at the time of column creation.

The ENUM data type provides the following advantages:

    Compact data storage. MySQL ENUM uses numeric indexes (1, 2, 3, …) to represents string values.
    Readable queries and output.
	
CREATE TABLE table_name (
    ...
    col ENUM ('value1','value2','value3'),
    ...
);
*/

create table tickets(
	id int auto_increment primary key, 
    title varchar(30) not null, 
    priority ENUM('low', 'medium', 'high') not null 
);

alter table tickets modify title varchar(100) not null;

insert ignore into tickets(title, priority)
values('Scan virus for computer A', 'High');
-- delete from tickets where id = 2;
select* from tickets;

INSERT INTO tickets(title, priority)
VALUES('Upgrade Windows OS for all computers', 1);

insert into tickets(title, priority)
values('Install Google Chrome for Mr. John', 'Medium'),
      ('Create a new user for the new employee David', 3); 
      
INSERT INTO tickets(title)
VALUES('Refresh the computer of Ms. Lily'); -- now using non-strict so it will give 'low' into the priority

SELECT @@sql_mode;
SET GLOBAL sql_mode='STRICT_TRANS_TABLES'; 
/* In the non-strict SQL mode, if you insert an invalid value into an ENUM column, 
MySQL will use an empty string '' with the numeric index 0 for inserting. 

In case the strict SQL mode is enabled, 
trying to insert an invalid ENUM value will result in an error.
*/

SELECT 
    *
FROM
    tickets
WHERE
    priority = 'High'; -- or 3

-- sort by priority: 
SELECT 
    title, priority
FROM
    tickets
ORDER BY priority DESC;

/*
-- disadvantages:
1. 	Changing enumeration members requires rebuilding the entire table using the ALTER TABLE statement, which is expensive in terms of resources and time.
2. 	Getting the complete enumeration list is complex because you need to access the information_schema database:

SELECT 
    column_type
FROM
	information_schema.COLUMNS
WHERE
	TABLE_NAME = 'tickets' AND COLUMN_NAME = 'priority';

3. 	Porting to other RDBMS could be an issue because ENUM is not SQL-standard and not many database system support it.
4. 	Adding more attributes to the enumeration list is impossible. 
	Suppose you want to add a service agreement for each priority e.g., High (24h), Medium (1-2 days), Low (1 week), it is not possible with ENUM. 
	In this case, you need to have a separate table for storing priority list e.g., priorities(id, name, sort_order, description) 
	and replace the priority field in the tickets table by priority_id that references to the id field of the priorities table.

5. 	Comparing to the look-up table (priorities), an enumeration list is not reusable. For example, if you want to create a new table named tasks and want to reuse the priority list, it is not possible.
*/