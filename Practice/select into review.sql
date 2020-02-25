use classicmodels;

create table projects(
	project_id INT auto_increment, 
    name varchar(20) not null, 
    start_date date, 
    end_date date, 
    primary key(project_id)
); 

INSERT INTO 
    projects(name, start_date, end_date)
VALUES
    ('AI for Marketing','2019-08-01','2019-12-31'),
    ('ML for Sales','2019-05-15','2019-11-20');
    
select * from projects;

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

--  all customers from California, USA: 
select * from customers limit 1; 
select 
	customerNumber, 
    customerName, 
    phone, 
    addressLine1, 
    addressLine2, 
    city, 
    state, 
    postalCode, 
    country
from 
	customers
where 
	country = 'USA' AND
    state = 'CA';
    
-- now plug into suppliers; 
insert into suppliers (
	supplierName, 
    phone, 
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    customerNumber
)
SELECT 
    customerName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state ,
    postalCode,
    country,
    customerNumber
FROM 
    customers
WHERE 
    country = 'USA' AND 
    state = 'CA'; 

select * from suppliers; 
 	
CREATE TABLE stats (
    totalProduct INT,
    totalCustomer INT,
    totalOrder INT
);

-- use the INSERT statement to insert values that come from the SELECT statements:
insert into stats (totalProduct, totalCustomer, totalOrder)
values(
	(select count(*) from products), -- 여기서 반드시 (select condition ), (select condition), 이런 식으로 해야함
	(select count(*) from customers), 
	(select count(*) from orders)
);

set @a = (select count(*) from products);
select @a;
