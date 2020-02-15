use classicmodels;

## Load csv data files 
/*
Before importing the file, you need to prepare the following:

    A database table to which the data from the file will be imported.
    A CSV file with data that matches with the number of columns of the table and the type of data in each column.
    The account, which connects to the MySQL database server, has FILE and INSERT privileges.
*/

create table discoutns(
	id int not null auto_increment, 
    title varchar(225) not null, 
    expired_date date not null, 
    amount decimal(10, 2) null, 
    primary key (id)
);

alter table  discoutns rename disconts; -- fix the typo
alter table disconts rename discounts;
show columns from discounts;	

LOAD DATA INFILE 'c:/tmp/discounts_2.csv'
INTO TABLE discounts
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(title,@expired_date,amount)
SET expired_date = STR_TO_DATE(@expired_date, '%m/%d/%Y');


LOAD DATA LOCAL INFILE  'c:/tmp/discounts.csv'
INTO TABLE discounts
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;