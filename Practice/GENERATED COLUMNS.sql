USE classicmodels;
-- GENERATED COLUMNS

/*
When you create a new table, you specify the table columns in the CREATE TABLE statement. 
Then, you use the INSERT, UPDATE, and DELETE statements to modify directly the data in the table columns.

MySQL 5.7 introduced a new feature called the generated column. 
Columns are generated because the data in these columns are computed based on predefined expressions.
*/

DROP TABLE IF EXISTS contacts;
 
CREATE TABLE contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL
);

-- To get the full name of a contact, you use the CONCAT() function as follows:
select 
	id, 
	concat(first_name, " ", last_name) as fullname, 
    email
from 
	contacts;
    
-- 이런 식으로 다시 변형을 해야 하는 귀찮음이 있다 그래서 이렇게 하면된다 
DROP TABLE IF EXISTS contacts;
 
CREATE TABLE contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    fullname varchar(101) GENERATED ALWAYS AS (CONCAT(first_name,' ',last_name)), -- 이런 식으로 !!
    email VARCHAR(100) NOT NULL
);

-- 이렇게 해놓으면, insert에서 fullname값을 주지 않아도 자동으로 만들어짐 
INSERT INTO contacts(first_name,last_name, email)
VALUES('john','doe','john.doe@mysqltutorial.org');

select * from contacts;

/* basic syntax
column_name data_type [GENERATED ALWAYS] AS (expression)
   [VIRTUAL | STORED] [UNIQUE [KEY]]
*/

-- add a stored generated column named stock_value to the products table using the following ALTER TABLE ...ADD COLUMN statement:
alter table products
add column stock_value double generated always as(buyprice * quantityinstock) stored;

show columns from products;

SELECT 
    productName, 
    ROUND(stock_value, 2) stockValue
FROM
    products;