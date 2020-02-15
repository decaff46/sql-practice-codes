use classicmodels;


-- NOT NULL
create table if not exists task_null(
	id int auto_increment primary key, 
    title varchar(100) not null, 
    start_date date not null, 
    end_date date
    );
    
 alter table task_null
 modify title varchar(100) not null; 
    
 describe task_null;   
select * from task_null;

insert into task_null(title, start_date, end_date)
values ('Learn MySQL NOT NULL constraint', '2017-02-01','2017-02-02'),
      ('Check and update NOT NULL constraint to your database', '2017-02-01',NULL);

-- use the IS NULL operator to find rows with NULLs in the column end_date :
select * 
from task_null
where end_date is null;

--  update the NULL values to non-null values. 
-- In this case, you can make up a rule that if the end_date is NULL, the end date is one week after the start date.

set sql_safe_updates = 0;

update task_null
set end_date = start_date +7
where end_date is null;

select * from task_null;

-- add a NOT NULL constraint to the end_date column using the following ALTER TABLE statement:
alter table task_null
change end_date end_date date not null;

alter table task_null
add test varchar(1);
describe task_null;

-- alter table task_null 
-- drop test;

-- Drop a NOT NULL constraint
alter table task_null
modify end_date date;

--------------------------------------- 

-- PRIMARY KEY CONTSTRAINT
CREATE TABLE users(
   user_id INT AUTO_INCREMENT PRIMARY KEY,
   username VARCHAR(40),
   password VARCHAR(255),
   email VARCHAR(255)
);
CREATE TABLE roles(
   role_id INT AUTO_INCREMENT,
   role_name VARCHAR(50),
   PRIMARY KEY(role_id)
);

create table user_role(
	user_id int, 
    role_id int, 
    primary key (user_id, role_id), 
    foreign key (user_id) references users (user_id), 
    foreign key (role_id) references roles (role_id)
    );
	
CREATE TABLE pkdemos(
   id INT,
   title VARCHAR(255) NOT NULL
);

-- use the ALTER TABLEstatement to add a primary key to the table as follows:
alter table pkdemos
add primary key(id);

/*
PRIMARY KEY vs. UNIQUE KEY vs. KEY

KEY is the synonym for INDEX. You use the KEY when you want to create an index for a column or 
a set of columns that is not the part of a primary key or unique key.

A UNIQUE index ensures that values in a column must be unique. Unlike the PRIMARY index, 
MySQL allows NULL values in the UNIQUE index. In addition, a table can have multiple UNIQUE indexes.
*/

-- Add a UNIQUE index for the username column:
alter table users
add unique index username_unique(username ASC);

ALTER TABLE users
ADD UNIQUE INDEX email_unique (email ASC) ;

describe users;

----------------------------

-- CONTRATRAINT
/* 
basic syntax of defining a foreign key constraint in the CREATE TABLE or ALTER TABLE statement:

[CONSTRAINT constraint_name]
FOREIGN KEY [foreign_key_name] (column_name, ...)
REFERENCES parent_table(colunm_name,...)
[ON DELETE reference_option]
[ON UPDATE reference_option]


MySQL has five reference options: CASCADE, SET NULL, NO ACTION, RESTRICT, and SET DEFAULT.

    CASCADE: if a row from the parent table is deleted or updated, the values of the matching rows in the child table automatically deleted or updated.
    SET NULL:  if a row from the parent table is deleted or updated, the values of the foreign key column (or columns) in the child table are set to NULL.
    RESTRICT:  if a row from the parent table has a matching row in the child table, MySQL rejects deleting or updating rows in the parent table.
    NO ACTION: is the same as RESTRICT.
    SET DEFAULT: is recognized by the MySQL parser. However, this action is rejected by both InnoDB and NDB tables.
*/

CREATE DATABASE fkdemo;
USE fkdemo;

CREATE TABLE categories(
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL
) ENGINE=INNODB;

INSERT INTO categories(categoryName)
VALUES
    ('Smartphone'),
    ('Smartwatch');
select * from categories;
 
CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId) 
        REFERENCES categories(categoryId)
) ENGINE=INNODB;
INSERT INTO products(productName, categoryId)
VALUES('iPhone',1); -- categoryId 가 cateogires 에 존재하기에 가능 

