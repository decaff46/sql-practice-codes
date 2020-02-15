-- DATA TYPES; 

-- 1. INT

CREATE TABLE classes (
    class_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    total_member INT UNSIGNED,
    PRIMARY KEY (class_id)
);

-- unsigned cannot accept negative values.  see the picture in the folder 
	
CREATE TABLE zerofill_tests(
    id INT AUTO_INCREMENT PRIMARY KEY,
    v1 INT(2) ZEROFILL,
    v2 INT(3) ZEROFILL,
    v3 INT(5) ZEROFILL
);

insert into zerofill_tests(v1,v2,v3)
values (1,2,3);

select * from zerofill_tests;

-- DECIMAL 
/*
column_name  DECIMAL(P,D);
In the syntax above:

    P is the precision that represents the number of significant digits. The range of P is 1 to 65.
    D is the scale that that represents the number of digits after the decimal point. 
    The range of D is 0 and 30. MySQL requires that D is less than or equal to (<=) P.
    
    you can also use DEC, FIXED, or NUMERIC because they are synonyms for DECIMAL.
*/

CREATE TABLE materials(
	id int auto_increment primary key, 
    description varchar(100), 
    cost decimal(19,4) not null
);
INSERT INTO materials(description,cost)
VALUES('Bicycle', 500.34),('Seat',10.23),('Break',5.21);

alter table materials 
	modify cost dec(19,4) zerofill;
select * from materials;

-- BOOLEAN 
SELECT true, false, TRUE, FALSE, True, False;
-- 1 0 1 0 1 0

DROP TABLE IF EXISTS task;
CREATE TABLE if not exists task(
	id int auto_increment primary key, 
    title varchar(222) not null, 
    completed boolean
);

INSERT INTO task(title,completed)
VALUES('Master MySQL Boolean type',true),
      ('Design database table',false); 
      
select * from task;


-- Because Boolean is TINYINT(1), you can insert value other than 1 and 0 into the Boolean column. Consider the following example:
INSERT INTO task(title,completed)
VALUES('Test Boolean with a number',2);

-- output the result as true and false, you can use the IF function as follows:
select 
	id, 
    title,
    if(completed, 'true', 'false') as completed
from 
	task;

select * from  task;

-- get all completed tasks in the tasks table, you might come up with the following query:
select 
	*
from 
	task
where 
	completed = true; -- TRUE\true\True all work
-- above will not give the 3rd item ; so should do IS TRUE

SELECT 
	*
FROM 
	task
WHERE
	completed IS TRUE; -- here is not true | false can be done too 
    
    
    -- CHAR
  CREATE TABLE mysql_char_test (
    status CHAR(3)
);

INSERT INTO mysql_char_test(status)
VALUES('Yes'),('No');

SELECT 
	length(status)
FROM 
	mysql_char_test;
    
INSERT INTO mysql_char_test(status)
VALUES(' y '); -- length(" Y ") = 2

CREATE UNIQUE INDEX uidx_status 
ON mysql_char_test(status); show warnings;
/* 
CHAR column has a UNIQUE index and you insert a value that is different from an existing value in a number of trailing spaces, 
MySQL will reject the changes because of duplicate-key error.
*/


-- DATETIME
-- First, set the timezone of the current connection to +00:00.
SET time_zone = '+00:00';
CREATE TABLE timestamp_n_datetime (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ts TIMESTAMP,
    DT DATETIME
);
INSERT INTO timestamp_n_datetime(ts,DT)
VALUES(NOW(),NOW());

SELECT 
    ts, 
    DT
FROM
    timestamp_n_datetime;
    
SET time_zone = '+03:00';
SELECT 
    ts, 
    DT
FROM
    timestamp_n_datetime;    

SET @DT = now();
select @DT;
SELECT DATE(@DT);
SELECT TIME(@DT);

SELECT 
    HOUR(@DT),
    MINUTE(@DT),
    SECOND(@DT),
    DAY(@DT),
    WEEK(@DT),
    MONTH(@DT),
    QUARTER(@DT),
    YEAR(@DT);

SELECT DATE_FORMAT(@dt, '%H:%i:%s - %W %M %Y') AS `TIME + WKDAYS`; -- CONSTANT 대소문자 구분 없음

SELECT @dt start, 
       DATE_ADD(@dt, INTERVAL 1 SECOND) '1 second later',
       DATE_ADD(@dt, INTERVAL 1 MINUTE) '1 minute later',
       DATE_ADD(@dt, INTERVAL 1 HOUR) '1 hour later',
       DATE_ADD(@dt, INTERVAL 1 DAY) '1 day later',
       DATE_ADD(@dt, INTERVAL 1 WEEK) '1 week later',
       DATE_ADD(@dt, INTERVAL 1 MONTH) '1 month later',
       DATE_ADD(@dt, INTERVAL 1 YEAR) '1 year later';
 
SELECT @dt start, 
       DATE_SUB(@dt, INTERVAL 1 SECOND) '1 second before',
       DATE_SUB(@dt, INTERVAL 1 MINUTE) '1 minute before',
       DATE_SUB(@dt, INTERVAL 1 HOUR) '1 hour before',
       DATE_SUB(@dt, INTERVAL 1 DAY) '1 day before',
       DATE_SUB(@dt, INTERVAL 1 WEEK) '1 week before',
       DATE_SUB(@dt, INTERVAL 1 MONTH) '1 month before',
       DATE_SUB(@dt, INTERVAL 1 YEAR) '1 year before';
       
CREATE TABLE datediff_test (
    dt DATETIME
);

INSERT INTO datediff_test(dt)
VALUES('2010-04-30 07:27:39'),
    ('2010-05-17 22:52:21'),
    ('2010-05-18 01:19:10'),
    ('2010-05-22 14:17:16'),
    ('2010-05-26 03:26:56'),
    ('2010-06-10 04:44:38'),
    ('2010-06-13 13:55:53');

SELECT 
	dt, 
    datediff(now(), dt) as diff
from 
	datediff_test;
    
-- TIMESTAMP
/*
The MySQL TIMESTAMP is a temporal data type that holds the combination of date and time. 
The format of a TIMESTAMP is YYYY-MM-DD HH:MM:SS which is fixed at 19 characters.
The TIMESTAMP value has a range from '1970-01-01 00:00:01' UTC to '2038-01-19 03:14:07' UTC.
When you insert a TIMESTAMP value into a table, MySQL converts it from your connection’s time zone to UTC for storing.
*/

CREATE TABLE test_timestamp (
    t1  TIMESTAMP
);

SET time_zone='+00:00';
INSERT INTO test_timestamp(t1)
VALUES('2008-01-01 00:00:01');

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO categories(name) 
VALUES ('A');

SELECT * FROM categories;

ALTER TABLE categories
ADD COLUMN updated_at 
  TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
  ON UPDATE CURRENT_TIMESTAMP;


INSERT INTO categories(name)
VALUES('B');

SELECT * FROM categories;

update categories
set name = 'b+'
where id = 2;