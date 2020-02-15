-- INSERT INTO SELECT 
use classicmodels;
CREATE TABLE suppliers (
    supplierNumber INT AUTO_INCREMENT,
    supplierName VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    addressLine1 VARCHAR(50),
    addressLine2 VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postalCode VARCHAR(50),
    country VARCHAR(50),
    customerNumber INT,
    PRIMARY KEY (supplierNumber)
);

-- Suppose all customers from California, USA become the company’s suppliers. 
-- The following query finds all customers who locate in California, USA:

select 
	customerNumber, 
    customerName, 
    phone,
    addressLine1,
    city,
    state,
    postalCode,
    country
from 
	customers
where 
	state = 'CA';

CREATE TABLE if not exists suppliers (
    supplierNumber INT AUTO_INCREMENT,
    supplierName VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    addressLine1 VARCHAR(50),
    addressLine2 VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postalCode VARCHAR(50),
    country VARCHAR(50),
    customerNumber INT,
    PRIMARY KEY (supplierNumber)
);

alter table suppliers drop addressLine1, drop addressLine2;
-- alter table suppliers drop address;
alter table suppliers add column address varchar(50) after phone ; 
-- alter table suppliers drop address;
/*
ALTER TABLE table
 ADD [COLUMN] column_name_1 column_1_definition [FIRST|AFTER existing_column],
 ADD [COLUMN] column_name_2 column_2_definition [FIRST|AFTER existing_column]
 */
show columns from suppliers;

insert into suppliers (
	supplierName, 
    phone, 
    address, 
    city, 
    state, 
    postalCode, 
    customerNumber
) 	select 
		customerName, 
		phone,
		addressLine1,
		city,
		state,
		postalCode,
		customerNumber
	from 
		customers
	where 
		state = 'CA' and country  = 'usa';
        
	select * from suppliers;
    
    drop table if exists suppliers;
    create table if not exists suppliers like customers;
    select * from suppliers;
    
    CREATE TABLE stats (
    totalProduct INT,
    totalCustomer INT,
    totalOrder INT
);

-- use the INSERT statement to insert values that come from the SELECT statements:
INSERT INTO stats(totalProduct, totalCustomer, totalOrder)
VALUES(
    (SELECT COUNT(*) FROM products),
    (SELECT COUNT(*) FROM customers),
    (SELECT COUNT(*) FROM orders)
);