INSERT INTO products(productName, categoryId)
VALUES('iPad',3); -- categoryId 가 cateogires 에 존재 하지 않기에 불가능

UPDATE categories
SET categoryId = 100
WHERE categoryId = 1; -- cannot delete or update categoryId 1 since it is referenced by the productId 1 in the products table.

drop table products;

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT NOT NULL,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId) 
    REFERENCES categories(categoryId)
        ON UPDATE CASCADE -- 이런식으로 걸어주면 업뎃 또는 삭제가 가능 하다 
        ON DELETE CASCADE
) ENGINE=INNODB;

INSERT INTO products(productName, categoryId)
VALUES
    ('iPhone', 1), 
    ('Galaxy Note',1),
    ('Apple Watch',2),
    ('Samsung Galary Watch',2);
    
select * from products;

UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;

SELECT * FROM categories;
DELETE FROM categories
WHERE categoryId = 2;

SELECT * FROM products;
SELECT * FROM categories;

DROP TABLE IF EXISTS categories; -- categories는 products에 foreign key 주고 cascade를 안써서 먼저 지울 수가 없다 
DROP TABLE IF EXISTS products;

CREATE TABLE categories(
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL
)ENGINE=INNODB;
 
CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId) 
        REFERENCES categories(categoryId)
        ON UPDATE SET NULL -- when its updated or delete it becomes NULL 
        ON DELETE SET NULL 
)ENGINE=INNODB;

INSERT INTO categories(categoryName)
VALUES
    ('Smartphone'),
    ('Smartwatch');
    
INSERT INTO products(productName, categoryId)
VALUES
    ('iPhone', 1), 
    ('Galaxy Note',1),
    ('Apple Watch',2),
    ('Samsung Galary Watch',2);
    
UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;

SELECT * FROM categories;
select * from products; -- cateogry id is updated so it becomes NULL 

DELETE FROM categories 
WHERE categoryId = 2;
SELECT * FROM products;

-- droping foreign key constatin	
ALTER TABLE products 
DROP FOREIGN KEY fk_category;

describe products;

-- to see the contraints:
SHOW CREATE TABLE categories;
show create table products;

/*
CREATE TABLE `products` (
   `productId` int(11) NOT NULL AUTO_INCREMENT,
   `productName` varchar(100) NOT NULL,
   `categoryId` int(11) DEFAULT NULL,
   PRIMARY KEY (`productId`),
   KEY `fk_category` (`categoryId`)
 ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
*/ -- here, the foreign key fk_contraints is deleted

-- DISABLING FOREIGN KEY CHECK :
SET foreign_key_checks = 0; -- 1 THEN IT WILL CHECK

---------------------------------

-- UNIQUE 
/*	
CREATE TABLE table_name(
   ...
   column_name1 column_definition,
   column_name2 column_definition,
   ...,
   UNIQUE(column_name1,column_name2)
);
*/

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    PRIMARY KEY (supplier_id),
    CONSTRAINT uc_name_address UNIQUE (name , address)
);

INSERT INTO suppliers(name, phone, address) 
VALUES( 'ABC Inc', 
       '(408)-908-2476',
       '4000 North 1st Street');

INSERT INTO suppliers(name, phone, address) 
VALUES( 'XYZ Corporation','(408)-908-2476','3000 North 1st Street');

INSERT INTO suppliers(name, phone, address) 
VALUES( 'XYZ Corporation','(408)-908-3333','3000 North 1st Street');
INSERT INTO suppliers(name, phone, address) 
VALUES( 'ABC Inc', 
       '(408)-908-1111',
       '4000 North 1st Street');
       
SHOW CREATE TABLE suppliers;	
SHOW INDEX FROM suppliers;

/*
To drop a UNIQUE constraint, you use can use DROP INDEX or ALTER TABLE statement:
1
	
DROP INDEX index_name ON table_name;	
ALTER TABLE table_name
DROP INDEX index_name;

For example, the following statement drops the uc_name_address constraint on the suppliers table:
DROP INDEX uc_name_address ON suppliers;

ALTER TABLE suppliers
ADD CONSTRAINT uc_name_address 
UNIQUE (name,address);
*/


----------------------
-- CHECK 
CREATE TABLE parts (
    part_no VARCHAR(18) PRIMARY KEY,
    description VARCHAR(40),
    cost DECIMAL(10,2 ) NOT NULL CHECK (cost >= 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);
