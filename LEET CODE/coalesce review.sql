use classicmodels; 

# shwo name, city, state, country of customers from customers: 
SELECT 
	customerName, city, state, country 
FROM 
	customers; 

# if the state has null then show as "NA"
SELECT 
    customerName, city, COALESCE(state, 'NA') as state, country
FROM
    customers;
    
CREATE TABLE articles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    excerpt TEXT,
    body TEXT NOT NULL,
    published_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO articles(title,excerpt,body)
VALUES('MySQL COALESCE Tutorial','This tutorial is about MySQL COALESCE function', 'all about COALESCE function'),
      ('MySQL 8.0 New Features',null, 'The following is a list of new features in MySQL 8.0');

select * from articles; 
      
# display articles on an overview page where each article contains the title, expert, and publish date
SELECT 
	id, title, excerpt, published_at
FROM 
	articles;

# for the missing excerpt, fill it with body
SELECT 
	id, title, COALESCE(excerpt, LEFT(body, 150)) as excerpt, published_at
FROM 
	articles;

SELECT 
	id, title, IFNULL(excerpt, LEFT(body, 150)) as excerpt, published_at
FROM 
	articles;

SELECT 
    id,
    title,
    (CASE
        WHEN excerpt IS NULL THEN LEFT(body, 150)
        ELSE excerpt
    END) AS excerpt,
    published_at
FROM
    articles;